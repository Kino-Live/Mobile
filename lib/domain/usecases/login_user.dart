import 'package:kinolive_mobile/domain/entities/auth_session.dart';
import 'package:kinolive_mobile/domain/repositories/auth_repository.dart';

class LoginUser {
  final AuthRepository _repo;
  LoginUser(this._repo);
  Future<AuthSession> call(String email, String password) =>
      _repo.login(email: email, password: password);
}