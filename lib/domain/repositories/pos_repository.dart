import 'package:niffer_store/domain/entities/pos_transaction.dart';
import 'package:niffer_store/core/enums/payment_method.dart';
import 'package:niffer_store/core/enums/transaction_status.dart';

abstract class POSRepository {
  // Transaction Management
  Future<POSTransaction> createTransaction(POSTransaction transaction);
  Future<POSTransaction?> getTransactionById(String id);
  Future<List<POSTransaction>> getTransactionsByStore(
    String storeId, {
    DateTime? startDate,
    DateTime? endDate,
    TransactionStatus? status,
    int limit = 50,
    int offset = 0,
  });
  Future<POSTransaction> updateTransaction(POSTransaction transaction);
  Future<bool> deleteTransaction(String id);

  // Transaction Operations
  Future<POSTransaction> processTransaction(POSTransaction transaction);
  Future<POSTransaction> refundTransaction(String transactionId, {
    double? refundAmount,
    String? reason,
  });
  Future<POSTransaction> voidTransaction(String transactionId, String reason);

  // Receipt Management
  Future<String> generateReceiptNumber(String storeId);
  Future<Map<String, dynamic>> getReceiptData(String transactionId);
  Future<bool> emailReceipt(String transactionId, String email);
  Future<bool> printReceipt(String transactionId);

  // Analytics and Reporting
  Future<POSTransactionSummary> getDailySummary(String storeId, DateTime date);
  Future<List<POSTransactionSummary>> getPeriodSummary(
    String storeId,
    DateTime startDate,
    DateTime endDate,
  );
  Future<Map<PaymentMethod, double>> getPaymentMethodBreakdown(
    String storeId,
    DateTime startDate,
    DateTime endDate,
  );
  Future<List<Map<String, dynamic>>> getTopSellingProducts(
    String storeId,
    DateTime startDate,
    DateTime endDate, {
    int limit = 10,
  });

  // Customer Management
  Future<List<POSTransaction>> getCustomerTransactions(String customerId);
  Future<Map<String, dynamic>> getCustomerStats(String customerId);

  // Real-time Data
  Stream<POSTransaction> transactionStream(String storeId);
  Stream<POSTransactionSummary> dailySummaryStream(String storeId);
}