import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/presentation/viewmodels/auth_controller.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';
import 'package:kinolive_mobile/shared/providers/auth_provider.dart';

final registerVmProvider = NotifierProvider<RegisterVm, RegisterState>(RegisterVm.new);

enum RegisterStatus { idle, loading, success, error }

class RegisterState {
  final RegisterStatus status;
  final String? error;

  const RegisterState({
    this.status = RegisterStatus.idle,
    this.error,
  });

  RegisterState copyWith({
    RegisterStatus? status,
    String? error,
  }) {
    return RegisterState(
      status: status ?? this.status,
      error: error,
    );
  }
}

class RegisterVm extends Notifier<RegisterState> {
  @override
  RegisterState build() => const RegisterState();

  Future<void> register(String email, String password) async {
    state = state.copyWith(status: RegisterStatus.loading, error: null);

    try {
      final registerUser = ref.read(registerUserProvider);
      final session = await registerUser(email: email, password: password);

      ref.read(authStateProvider.notifier).markAuthenticated(session);

      state = state.copyWith(status: RegisterStatus.success);
    } on AppException catch (e) {
      state = state.copyWith(status: RegisterStatus.error, error: e.message);
    } catch (e) {
      state = state.copyWith(status: RegisterStatus.error, error: e.toString());
    }
  }
}
