abstract class ForgotPasswordRepository {
  Future<void> sendResetCode(String email);

  Future<void> verifyResetCode({
    required String email,
    required String code,
  });

  Future<void> resetPassword({required String email, required String newPassword});
}
