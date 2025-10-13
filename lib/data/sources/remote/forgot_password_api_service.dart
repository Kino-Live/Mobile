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
    } catch (e) {
      throw NetworkErrorMapper.map(e);
    }
  }
}
