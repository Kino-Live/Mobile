import 'package:kinolive_mobile/domain/repositories/forgot_password_repository.dart';

class SendResetCode {
  final ForgotPasswordRepository _repo;
  SendResetCode(this._repo);

  Future<void> call(String email) {
    return _repo.sendResetCode(email);
  }
}
