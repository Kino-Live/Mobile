import 'package:kinolive_mobile/data/sources/local/auth_token_storage.dart';
import 'package:kinolive_mobile/data/sources/remote/auth_api_service.dart';
import 'package:kinolive_mobile/domain/entities/auth_session.dart';
import 'package:kinolive_mobile/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService _authApiService;
  final AccessTokenStorage _tokenStorage;

  AuthRepositoryImpl(this._authApiService, this._tokenStorage);

  @override
  Future<bool> isLoggedIn() async {
    final token = await _tokenStorage.read();
    return token?.isNotEmpty == true;
  }

  @override
  Future<AuthSession> login({required String email, required String password}) {
    return _performAuthRequest(
      request: () => _authApiService.login(email, password),
    );
  }

  @override
  Future<AuthSession> register({required String email, required String password}) {
    return _performAuthRequest(
      request: () => _authApiService.register(email, password),
    );
  }

  Future<AuthSession> _performAuthRequest({required Future<String> Function() request}) async {
    final accessToken = await request();
    await _tokenStorage.save(accessToken);
    return AuthSession(accessToken: accessToken);
  }

  @override
  Future<void> logout() async {
    await _tokenStorage.clear();
  }

  @override
  Future<AuthSession?> getSavedSession() async {
    final savedToken = await _tokenStorage.read();
    if (savedToken == null || savedToken.isEmpty) return null;
    return AuthSession(accessToken: savedToken);
  }
}
