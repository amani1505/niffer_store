enum InventoryMovementType {
  sale,
  restock,
  adjustment,
  damage,
  productReturn,
  transfer,
  initialStock,
  stocktake;

  String get displayName {
    switch (this) {
      case InventoryMovementType.sale:
        return 'Sale';
      case InventoryMovementType.restock:
        return 'Restock';
      case InventoryMovementType.adjustment:
        return 'Adjustment';
      case InventoryMovementType.damage:
        return 'Damage';
      case InventoryMovementType.productReturn:
        return 'Return';
      case InventoryMovementType.transfer:
        return 'Transfer';
      case InventoryMovementType.initialStock:
        return 'Initial Stock';
      case InventoryMovementType.stocktake:
        return 'Stocktake';
    }
  }

  bool get isIncoming {
    return [
      InventoryMovementType.restock,
      InventoryMovementType.productReturn,
      InventoryMovementType.initialStock,
    ].contains(this);
  }

  bool get isOutgoing {
    return [
      InventoryMovementType.sale,
      InventoryMovementType.damage,
      InventoryMovementType.transfer,
    ].contains(this);
  }

  bool get isAdjustment {
    return [
      InventoryMovementType.adjustment,
      InventoryMovementType.stocktake,
    ].contains(this);
  }
}