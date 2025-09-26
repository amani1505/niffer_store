import 'package:flutter/foundation.dart';
import 'package:niffer_store/core/enums/user_role.dart';
import 'package:niffer_store/core/services/storage_service.dart';
import 'package:niffer_store/data/repositories/auth_repository_impl.dart';
import 'package:niffer_store/domain/entities/user.dart';

enum AuthState { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final AuthRepositoryImpl _authRepository;

  AuthProvider(this._authRepository) {
    _checkAuthStatus();
  }

  AuthState _state = AuthState.initial;
  User? _currentUser;
  String? _errorMessage;

  // Getters
  AuthState get state => _state;
  User? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _state == AuthState.authenticated;
  bool get isLoading => _state == AuthState.loading;
  
  // Role checks
  bool get isSuperAdmin => _currentUser?.role == UserRole.superAdmin;
  bool get isStoreAdmin => _currentUser?.role == UserRole.storeAdmin;
  bool get isCustomer => _currentUser?.role == UserRole.customer;

  Future<void> _checkAuthStatus() async {
    final token = await StorageService.getAccessToken();
    if (token != null) {
      try {
        final user = await _authRepository.getCurrentUser();
        _currentUser = user;
        _state = AuthState.authenticated;
      } catch (e) {
        _state = AuthState.unauthenticated;
        await StorageService.clearTokens();
      }
    } else {
      _state = AuthState.unauthenticated;
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authRepository.login(email, password);
      _currentUser = result.user;
      _state = AuthState.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _state = AuthState.error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  }) async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authRepository.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
      );
      _currentUser = result.user;
      _state = AuthState.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _state = AuthState.error;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    _state = AuthState.loading;
    notifyListeners();

    try {
      await _authRepository.logout();
    } catch (e) {
      debugPrint('Logout error: $e');
    } finally {
      _currentUser = null;
      _state = AuthState.unauthenticated;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    if (_state == AuthState.error) {
      _state = AuthState.unauthenticated;
    }
    notifyListeners();
  }
}