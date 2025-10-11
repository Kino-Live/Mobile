import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';
import 'package:kinolive_mobile/shared/auth/auth_provider.dart';
import 'package:kinolive_mobile/data/repositories/auth_repository_impl.dart';

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
      final repo = ref.read(authRepositoryProvider);
      final token = await repo.login(email: email, password: password);
      await ref.read(authTokenProvider.notifier).setToken(token);

      state = state.copyWith(status: LoginStatus.success);
    } on AppException catch (e) {
      state = state.copyWith(status: LoginStatus.error, error: e.message);
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
}
