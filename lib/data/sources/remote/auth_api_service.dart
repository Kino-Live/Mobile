import 'package:dio/dio.dart';

class AuthApiService {
  final Dio _dio;
  AuthApiService(this._dio);

  Future<String> login(String email, String password) async {
    final result = await _dio.post('/login', data: {'email': email, 'password': password});
    final data = result.data;
    if (data is! Map<String, dynamic>) {
      throw DioException(requestOptions: result.requestOptions, response: result, type: DioExceptionType.badResponse, error: 'Unexpected response format');
    }
    final token = data['access_token'];
    if (token is! String || token.isEmpty) {
      throw DioException(requestOptions: result.requestOptions, response: result, type: DioExceptionType.badResponse, error: 'Token missing in response');
    }
    return token;
  }
}
