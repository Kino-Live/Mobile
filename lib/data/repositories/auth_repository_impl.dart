import 'package:kinolive_mobile/data/sources/local/auth_token_storage.dart';
import 'package:kinolive_mobile/data/sources/remote/auth_api_service.dart';
import 'package:kinolive_mobile/domain/entities/auth_session.dart';
import 'package:kinolive_mobile/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _authApiService;
  final AuthTokenStorageService tokenStorage;

  AuthRepositoryImpl(this._authApiService, this.tokenStorage);

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final token = await _authApiService.login(email, password);
    await tokenStorage.save(token);
    return AuthSession(accessToken: token);
  }

  @override
  Future<void> logout() async {
    await tokenStorage.clear();
  }

  @override
  Future<AuthSession?> getSavedSession() async {
    final token = await tokenStorage.read();
    if (token == null || token.isEmpty) return null;
    return AuthSession(accessToken: token);
  }
}

