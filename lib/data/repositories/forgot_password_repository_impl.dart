import 'package:kinolive_mobile/data/sources/remote/forgot_password_api_service.dart';
import 'package:kinolive_mobile/domain/repositories/forgot_password_repository.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';

class ForgotPasswordRepositoryImpl implements ForgotPasswordRepository {
  final ForgotPasswordApiService _api;
  ForgotPasswordRepositoryImpl(this._api);

  @override
  Future<void> sendResetCode(String email) async {
    try {
      await _api.sendPasswordResetEmail(email);
    } on AppException {
      rethrow;
    } catch (e) {
      throw NetworkException(e.toString());
    }
  }

  @override
  Future<void> verifyResetCode({
    required String email,
    required String code,
  }) async {
    try {
      await _api.verifyResetCode(email: email, code: code);
    } on AppException {
      rethrow;
    } catch (e) {
      throw NetworkException(e.toString());
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      await _api.resetPassword(email: email, newPassword: newPassword);
    } on AppException {
      rethrow;
    } catch (e) {
      throw NetworkException(e.toString());
    }
  }
}
