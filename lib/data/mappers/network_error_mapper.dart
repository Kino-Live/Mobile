import 'dart:io';
import 'package:dio/dio.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';

class NetworkErrorMapper {
  static AppException map(Object error) {
    if (error is SocketException) {
      return const NetworkConnectionException();
    }
    if (error is FormatException) {
      return const ServerErrorException();
    }

    if (error is! DioException) {
      return ServerErrorException();
    }

    final code = error.response?.statusCode;
    final message = _extractMessage(error) ?? error.message;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkTimeoutException();

      case DioExceptionType.cancel:
        return const RequestCancelledException();

      case DioExceptionType.badCertificate:
        return const SslCertificateException();

      case DioExceptionType.connectionError:
        return const NetworkConnectionException();

      case DioExceptionType.unknown:
        if (error.error is SocketException) return const NetworkConnectionException();
        return const ServerErrorException();

      case DioExceptionType.badResponse:
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
                ? const InvalidCredentialsException()
                : const UnauthorizedException();

          case HttpStatus.forbidden: // 403
            return const ForbiddenException();

          case HttpStatus.notFound: // 404
            return const NotFoundException();

          case HttpStatus.conflict: // 409
            return ConflictException(message ?? 'Conflict');

          case 429: // Too Many Requests
            return TooManyRequestsException(
              retryAfter: _parseRetryAfter(error.response?.headers.value('retry-after')),
            );

        // 5xx
          default:
            if (code != null && code >= 500) {
              return const ServerErrorException();
            }
            return ServerErrorException();
        }
    }
  }
}

String? _extractMessage(DioException dioError) {
  final responseData = dioError.response?.data;

  if (responseData is Map) {
    for (final fieldName in const ['detail', 'message', 'error', 'title', 'description']) {
      final fieldValue = responseData[fieldName];
      if (fieldValue != null) {
        final text = fieldValue.toString().trim();
        if (text.isNotEmpty) return text;
      }
    }

    final errorFields = responseData['errors'];
    if (errorFields is Map) {
      final collectedMessages = <String>[];

      errorFields.forEach((fieldName, fieldErrors) {
        if (fieldErrors is Iterable) {
          final joinedMessages = fieldErrors
              .whereType<Object>()
              .map((error) => error.toString())
              .join(', ');

          if (joinedMessages.isNotEmpty) {
            collectedMessages.add('$fieldName: $joinedMessages');
          }
        } else if (fieldErrors != null) {
          collectedMessages.add('$fieldName: ${fieldErrors.toString()}');
        }
      });

      if (collectedMessages.isNotEmpty) {
        return collectedMessages.join('; ');
      }
    }
  }

  if (responseData is String) {
    final trimmedText = responseData.trim();
    if (trimmedText.isNotEmpty) return trimmedText;
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
