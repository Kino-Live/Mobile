abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

class InvalidResponseException extends AppException {
  const InvalidResponseException([super.message = 'Invalid server response']);
}

// Network group
class NetworkTimeoutException extends AppException {
  const NetworkTimeoutException([super.message = 'Network timeout']);
}

class NetworkConnectionException extends AppException {
  const NetworkConnectionException([super.message = 'Network connection problem']);
}

class RequestCancelledException extends AppException {
  const RequestCancelledException([super.message = 'Request was canceled']);
}

class SslCertificateException extends AppException {
  const SslCertificateException([super.message = 'SSL certificate error']);
}

class ServerErrorException extends AppException {
  const ServerErrorException([super.message = 'Server unavailable, please try again later']);
}

// HTTP / authorization
class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Unauthorized']);
}

class InvalidCredentialsException extends AppException {
  const InvalidCredentialsException([super.message = 'Invalid email or password']);
}

class ForbiddenException extends AppException {
  const ForbiddenException([super.message = 'Forbidden: insufficient permissions']);
}

class NotFoundException extends AppException {
  const NotFoundException([super.message = 'Resource not found']);
}

class ValidationException extends AppException {
  const ValidationException([super.message = 'Invalid request data']);
}

class ConflictException extends AppException {
  const ConflictException([super.message = 'Conflict']);
}

class TooManyRequestsException extends AppException {
  final Duration? retryAfter;
  const TooManyRequestsException({this.retryAfter})
      : super('Too many requests. Please try again later');
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'Network error']);
}
