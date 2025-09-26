import 'package:niffer_store/core/enums/payment_method.dart';
import 'package:niffer_store/core/enums/transaction_status.dart';

class POSTransactionItem {
  final String id;
  final String productId;
  final String productName;
  final String productSku;
  final double unitPrice;
  final int quantity;
  final double discount;
  final double taxRate;
  final String? notes;

  const POSTransactionItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productSku,
    required this.unitPrice,
    required this.quantity,
    this.discount = 0.0,
    this.taxRate = 0.0,
    this.notes,
  });

  double get subtotal => unitPrice * quantity;
  double get discountAmount => subtotal * (discount / 100);
  double get taxAmount => (subtotal - discountAmount) * (taxRate / 100);
  double get total => subtotal - discountAmount + taxAmount;
}

class POSTransaction {
  final String id;
  final String storeId;
  final String cashierId; // User ID of the person making the sale
  final String? customerId; // Optional customer ID for loyalty programs
  final String? customerName;
  final String? customerPhone;
  final String? customerEmail;
  final List<POSTransactionItem> items;
  final double subtotal;
  final double totalDiscount;
  final double totalTax;
  final double totalAmount;
  final PaymentMethod paymentMethod;
  final double amountPaid;
  final double changeGiven;
  final TransactionStatus status;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? receiptNumber;
  final Map<String, dynamic>? metadata; // For additional data like payment gateway info

  const POSTransaction({
    required this.id,
    required this.storeId,
    required this.cashierId,
    this.customerId,
    this.customerName,
    this.customerPhone,
    this.customerEmail,
    required this.items,
    required this.subtotal,
    required this.totalDiscount,
    required this.totalTax,
    required this.totalAmount,
    required this.paymentMethod,
    required this.amountPaid,
    this.changeGiven = 0.0,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.receiptNumber,
    this.metadata,
  });

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  
  bool get isRefund => totalAmount < 0;
  bool get hasCustomer => customerId != null || customerName != null;
  
  // Calculate totals from items (for validation)
  double get calculatedSubtotal => items.fold(0.0, (sum, item) => sum + item.subtotal);
  double get calculatedDiscount => items.fold(0.0, (sum, item) => sum + item.discountAmount);
  double get calculatedTax => items.fold(0.0, (sum, item) => sum + item.taxAmount);
  double get calculatedTotal => items.fold(0.0, (sum, item) => sum + item.total);
}

class POSTransactionSummary {
  final String storeId;
  final DateTime date;
  final int totalTransactions;
  final double totalSales;
  final double totalDiscount;
  final double totalTax;
  final double totalRefunds;
  final Map<PaymentMethod, double> paymentMethodBreakdown;
  final Map<String, int> topSellingProducts; // productId -> quantity sold

  const POSTransactionSummary({
    required this.storeId,
    required this.date,
    required this.totalTransactions,
    required this.totalSales,
    required this.totalDiscount,
    required this.totalTax,
    required this.totalRefunds,
    required this.paymentMethodBreakdown,
    required this.topSellingProducts,
  });

  double get netSales => totalSales - totalRefunds;
  double get averageTransactionValue => totalTransactions > 0 ? totalSales / totalTransactions : 0.0;
}