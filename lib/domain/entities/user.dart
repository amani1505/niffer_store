import 'package:niffer_store/core/enums/user_role.dart';

class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final UserRole role;
  final String? storeId;
  final String? profileImageUrl;
  final String? phoneNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.storeId,
    this.profileImageUrl,
    this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
  });

  String get fullName => '$firstName $lastName';

  bool get isSuperAdmin => role == UserRole.superAdmin;
  bool get isStoreAdmin => role == UserRole.storeAdmin;
  bool get isCustomer => role == UserRole.customer;
}
