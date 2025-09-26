class CartItem {
  final String id;
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;
  final String storeId;
  final String storeName;

  const CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    required this.storeId,
    required this.storeName,
  });

  double get totalPrice => price * quantity;
}

class Cart {
  final String userId;
  final List<CartItem> items;
  final DateTime updatedAt;

  const Cart({
    required this.userId,
    required this.items,
    required this.updatedAt,
  });

  double get totalPrice => items.fold(0.0, (sum, item) => sum + item.totalPrice);
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => items.isEmpty;
}