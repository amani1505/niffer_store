import 'package:niffer_store/core/constants/app_config.dart';
import 'package:niffer_store/data/datasources/local/auth_local_datasource.dart';
import 'package:niffer_store/data/datasources/remote/auth_remote_datasource.dart';
import 'package:niffer_store/data/datasources/remote/auth_mock_datasource.dart';
import 'package:niffer_store/data/models/user_model.dart';
import 'package:niffer_store/domain/entities/user.dart';
import 'package:niffer_store/domain/repositories/auth_repository.dart';

class LoginResult {
  final User user;
  final String accessToken;
  final String refreshToken;

  LoginResult({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource? remoteDataSource;
  final AuthMockDataSource? mockDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    this.remoteDataSource,
    this.mockDataSource,
    required this.localDataSource,
  });

  @override
  Future<LoginResult> login(String email, String password) async {
    try {
      final result = AppConfig.isDemoMode
          ? await mockDataSource!.login(email, password)
          : await remoteDataSource!.login(email, password);
      await localDataSource.cacheUser(result.user as UserModel);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<LoginResult> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  }) async {
    try {
      final result = AppConfig.isDemoMode
          ? await mockDataSource!.register(
              email: email,
              password: password,
              firstName: firstName,
              lastName: lastName,
              phoneNumber: phoneNumber,
            )
          : await remoteDataSource!.register(
              email: email,
              password: password,
              firstName: firstName,
              lastName: lastName,
              phoneNumber: phoneNumber,
            );
      await localDataSource.cacheUser(result.user as UserModel);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      if (AppConfig.isDemoMode) {
        await mockDataSource!.logout();
      } else {
        await remoteDataSource!.logout();
      }
      await localDataSource.clearCache();
    } catch (e) {
      await localDataSource.clearCache();
      rethrow;
    }
  }

  @override
  Future<User> getCurrentUser() async {
    try {
      if (AppConfig.isDemoMode) {
        return await mockDataSource!.getCurrentUser();
      } else {
        return await remoteDataSource!.getCurrentUser();
      }
    } catch (e) {
      // Fallback to cached user
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        return cachedUser;
      }
      rethrow;
    }
  }
}
