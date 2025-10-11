import 'package:dio/dio.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';

class NetworkErrorMapper {
  static AppException map(Object error) {
    if (error is DioException) {
      final code = error.response?.statusCode;
      String? msg;

      // Try to extract message from the response body
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        msg = (data['message'] ?? data['error'] ?? data['detail'])?.toString();
      } else if (data is String) {
        msg = data;
      }

      // Map Dio error types and HTTP codes to custom exceptions
      switch (error.type) {
      // Connection / timeout issues
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const NetworkTimeoutException();

      // Valid HTTP response but error status code
        case DioExceptionType.badResponse:
          if (code == 401) return const UnauthorizedException();
          if (code == 400 || code == 422) {
            return NetworkException(msg ?? 'Invalid request data');
          }
          if (code == 403) {
            return NetworkException(msg ?? 'Forbidden: insufficient permissions');
          }
          if (code == 404) {
            return NetworkException(msg ?? 'Resource not found');
          }
          if (code != null && code >= 500) {
            return NetworkException(msg ?? 'Server unavailable, please try again later');
          }
          return NetworkException(msg ?? 'Unexpected server response');

      // Request manually canceled
        case DioExceptionType.cancel:
          return const NetworkException('Request was canceled');

      // Network connectivity or SSL issues
        case DioExceptionType.badCertificate:
        case DioExceptionType.connectionError:
        case DioExceptionType.unknown:
          return NetworkException(msg ?? 'Network connection problem');
      }
    }

    // Fallback for unknown errors (non-Dio)
    return NetworkException(error.toString());
  }
}
