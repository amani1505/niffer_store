class Store {
  final String id;
  final String name;
  final String description;
  final String ownerId;
  final String logoUrl;
  final String bannerUrl;
  final String address;
  final String phoneNumber;
  final String email;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double rating;
  final int totalProducts;
  final int totalOrders;

  const Store({
    required this.id,
    required this.name,
    required this.description,
    required this.ownerId,
    required this.logoUrl,
    required this.bannerUrl,
    required this.address,
    required this.phoneNumber,
    required this.email,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.rating = 0.0,
    this.totalProducts = 0,
    this.totalOrders = 0,
  });
}
