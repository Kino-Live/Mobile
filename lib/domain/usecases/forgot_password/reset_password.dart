import 'package:kinolive_mobile/domain/repositories/forgot_password_repository.dart';

class ResetPassword {
  final ForgotPasswordRepository _repo;
  ResetPassword(this._repo);

  Future<void> call({required String email, required String newPassword}) {
    return _repo.resetPassword(email: email, newPassword: newPassword);
  }
}
