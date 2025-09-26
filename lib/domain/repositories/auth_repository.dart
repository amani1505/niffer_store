import 'package:niffer_store/data/repositories/auth_repository_impl.dart';
import 'package:niffer_store/domain/entities/user.dart';

abstract class AuthRepository {
  Future<LoginResult> login(String email, String password);
  Future<LoginResult> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  });
  Future<void> logout();
  Future<User> getCurrentUser();
}