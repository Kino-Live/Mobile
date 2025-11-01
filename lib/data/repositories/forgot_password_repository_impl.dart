import 'package:kinolive_mobile/data/sources/remote/forgot_password_api_service.dart';
import 'package:kinolive_mobile/domain/repositories/forgot_password_repository.dart';

class ForgotPasswordRepositoryImpl implements ForgotPasswordRepository {
  final ForgotPasswordApiService _api;
  ForgotPasswordRepositoryImpl(this._api);

  @override
  Future<void> sendResetCode(String email) async {
    await _api.sendPasswordResetEmail(email);
  }

  @override
  Future<void> verifyResetCode({required String email, required String code}) async {
    await _api.verifyResetCode(email: email, code: code);
  }

  @override
  Future<void> resetPassword({required String email, required String newPassword}) async {
    await _api.resetPassword(email: email, newPassword: newPassword);
  }
}
