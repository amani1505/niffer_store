import 'package:niffer_store/data/models/user_model.dart';
import 'package:niffer_store/data/repositories/auth_repository_impl.dart';
import 'package:niffer_store/core/services/storage_service.dart';

class AuthMockDataSource {
  // Mock demo users
  static final Map<String, Map<String, dynamic>> _demoUsers = {
    'admin@ecommerce.com': {
      'id': '1',
      'email': 'admin@ecommerce.com',
      'password': 'password123',
      'firstName': 'Super',
      'lastName': 'Admin',
      'role': 'super_admin',
      'phoneNumber': '+1234567890',
    },
    'vendor1@store.com': {
      'id': '2',
      'email': 'vendor1@store.com',
      'password': 'password123',
      'firstName': 'Store',
      'lastName': 'Owner',
      'role': 'store_admin',
      'phoneNumber': '+1234567891',
    },
    'customer1@email.com': {
      'id': '3',
      'email': 'customer1@email.com',
      'password': 'password123',
      'firstName': 'Demo',
      'lastName': 'Customer',
      'role': 'customer',
      'phoneNumber': '+1234567892',
    },
  };

  Future<LoginResult> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final userData = _demoUsers[email];
    if (userData == null || userData['password'] != password) {
      throw Exception('Invalid email or password');
    }

    final user = UserModel.fromJson(userData);
    const accessToken = 'demo_access_token';
    const refreshToken = 'demo_refresh_token';

    await StorageService.saveTokens(accessToken, refreshToken);
    await StorageService.saveUserId(user.id);

    return LoginResult(
      user: user,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  Future<LoginResult> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (_demoUsers.containsKey(email)) {
      throw Exception('User already exists');
    }

    final newUserId = (DateTime.now().millisecondsSinceEpoch).toString();
    final userData = {
      'id': newUserId,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'role': 'customer',
      'phoneNumber': phoneNumber,
    };

    final user = UserModel.fromJson(userData);
    const accessToken = 'demo_access_token';
    const refreshToken = 'demo_refresh_token';

    await StorageService.saveTokens(accessToken, refreshToken);
    await StorageService.saveUserId(user.id);

    // Add to demo users for future logins in this session
    _demoUsers[email] = {
      ...userData,
      'password': password,
    };

    return LoginResult(
      user: user,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  Future<void> logout() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    await StorageService.clearTokens();
  }

  Future<UserModel> getCurrentUser() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    final userId = await StorageService.getUserId();
    if (userId == null) {
      throw Exception('No user found');
    }

    // Find user by ID in demo users
    for (final userData in _demoUsers.values) {
      if (userData['id'] == userId) {
        return UserModel.fromJson(userData);
      }
    }

    throw Exception('User not found');
  }
}