import 'package:niffer_store/core/enums/inventory_movement_type.dart';

class InventoryMovement {
  final String id;
  final String productId;
  final String productSku;
  final String productName;
  final String storeId;
  final InventoryMovementType type;
  final int quantityChange; // Positive for additions, negative for deductions
  final int quantityBefore;
  final int quantityAfter;
  final String? referenceId; // POS transaction ID, restock ID, etc.
  final String? referenceType; // 'sale', 'restock', 'adjustment', 'damage', 'return'
  final String userId; // Who made this change
  final String? reason;
  final String? notes;
  final DateTime createdAt;
  final double? unitCost; // Cost per unit for COGS calculations
  final Map<String, dynamic>? metadata;

  const InventoryMovement({
    required this.id,
    required this.productId,
    required this.productSku,
    required this.productName,
    required this.storeId,
    required this.type,
    required this.quantityChange,
    required this.quantityBefore,
    required this.quantityAfter,
    this.referenceId,
    this.referenceType,
    required this.userId,
    this.reason,
    this.notes,
    required this.createdAt,
    this.unitCost,
    this.metadata,
  });

  bool get isIncoming => quantityChange > 0;
  bool get isOutgoing => quantityChange < 0;
  double get totalCostImpact => unitCost != null ? (unitCost! * quantityChange.abs()) : 0.0;
}

class InventorySnapshot {
  final String id;
  final String productId;
  final String productSku;
  final String productName;
  final String storeId;
  final int currentStock;
  final int reservedStock; // Stock allocated but not yet sold
  final int reorderLevel;
  final int maxStockLevel;
  final double averageCost; // Weighted average cost
  final DateTime lastMovementAt;
  final DateTime snapshotAt;
  final Map<String, dynamic>? metadata;

  const InventorySnapshot({
    required this.id,
    required this.productId,
    required this.productSku,
    required this.productName,
    required this.storeId,
    required this.currentStock,
    this.reservedStock = 0,
    required this.reorderLevel,
    required this.maxStockLevel,
    required this.averageCost,
    required this.lastMovementAt,
    required this.snapshotAt,
    this.metadata,
  });

  int get availableStock => currentStock - reservedStock;
  bool get isLowStock => currentStock <= reorderLevel;
  bool get isOutOfStock => currentStock <= 0;
  bool get isOverstocked => currentStock >= maxStockLevel;
  double get inventoryValue => currentStock * averageCost;
  
  StockStatus get stockStatus {
    if (isOutOfStock) return StockStatus.outOfStock;
    if (isLowStock) return StockStatus.lowStock;
    if (isOverstocked) return StockStatus.overstocked;
    return StockStatus.inStock;
  }
}

class StockAlert {
  final String id;
  final String productId;
  final String productSku;
  final String productName;
  final String storeId;
  final StockAlertType type;
  final int currentStock;
  final int threshold;
  final String message;
  final bool isResolved;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final String? resolvedBy;

  const StockAlert({
    required this.id,
    required this.productId,
    required this.productSku,
    required this.productName,
    required this.storeId,
    required this.type,
    required this.currentStock,
    required this.threshold,
    required this.message,
    this.isResolved = false,
    required this.createdAt,
    this.resolvedAt,
    this.resolvedBy,
  });
}

enum StockStatus {
  inStock,
  lowStock,
  outOfStock,
  overstocked,
}

enum StockAlertType {
  lowStock,
  outOfStock,
  overstocked,
  negativeStock,
}

class InventoryReport {
  final String storeId;
  final DateTime reportDate;
  final int totalProducts;
  final int inStockProducts;
  final int lowStockProducts;
  final int outOfStockProducts;
  final double totalInventoryValue;
  final List<InventorySnapshot> topValueProducts;
  final List<InventorySnapshot> lowStockItems;
  final List<InventoryMovement> recentMovements;

  const InventoryReport({
    required this.storeId,
    required this.reportDate,
    required this.totalProducts,
    required this.inStockProducts,
    required this.lowStockProducts,
    required this.outOfStockProducts,
    required this.totalInventoryValue,
    required this.topValueProducts,
    required this.lowStockItems,
    required this.recentMovements,
  });

  double get stockTurnoverRate {
    // This would need additional data to calculate properly
    // For now, return 0 as placeholder
    return 0.0;
  }
}