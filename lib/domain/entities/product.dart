class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? discountPrice;
  final String storeId;
  final String categoryId;
  final List<String> imageUrls;
  final int stockQuantity;
  final String sku;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double rating;
  final int reviewCount;
  final Map<String, dynamic>? specifications;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.storeId,
    required this.categoryId,
    required this.imageUrls,
    required this.stockQuantity,
    required this.sku,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.specifications,
  });

  bool get isInStock => stockQuantity > 0;
  bool get hasDiscount => discountPrice != null && discountPrice! < price;
  double get finalPrice => discountPrice ?? price;
  double get discountPercentage =>
      hasDiscount ? ((price - discountPrice!) / price * 100) : 0.0;
}
