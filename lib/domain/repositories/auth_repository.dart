import 'package:kinolive_mobile/domain/entities/auth_session.dart';

abstract class AuthRepository {
  Future<AuthSession> login({
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<AuthSession?> getSavedSession();
}