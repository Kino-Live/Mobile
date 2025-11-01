import 'package:dio/dio.dart';
import 'package:kinolive_mobile/data/mappers/network_error_mapper.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';

class ForgotPasswordApiService {
  final Dio _dio;
  ForgotPasswordApiService(this._dio);

  Future<void> sendPasswordResetEmail(String email) {
    return _tryPostAndEnsureSuccess(
      endpoint: '/forgot-password',
      body: {'email': email},
      failureMessage: 'Failed to send password reset email',
    );
  }

  Future<void> verifyResetCode({required String email, required String code}) {
    return _tryPostAndEnsureSuccess(
      endpoint: '/verify-reset-code',
      body: {'email': email, 'code': code},
      failureMessage: 'Invalid or expired reset code',
    );
  }

  Future<void> resetPassword({required String email, required String newPassword}) {
    return _tryPostAndEnsureSuccess(
      endpoint: '/reset-password',
      body: {'email': email, 'new_password': newPassword},
      failureMessage: 'Failed to reset password',
    );
  }

  Future<void> _tryPostAndEnsureSuccess({
    required String endpoint,
    required Map<String, dynamic> body,
    required String failureMessage,
  }) async {
    try {
      await _postAndEnsureSuccess(
        endpoint: endpoint,
        body: body,
        failureMessage: failureMessage,
      );
    } on DioException catch (e) {
      throw NetworkErrorMapper.map(e);
    } on AppException {
      rethrow;
    } catch (_) {
      throw const SomethingGetWrong();
    }
  }

  Future<void> _postAndEnsureSuccess({
    required String endpoint,
    required Map<String, dynamic> body,
    required String failureMessage,
  }) async {
    final Response<dynamic> response = await _dio.post(endpoint, data: body);

    final dynamic payload = response.data;
    if (payload is! Map<String, dynamic>) {
      throw const InvalidResponseException('Invalid server response');
    }

    final success = payload['success'];
    if (success != true) {
      throw NetworkException(failureMessage);
    }
  }
}
