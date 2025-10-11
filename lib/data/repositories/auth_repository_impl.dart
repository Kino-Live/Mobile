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
    final res = await _dio.post('/login', data: {'email': email, 'password': password});
    final token = (res.data?['token'] as String?)?.trim();
    if (token == null || token.isEmpty) {
      throw const InvalidCredentialsException();
    }

    return token;
  }

  @override
  Future<void> logout() async {
  }
}
