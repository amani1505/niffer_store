import 'package:niffer_store/domain/entities/cart.dart';

class CartItemModel extends CartItem {
  const CartItemModel({
    required super.id,
    required super.productId,
    required super.productName,
    required super.productImage,
    required super.price,
    required super.quantity,
    required super.storeId,
    required super.storeName,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] ?? '',
      productId: json['product_id'] ?? '',
      productName: json['product_name'] ?? '',
      productImage: json['product_image'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      quantity: json['quantity'] ?? 1,
      storeId: json['store_id'] ?? '',
      storeName: json['store_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_name': productName,
      'product_image': productImage,
      'price': price,
      'quantity': quantity,
      'store_id': storeId,
      'store_name': storeName,
    };
  }
}

class CartModel extends Cart {
  const CartModel({
    required super.userId,
    required super.items,
    required super.updatedAt,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      userId: json['user_id'] ?? '',
      items: (json['items'] as List<dynamic>? ?? [])
          .map((item) => CartItemModel.fromJson(item))
          .toList(),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'items': items.map((item) => (item as CartItemModel).toJson()).toList(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
