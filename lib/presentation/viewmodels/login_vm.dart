import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:kinolive_mobile/shared/network/dio_provider.dart';
import 'package:kinolive_mobile/shared/auth/auth_provider.dart';

final loginVmProvider = NotifierProvider<LoginVm, LoginState>(() => LoginVm());

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
        throw Exception('Invalid credentials');
      }

      await ref.read(authTokenProvider.notifier).setToken(token);

      state = state.copyWith(status: LoginStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: LoginStatus.error,
        error: _handleError(e),
      );
    }
  }

  Future<void> logout() async {
    await ref.read(authTokenProvider.notifier).clearToken();
    state = const LoginState(status: LoginStatus.idle);
  }

  String _handleError(Object e) {
    if (e is DioException) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return 'Network timeout';
      }
      if (e.response?.statusCode == 401) {
        return 'Unauthorized';
      }
      return e.message ?? 'Network error';
    }
    return e.toString();
  }
}
