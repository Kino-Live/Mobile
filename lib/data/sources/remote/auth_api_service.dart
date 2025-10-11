import 'package:dio/dio.dart';

class AuthApiService {
  final Dio _dio;
  AuthApiService(this._dio);

  Future<String> login(String email, String password) async {
    final res = await _dio.post('/login', data: {'email': email, 'password': password});
    final data = res.data;
    if (data is! Map<String, dynamic>) {
      throw DioException(requestOptions: res.requestOptions, response: res, type: DioExceptionType.badResponse, error: 'Unexpected response format');
    }
    final token = data['access_token'];
    if (token is! String || token.isEmpty) {
      throw DioException(requestOptions: res.requestOptions, response: res, type: DioExceptionType.badResponse, error: 'Token missing in response');
    }
    return token;
  }
}
