import 'dart:io';
import 'package:dio/dio.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';

class NetworkErrorMapper {
  static AppException map(Object error) {
    if (error is SocketException) {
      return const NetworkConnectionException();
    }

    if (error is FormatException) {
      return const InvalidResponseException('Invalid response format');
    }

    if (error is! DioException) {
      return const SomethingGetWrong();
    }

    final code = error.response?.statusCode;
    final serverMessage = _extractMessage(error) ?? error.message;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkTimeoutException(serverMessage ?? 'Network timeout');

      case DioExceptionType.cancel:
        return RequestCancelledException(serverMessage ?? 'Request cancelled');

      case DioExceptionType.badCertificate:
        return SslCertificateException(serverMessage ?? 'SSL certificate problem');

      case DioExceptionType.connectionError:
        return NetworkConnectionException(serverMessage ?? 'Network connection error');

      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return NetworkConnectionException(serverMessage ?? 'No internet connection');
        }
        return ServerErrorException(serverMessage ?? 'Unknown network error');

      case DioExceptionType.badResponse:
        return _mapHttpError(code, serverMessage, error);
    }
  }

  /// Maps HTTP response codes (4xx, 5xx) to the corresponding [AppException].
  static AppException _mapHttpError(int? code, String? message, DioException error) {
    switch (code) {
      case HttpStatus.badRequest: // 400
      case 422: // Unprocessable Entity
        return ValidationException(message ?? 'Invalid request data');

      case HttpStatus.unauthorized: // 401
        final text = (message ?? '').toLowerCase();
        final looksInvalidCreds = text.contains('invalid') ||
            text.contains('credential') ||
            text.contains('password');
        return looksInvalidCreds
            ? InvalidCredentialsException()
            : UnauthorizedException();

      case HttpStatus.forbidden: // 403
        return ForbiddenException(message ?? 'Forbidden: access denied');

      case HttpStatus.notFound: // 404
        return NotFoundException(message ?? 'Resource not found');

      case HttpStatus.conflict: // 409
        return ConflictException(message ?? 'Conflict');

      case 429: // Too Many Requests
        return TooManyRequestsException(
          retryAfter: _parseRetryAfter(error.response?.headers.value('retry-after')),
        );

      default:
      // 5xx and any other unexpected status
        if (code != null && code >= 500) {
          return ServerErrorException(message ?? 'Server error ($code)');
        }
        return SomethingGetWrong(message ?? 'Unexpected error (${code ?? 'no code'})');
    }
  }
}

String? _extractMessage(DioException dioError) {
  final responseData = dioError.response?.data;

  if (responseData is Map) {
    for (final field in const ['detail', 'message', 'error', 'title', 'description']) {
      final value = responseData[field];
      if (value != null) {
        final text = value.toString().trim();
        if (text.isNotEmpty) return text;
      }
    }

    final errors = responseData['errors'];
    if (errors is Map) {
      final messages = <String>[];
      errors.forEach((key, val) {
        if (val is Iterable) {
          final combined = val.map((e) => e.toString()).join(', ');
          if (combined.isNotEmpty) messages.add('$key: $combined');
        } else if (val != null) {
          messages.add('$key: ${val.toString()}');
        }
      });
      if (messages.isNotEmpty) return messages.join('; ');
    }
  }

  if (responseData is String) {
    final text = responseData.trim();
    if (text.isNotEmpty) return text;
  }

  return null;
}

Duration? _parseRetryAfter(String? header) {
  if (header == null) return null;
  final trimmed = header.trim();
  final seconds = int.tryParse(trimmed);
  if (seconds != null) return Duration(seconds: seconds);
  return null;
}
