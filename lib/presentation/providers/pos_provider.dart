import 'package:flutter/foundation.dart';
import 'package:niffer_store/domain/entities/pos_transaction.dart';
import 'package:niffer_store/domain/entities/product.dart';
import 'package:niffer_store/domain/repositories/pos_repository.dart';
import 'package:niffer_store/core/enums/payment_method.dart';
import 'package:niffer_store/core/enums/transaction_status.dart';

class POSProvider extends ChangeNotifier {
  final POSRepository _posRepository;

  POSProvider(this._posRepository);

  // Current transaction state
  List<POSTransactionItem> _currentItems = [];
  String? _customerId;
  String? _customerName;
  String? _customerPhone;
  String? _customerEmail;
  PaymentMethod _selectedPaymentMethod = PaymentMethod.cash;
  double _amountPaid = 0.0;
  String? _notes;
  bool _isProcessing = false;

  // Recent transactions
  List<POSTransaction> _recentTransactions = [];
  POSTransactionSummary? _todaySummary;

  // Getters
  List<POSTransactionItem> get currentItems => _currentItems;
  String? get customerId => _customerId;
  String? get customerName => _customerName;
  String? get customerPhone => _customerPhone;
  String? get customerEmail => _customerEmail;
  PaymentMethod get selectedPaymentMethod => _selectedPaymentMethod;
  double get amountPaid => _amountPaid;
  String? get notes => _notes;
  bool get isProcessing => _isProcessing;
  List<POSTransaction> get recentTransactions => _recentTransactions;
  POSTransactionSummary? get todaySummary => _todaySummary;

  // Cart calculations
  double get subtotal => _currentItems.fold(0.0, (sum, item) => sum + item.subtotal);
  double get totalDiscount => _currentItems.fold(0.0, (sum, item) => sum + item.discountAmount);
  double get totalTax => _currentItems.fold(0.0, (sum, item) => sum + item.taxAmount);
  double get total => _currentItems.fold(0.0, (sum, item) => sum + item.total);
  int get itemCount => _currentItems.fold(0, (sum, item) => sum + item.quantity);
  double get changeAmount => _amountPaid - total;
  bool get hasItems => _currentItems.isNotEmpty;
  bool get canProcessTransaction => hasItems && _amountPaid >= total;

  // Cart Management
  void addProduct(Product product, {int quantity = 1, double discount = 0.0}) {
    final existingIndex = _currentItems.indexWhere((item) => item.productId == product.id);
    
    if (existingIndex >= 0) {
      // Update existing item
      final existingItem = _currentItems[existingIndex];
      _currentItems[existingIndex] = POSTransactionItem(
        id: existingItem.id,
        productId: existingItem.productId,
        productName: existingItem.productName,
        productSku: existingItem.productSku,
        unitPrice: existingItem.unitPrice,
        quantity: existingItem.quantity + quantity,
        discount: discount,
        taxRate: existingItem.taxRate,
        notes: existingItem.notes,
      );
    } else {
      // Add new item
      _currentItems.add(POSTransactionItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        productId: product.id,
        productName: product.name,
        productSku: product.sku,
        unitPrice: product.finalPrice,
        quantity: quantity,
        discount: discount,
        taxRate: 0.0, // Default tax rate
      ));
    }
    notifyListeners();
  }

  void updateItemQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      removeItem(itemId);
      return;
    }

    final index = _currentItems.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      final item = _currentItems[index];
      _currentItems[index] = POSTransactionItem(
        id: item.id,
        productId: item.productId,
        productName: item.productName,
        productSku: item.productSku,
        unitPrice: item.unitPrice,
        quantity: quantity,
        discount: item.discount,
        taxRate: item.taxRate,
        notes: item.notes,
      );
      notifyListeners();
    }
  }

  void updateItemDiscount(String itemId, double discount) {
    final index = _currentItems.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      final item = _currentItems[index];
      _currentItems[index] = POSTransactionItem(
        id: item.id,
        productId: item.productId,
        productName: item.productName,
        productSku: item.productSku,
        unitPrice: item.unitPrice,
        quantity: item.quantity,
        discount: discount.clamp(0.0, 100.0),
        taxRate: item.taxRate,
        notes: item.notes,
      );
      notifyListeners();
    }
  }

  void removeItem(String itemId) {
    _currentItems.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  void clearCart() {
    _currentItems.clear();
    _customerId = null;
    _customerName = null;
    _customerPhone = null;
    _customerEmail = null;
    _amountPaid = 0.0;
    _notes = null;
    notifyListeners();
  }

  // Customer Management
  void setCustomer({
    String? id,
    String? name,
    String? phone,
    String? email,
  }) {
    _customerId = id;
    _customerName = name;
    _customerPhone = phone;
    _customerEmail = email;
    notifyListeners();
  }

  void clearCustomer() {
    _customerId = null;
    _customerName = null;
    _customerPhone = null;
    _customerEmail = null;
    notifyListeners();
  }

  // Payment Management
  void setPaymentMethod(PaymentMethod method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }

  void setAmountPaid(double amount) {
    _amountPaid = amount;
    notifyListeners();
  }

  void setNotes(String? notes) {
    _notes = notes;
    notifyListeners();
  }

  // Transaction Processing
  Future<POSTransaction?> processTransaction(String storeId, String cashierId) async {
    if (!canProcessTransaction || _isProcessing) return null;

    _isProcessing = true;
    notifyListeners();

    try {
      final transaction = POSTransaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        storeId: storeId,
        cashierId: cashierId,
        customerId: _customerId,
        customerName: _customerName,
        customerPhone: _customerPhone,
        customerEmail: _customerEmail,
        items: _currentItems,
        subtotal: subtotal,
        totalDiscount: totalDiscount,
        totalTax: totalTax,
        totalAmount: total,
        paymentMethod: _selectedPaymentMethod,
        amountPaid: _amountPaid,
        changeGiven: changeAmount,
        status: TransactionStatus.completed,
        notes: _notes,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        receiptNumber: await _posRepository.generateReceiptNumber(storeId),
      );

      final processedTransaction = await _posRepository.processTransaction(transaction);
      
      // Add to recent transactions
      _recentTransactions.insert(0, processedTransaction);
      if (_recentTransactions.length > 50) {
        _recentTransactions.removeLast();
      }

      // Clear current transaction
      clearCart();
      
      // Refresh today's summary
      await loadTodaySummary(storeId);

      return processedTransaction;
    } catch (e) {
      debugPrint('Error processing transaction: $e');
      return null;
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  // Data Loading
  Future<void> loadRecentTransactions(String storeId) async {
    try {
      final transactions = await _posRepository.getTransactionsByStore(
        storeId,
        startDate: DateTime.now().subtract(const Duration(days: 7)),
        limit: 50,
      );
      _recentTransactions = transactions;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading recent transactions: $e');
    }
  }

  Future<void> loadTodaySummary(String storeId) async {
    try {
      final summary = await _posRepository.getDailySummary(storeId, DateTime.now());
      _todaySummary = summary;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading today\'s summary: $e');
    }
  }

  // Transaction Operations
  Future<bool> refundTransaction(String transactionId, {double? amount, String? reason}) async {
    try {
      await _posRepository.refundTransaction(transactionId, refundAmount: amount, reason: reason);
      // Refresh data
      await loadRecentTransactions(_todaySummary?.storeId ?? '');
      await loadTodaySummary(_todaySummary?.storeId ?? '');
      return true;
    } catch (e) {
      debugPrint('Error refunding transaction: $e');
      return false;
    }
  }

  Future<bool> voidTransaction(String transactionId, String reason) async {
    try {
      await _posRepository.voidTransaction(transactionId, reason);
      // Refresh data
      await loadRecentTransactions(_todaySummary?.storeId ?? '');
      await loadTodaySummary(_todaySummary?.storeId ?? '');
      return true;
    } catch (e) {
      debugPrint('Error voiding transaction: $e');
      return false;
    }
  }

  // Receipt Management
  Future<bool> printReceipt(String transactionId) async {
    try {
      return await _posRepository.printReceipt(transactionId);
    } catch (e) {
      debugPrint('Error printing receipt: $e');
      return false;
    }
  }

  Future<bool> emailReceipt(String transactionId, String email) async {
    try {
      return await _posRepository.emailReceipt(transactionId, email);
    } catch (e) {
      debugPrint('Error emailing receipt: $e');
      return false;
    }
  }
}