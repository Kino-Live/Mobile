import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';
import 'package:kinolive_mobile/shared/network/dio_provider.dart';
import 'package:kinolive_mobile/shared/auth/auth_provider.dart';

final loginVmProvider = NotifierProvider<LoginVm, LoginState>(LoginVm.new);

enum LoginStatus { idle, loading, success, error }

class LoginState {
  final LoginStatus status;
  final String? error;

  const LoginState({
    this.status = LoginStatus.idle,
    this.error,
  });

  LoginState copyWith({
    LoginStatus? status,
    String? error,
  }) {
    return LoginState(
      status: status ?? this.status,
      error: error,
    );
  }
}

class LoginVm extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: LoginStatus.loading, error: null);

    try {
      // TODO: check for account
      final dio = ref.read(dioProvider);

      final response = await dio.post('/login', data: {
        'email': email,
        'password': password,
      });

      final token = (response.data?['token'] as String?)?.trim();

      if (token == null || token.isEmpty) {
        throw const InvalidCredentialsException();
      }

      await ref.read(authTokenProvider.notifier).setToken(token);

      state = state.copyWith(status: LoginStatus.success);
    } on AppException catch (e) {
      state = state.copyWith(status: LoginStatus.error, error: e.message);
    } on DioException catch (e) {
      state = state.copyWith(
        status: LoginStatus.error,
        error: _handleDioError(e).message,
      );
    } catch (e) {
      state = state.copyWith(
        status: LoginStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> logout() async {
    await ref.read(authTokenProvider.notifier).clearToken();
    state = const LoginState(status: LoginStatus.idle);
  }

  AppException _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const NetworkTimeoutException();
    }

    if (e.response?.statusCode == 401) {
      return const UnauthorizedException();
    }

    return NetworkException(e.message ?? 'Network error');
  }
}
