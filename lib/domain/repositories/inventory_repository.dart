import 'package:niffer_store/domain/entities/inventory_movement.dart';
import 'package:niffer_store/core/enums/inventory_movement_type.dart';

abstract class InventoryRepository {
  // Inventory Tracking
  Future<InventorySnapshot?> getInventorySnapshot(String productId, String storeId);
  Future<List<InventorySnapshot>> getStoreInventory(String storeId);
  Future<InventorySnapshot> updateStock(
    String productId,
    String storeId,
    int newQuantity,
    String userId,
    {String? reason}
  );

  // Movement Management
  Future<InventoryMovement> recordMovement(InventoryMovement movement);
  Future<List<InventoryMovement>> getMovementHistory(
    String productId,
    String storeId, {
    DateTime? startDate,
    DateTime? endDate,
    InventoryMovementType? type,
    int limit = 50,
  });
  Future<List<InventoryMovement>> getAllMovements(
    String storeId, {
    DateTime? startDate,
    DateTime? endDate,
    InventoryMovementType? type,
    int limit = 100,
  });

  // Stock Operations
  Future<bool> reserveStock(String productId, String storeId, int quantity);
  Future<bool> releaseReservedStock(String productId, String storeId, int quantity);
  Future<InventoryMovement> adjustStock(
    String productId,
    String storeId,
    int adjustment,
    String userId,
    String reason,
  );
  Future<List<InventoryMovement>> processStocktake(
    String storeId,
    Map<String, int> actualCounts, // productId -> actual count
    String userId,
  );

  // Alerts and Monitoring
  Future<List<StockAlert>> getStockAlerts(String storeId);
  Future<List<InventorySnapshot>> getLowStockItems(String storeId);
  Future<List<InventorySnapshot>> getOutOfStockItems(String storeId);
  Future<bool> resolveStockAlert(String alertId, String userId);

  // Reporting
  Future<InventoryReport> generateInventoryReport(String storeId, DateTime date);
  Future<Map<String, dynamic>> getStockTurnoverReport(
    String storeId,
    DateTime startDate,
    DateTime endDate,
  );
  Future<Map<String, dynamic>> getABCAnalysis(String storeId);
  Future<List<Map<String, dynamic>>> getSlowMovingItems(
    String storeId,
    int daysThreshold,
  );

  // Reorder Management
  Future<List<InventorySnapshot>> getReorderSuggestions(String storeId);
  Future<bool> updateReorderLevels(
    String productId,
    String storeId,
    int reorderLevel,
    int maxLevel,
  );

  // Real-time Streams
  Stream<InventorySnapshot> inventoryStream(String storeId);
  Stream<List<StockAlert>> stockAlertsStream(String storeId);
  Stream<InventoryMovement> movementStream(String storeId);

  // Bulk Operations
  Future<List<InventoryMovement>> bulkUpdateStock(
    Map<String, int> productQuantities, // productId -> new quantity
    String storeId,
    String userId,
    InventoryMovementType type,
    String reason,
  );
  Future<bool> importInventoryData(
    List<Map<String, dynamic>> inventoryData,
    String storeId,
    String userId,
  );
  Future<List<Map<String, dynamic>>> exportInventoryData(String storeId);
}