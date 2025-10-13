import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/domain/usecases/forgot_password/send_reset_code.dart';
import 'package:kinolive_mobile/domain/usecases/forgot_password/verify_reset_code.dart';
import 'package:kinolive_mobile/domain/usecases/forgot_password/reset_password.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';
import 'package:kinolive_mobile/shared/providers/forgot_password_provider.dart';

final forgotPasswordVmProvider =
NotifierProvider<ForgotPasswordVm, ForgotPasswordState>(ForgotPasswordVm.new);

enum ForgotFlowStep { enterEmail, codeSent, codeVerified, done }

class ForgotPasswordState {
  final String email;
  final bool loading;
  final String? error;
  final ForgotFlowStep step;

  const ForgotPasswordState({
    this.email = '',
    this.loading = false,
    this.error,
    this.step = ForgotFlowStep.enterEmail,
  });

  ForgotPasswordState copyWith({
    String? email,
    bool? loading,
    String? error,
    ForgotFlowStep? step,
  }) {
    return ForgotPasswordState(
      email: email ?? this.email,
      loading: loading ?? this.loading,
      error: error,
      step: step ?? this.step,
    );
  }
}

class ForgotPasswordVm extends Notifier<ForgotPasswordState> {
  late final SendResetCode _sendResetCode;
  late final VerifyResetCode _verifyResetCode;
  late final ResetPassword _resetPassword;

  @override
  ForgotPasswordState build() {
    _sendResetCode = ref.read(sendResetCodeProvider);
    _verifyResetCode = ref.read(verifyResetCodeProvider);
    _resetPassword = ref.read(resetPasswordProvider);
    return const ForgotPasswordState();
  }

  Future<bool> sendCode(String email) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _sendResetCode(email);
      state = state.copyWith(
        email: email,
        step: ForgotFlowStep.codeSent,
        loading: false,
      );
      return true;
    } on AppException catch (e) {
      state = state.copyWith(loading: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> verifyCode(String code) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _verifyResetCode(email: state.email, code: code);
      state = state.copyWith(step: ForgotFlowStep.codeVerified, loading: false);
      return true;
    } on AppException catch (e) {
      state = state.copyWith(loading: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> setNewPassword(String newPassword) async {
    state = state.copyWith(loading: true, error: null);
    try {
      await _resetPassword(email: state.email, newPassword: newPassword);
      state = state.copyWith(step: ForgotFlowStep.done, loading: false);
      return true;
    } on AppException catch (e) {
      state = state.copyWith(loading: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
      return false;
    }
  }

  void clearError() => state = state.copyWith(error: null);
}
