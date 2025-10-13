import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kinolive_mobile/data/sources/remote/forgot_password_api_service.dart';
import 'package:kinolive_mobile/data/repositories/forgot_password_repository_impl.dart';
import 'package:kinolive_mobile/domain/repositories/forgot_password_repository.dart';

import 'package:kinolive_mobile/domain/usecases/forgot_password/reset_password.dart';
import 'package:kinolive_mobile/domain/usecases/forgot_password/send_reset_code.dart';
import 'package:kinolive_mobile/domain/usecases/forgot_password/verify_reset_code.dart';
import 'package:kinolive_mobile/shared/providers/network/dio_provider.dart';

final forgotPasswordApiServiceProvider = Provider<ForgotPasswordApiService>((ref) {
  return ForgotPasswordApiService(ref.read(dioProvider));
});

final forgotPasswordRepositoryProvider = Provider<ForgotPasswordRepository>((ref) {
  return ForgotPasswordRepositoryImpl(ref.read(forgotPasswordApiServiceProvider));
});

final sendResetCodeProvider = Provider<SendResetCode>((ref) {
  return SendResetCode(ref.read(forgotPasswordRepositoryProvider));
});

final verifyResetCodeProvider = Provider<VerifyResetCode>((ref) {
  return VerifyResetCode(ref.read(forgotPasswordRepositoryProvider));
});

final resetPasswordProvider = Provider<ResetPassword>((ref) {
  return ResetPassword(ref.read(forgotPasswordRepositoryProvider));
});
