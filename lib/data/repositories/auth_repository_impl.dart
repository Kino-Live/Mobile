import 'package:kinolive_mobile/data/sources/local/auth_token_storage.dart';
import 'package:kinolive_mobile/data/sources/remote/auth_api_service.dart';
import 'package:kinolive_mobile/domain/entities/auth_session.dart';
import 'package:kinolive_mobile/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService apiService;
  final AccessTokenStorage tokenStorage;

  AuthRepositoryImpl(this.apiService, this.tokenStorage);

  @override
  Future<bool> isLoggedIn() async {
    final storedToken = await tokenStorage.read();
    return storedToken?.isNotEmpty == true;
  }

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) {
    return _handleAuthRequest(
      request: () => apiService.login(email, password),
    );
  }

  @override
  Future<AuthSession> register({
    required String email,
    required String password,
  }) {
    return _handleAuthRequest(
      request: () => apiService.register(email, password),
    );
  }

  Future<AuthSession> _handleAuthRequest({
    required Future<String> Function() request,
  }) async {
    final accessToken = await request();
    await tokenStorage.save(accessToken);
    return AuthSession(accessToken: accessToken);
  }

  @override
  Future<void> logout() async {
    await tokenStorage.clear();
  }

  @override
  Future<AuthSession?> getSavedSession() async {
    final storedToken = await tokenStorage.read();
    if (storedToken == null || storedToken.isEmpty) return null;
    return AuthSession(accessToken: storedToken);
  }
}
