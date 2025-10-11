import 'package:dio/dio.dart';

class AuthApiService {
  final Dio _dio;
  AuthApiService(this._dio);

  Future<String> login(String email, String password) async {
    final res = await _dio.post('/auth/login', data: {'email': email, 'password': password});
    final data = res.data as Map<String, dynamic>;
    return data['access_token'] as String;
  }
}
