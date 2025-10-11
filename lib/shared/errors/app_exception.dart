abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);
  @override
  String toString() => message;
}

class InvalidCredentialsException extends AppException {
  const InvalidCredentialsException() : super('Invalid email or password');
}

class UnauthorizedException extends AppException {
  const UnauthorizedException() : super('Unauthorized');
}

class NetworkTimeoutException extends AppException {
  const NetworkTimeoutException() : super('Network timeout');
}

class NetworkException extends AppException {
  const NetworkException([String msg = 'Network error']) : super(msg);
}
