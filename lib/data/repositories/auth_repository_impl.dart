import 'package:kinolive_mobile/data/sources/local/auth_token_storage.dart';
import 'package:kinolive_mobile/data/sources/remote/auth_api_service.dart';
import 'package:kinolive_mobile/domain/entities/auth_session.dart';
import 'package:kinolive_mobile/domain/repositories/auth_repository.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _authApiService;
  final AuthTokenStorageService _tokenStorage;

  AuthRepositoryImpl(this._authApiService, this._tokenStorage);

  @override
  Future<bool> isLoggedIn() async {
    final token = await _tokenStorage.read();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    try {
      final token = await _authApiService.login(email, password);
      await _tokenStorage.save(token);
      return AuthSession(accessToken: token);
    } on AppException catch (e) {
      if (e is UnauthorizedException) {
        throw const InvalidCredentialsException();
      }
      rethrow;
    } catch (e) {
      throw NetworkException(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    await _tokenStorage.clear();
  }

  @override
  Future<AuthSession?> getSavedSession() async {
    final token = await _tokenStorage.read();
    if (token == null || token.isEmpty) return null;
    return AuthSession(accessToken: token);
  }
}

