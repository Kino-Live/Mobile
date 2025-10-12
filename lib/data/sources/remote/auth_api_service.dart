import 'package:dio/dio.dart';
import 'package:kinolive_mobile/data/mappers/network_error_mapper.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';

class AuthApiService {
  final Dio _dio;
  AuthApiService(this._dio);

  Future<String> login(String email, String password) async {
    try {
      final Response<Map<String, dynamic>> result = await _dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      final data = result.data;
      if (data == null) {
        throw const NetworkException('Empty response from server');
      }

      final token = data['token'];
      if (token is! String || token.isEmpty) {
        throw const NetworkException('Token missing in response');
      }

      return token;
    } on DioException catch (e) {
      throw NetworkErrorMapper.map(e);
    } catch (e) {
      throw NetworkErrorMapper.map(e);
    }
  }
}
