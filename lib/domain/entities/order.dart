import 'package:niffer_store/core/enums/order_status.dart';

class OrderItem {
  final String id;
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;
  final String storeId;

  const OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    required this.storeId,
  });

  double get totalPrice => price * quantity;
}

class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double totalAmount;
  final OrderStatus status;
  final String shippingAddress;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deliveredAt;

  const Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.shippingAddress,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.deliveredAt,
  });

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  
  // Get unique stores from order items
  Set<String> get storeIds => items.map((item) => item.storeId).toSet();
}
