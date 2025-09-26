import 'package:niffer_store/core/constants/api_endpoints.dart';
import 'package:niffer_store/core/network/api_client.dart';
import 'package:niffer_store/core/services/storage_service.dart';
import 'package:niffer_store/data/models/user_model.dart';
import 'package:niffer_store/data/repositories/auth_repository_impl.dart';

class AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSource(this.apiClient);

  Future<LoginResult> login(String email, String password) async {
    final response = await apiClient.post(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );

    final data = response.data;
    final user = UserModel.fromJson(data['user']);
    final accessToken = data['access_token'];
    final refreshToken = data['refresh_token'];

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
    final response = await apiClient.post(
      ApiEndpoints.register,
      data: {
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
        'phone_number': phoneNumber,
      },
    );

    final data = response.data;
    final user = UserModel.fromJson(data['user']);
    final accessToken = data['access_token'];
    final refreshToken = data['refresh_token'];

    await StorageService.saveTokens(accessToken, refreshToken);
    await StorageService.saveUserId(user.id);

    return LoginResult(
      user: user,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  Future<void> logout() async {
    await apiClient.post(ApiEndpoints.logout);
    await StorageService.clearTokens();
  }

  Future<UserModel> getCurrentUser() async {
    final response = await apiClient.get(ApiEndpoints.getCurrentUser);
    return UserModel.fromJson(response.data);
  }
}