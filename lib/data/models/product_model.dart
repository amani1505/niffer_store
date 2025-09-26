import 'package:niffer_store/domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    super.discountPrice,
    required super.storeId,
    required super.categoryId,
    required super.imageUrls,
    required super.stockQuantity,
    required super.sku,
    super.isActive,
    required super.createdAt,
    required super.updatedAt,
    super.rating,
    super.reviewCount,
    super.specifications,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      discountPrice: json['discount_price']?.toDouble(),
      storeId: json['store_id'] ?? '',
      categoryId: json['category_id'] ?? '',
      imageUrls: List<String>.from(json['image_urls'] ?? []),
      stockQuantity: json['stock_quantity'] ?? 0,
      sku: json['sku'] ?? '',
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['review_count'] ?? 0,
      specifications: json['specifications'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'discount_price': discountPrice,
      'store_id': storeId,
      'category_id': categoryId,
      'image_urls': imageUrls,
      'stock_quantity': stockQuantity,
      'sku': sku,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'rating': rating,
      'review_count': reviewCount,
      'specifications': specifications,
    };
  }
}
