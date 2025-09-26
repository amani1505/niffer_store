class ApiException implements Exception {
  final String message;
  const ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}

class ServerException extends ApiException {
  const ServerException(super.message);
  
  @override
  String toString() => 'ServerException: $message';
}

class NetworkException extends ApiException {
  const NetworkException(super.message);
  
  @override
  String toString() => 'NetworkException: $message';
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException(super.message);
  
  @override
  String toString() => 'UnauthorizedException: $message';
}

class ForbiddenException extends ApiException {
  const ForbiddenException(super.message);
  
  @override
  String toString() => 'ForbiddenException: $message';
}

class NotFoundException extends ApiException {
  const NotFoundException(super.message);
  
  @override
  String toString() => 'NotFoundException: $message';
}

class ValidationException extends ApiException {
  const ValidationException(super.message);
  
  @override
  String toString() => 'ValidationException: $message';
}

class CacheException implements Exception {
  final String message;
  const CacheException(this.message);

  @override
  String toString() => 'CacheException: $message';
}

class ParseException implements Exception {
  final String message;
  const ParseException(this.message);

  @override
  String toString() => 'ParseException: $message';
}

// lib/core/errors/failures.dart
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}