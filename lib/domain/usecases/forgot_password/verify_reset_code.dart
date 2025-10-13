import 'package:kinolive_mobile/domain/repositories/forgot_password_repository.dart';

class VerifyResetCode {
  final ForgotPasswordRepository _repo;
  VerifyResetCode(this._repo);

  Future<void> call({required String email, required String code}) {
    return _repo.verifyResetCode(email: email, code: code);
  }
}
