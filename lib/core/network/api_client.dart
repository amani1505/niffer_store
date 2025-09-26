import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:niffer_store/core/errors/exceptions.dart';
import '../constants/api_endpoints.dart';
import '../services/storage_service.dart';

class ApiClient {
  late final Dio _dio;
  
  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Add interceptors
    _dio.interceptors.add(AuthInterceptor());
    
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ));
    }
  }

  // GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException('Connection timeout');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 'Unknown error occurred';
        
        switch (statusCode) {
          case 400:
            return ApiException('Bad request: $message');
          case 401:
            return const UnauthorizedException('Unauthorized access');
          case 403:
            return const ForbiddenException('Access forbidden');
          case 404:
            return const NotFoundException('Resource not found');
          case 422:
            return ValidationException(message);
          case 500:
            return const ServerException('Internal server error');
          default:
            return ApiException('Error $statusCode: $message');
        }
      case DioExceptionType.cancel:
        return const ApiException('Request cancelled');
      case DioExceptionType.badCertificate:
        return const ApiException('Bad certificate');
      case DioExceptionType.connectionError:
        return const ApiException('Connection error');
      case DioExceptionType.unknown:
      default:
        return const ApiException('Unknown error occurred');
    }
  }
}

// Auth Interceptor for handling JWT tokens
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await StorageService.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Try to refresh token
      final refreshToken = await StorageService.getRefreshToken();
      if (refreshToken != null) {
        try {
          // Attempt token refresh
          final dio = Dio();
          final response = await dio.post(
            '${ApiEndpoints.baseUrl}${ApiEndpoints.refreshToken}',
            data: {'refresh_token': refreshToken},
          );

          if (response.statusCode == 200) {
            final newAccessToken = response.data['access_token'];
            final newRefreshToken = response.data['refresh_token'];

            await StorageService.saveTokens(newAccessToken, newRefreshToken);

            // Retry the original request
            final requestOptions = err.requestOptions;
            requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

            final retryResponse = await dio.request(
              requestOptions.path,
              options: Options(
                method: requestOptions.method,
                headers: requestOptions.headers,
              ),
              data: requestOptions.data,
              queryParameters: requestOptions.queryParameters,
            );

            return handler.resolve(retryResponse);
          }
        } catch (e) {
          // Refresh failed, logout user
          await StorageService.clearTokens();
        }
      }
    }
    super.onError(err, handler);
  }
}
