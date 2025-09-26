import 'package:niffer_store/domain/entities/store.dart';

class StoreModel extends Store {
  const StoreModel({
    required super.id,
    required super.name,
    required super.description,
    required super.ownerId,
    required super.logoUrl,
    required super.bannerUrl,
    required super.address,
    required super.phoneNumber,
    required super.email,
    super.isActive,
    required super.createdAt,
    required super.updatedAt,
    super.rating,
    super.totalProducts,
    super.totalOrders,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      ownerId: json['owner_id'] ?? '',
      logoUrl: json['logo_url'] ?? '',
      bannerUrl: json['banner_url'] ?? '',
      address: json['address'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      email: json['email'] ?? '',
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
      rating: (json['rating'] ?? 0.0).toDouble(),
      totalProducts: json['total_products'] ?? 0,
      totalOrders: json['total_orders'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'owner_id': ownerId,
      'logo_url': logoUrl,
      'banner_url': bannerUrl,
      'address': address,
      'phone_number': phoneNumber,
      'email': email,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'rating': rating,
      'total_products': totalProducts,
      'total_orders': totalOrders,
    };
  }
}
