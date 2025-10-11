import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/domain/repositories/auth_repository.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';
import 'package:kinolive_mobile/shared/network/dio_provider.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.read(dioProvider);
  return AuthRepositoryImpl(dio);
});

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dio);
  final Dio _dio;

  @override
  Future<String> login({required String email, required String password}) async {
    try {
      final res = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });

      final code = res.statusCode ?? 0;
      if (code == 401) {
        throw const InvalidCredentialsException();
      }
      if (code >= 400) {
        throw NetworkException('Server error ($code)');
      }

      final token = (res.data?['token'] as String?)?.trim();
      if (token == null || token.isEmpty) {
        throw const InvalidCredentialsException();
      }
      return token;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const NetworkTimeoutException();
      }
      if (e.response?.statusCode == 401) {
        throw const InvalidCredentialsException();
      }
      throw NetworkException(e.message ?? 'Network error');
    }
  }

  @override
  Future<void> logout() async {
  }
}
