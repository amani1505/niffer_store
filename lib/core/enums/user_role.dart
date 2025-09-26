enum UserRole {
  superAdmin('super_admin', 'Super Admin'),
  storeAdmin('store_admin', 'Store Admin'),
  customer('customer', 'Customer');

  const UserRole(this.value, this.displayName);
  
  final String value;
  final String displayName;
  
  static UserRole fromString(String role) {
    return UserRole.values.firstWhere(
      (e) => e.value == role,
      orElse: () => UserRole.customer,
    );
  }
}