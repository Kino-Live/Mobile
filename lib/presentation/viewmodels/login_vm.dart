import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';
import 'package:kinolive_mobile/domain/usecases/auth/login_user.dart';
import 'package:kinolive_mobile/shared/providers/auth_provider.dart';

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
      final LoginUser loginUser = ref.read(loginUserProvider);

      await loginUser(email, password);

      state = state.copyWith(status: LoginStatus.success);
    } on AppException catch (e) {
      state = state.copyWith(status: LoginStatus.error, error: e.message);
    } catch (e) {
      state = state.copyWith(status: LoginStatus.error, error: e.toString());
    }
  }
}
