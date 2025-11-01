import 'package:dio/dio.dart';
import 'package:kinolive_mobile/data/mappers/network_error_mapper.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';

class ForgotPasswordApiService {
  final Dio _dio;
  ForgotPasswordApiService(this._dio);

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      final Response<Map<String, dynamic>> result = await _dio.post(
        '/forgot-password',
        data: {'email': email},
      );

      final data = result.data;
      if (data == null || data['success'] != true) {
        throw const NetworkException('Error sending password reset email');
      }
    } on DioException catch (e) {
      throw NetworkErrorMapper.map(e);
    } catch (_) {
      throw const SomethingGetWrong();
    }
  }

  Future<void> verifyResetCode({
    required String email,
    required String code,
  }) async {
    try {
      final Response<Map<String, dynamic>> result = await _dio.post(
        '/verify-reset-code',
        data: {'email': email, 'code': code},
      );

      final data = result.data;
      if (data == null || data['success'] != true) {
        throw const NetworkException('Invalid or expired reset code');
      }
    } on DioException catch (e) {
      throw NetworkErrorMapper.map(e);
    } catch (_) {
      throw const SomethingGetWrong();
    }
  }

  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      final Response<Map<String, dynamic>> res = await _dio.post(
        '/reset-password',
        data: {'email': email, 'new_password': newPassword},
      );
      final data = res.data;
      if (data == null || data['success'] != true) {
        throw const NetworkException('Failed to reset password');
      }
    } on DioException catch (e) {
      throw NetworkErrorMapper.map(e);
    } catch (_) {
      throw const SomethingGetWrong();
    }
  }
}
