import 'package:kinolive_mobile/domain/entities/auth_session.dart';
import 'package:kinolive_mobile/domain/repositories/auth_repository.dart';

class RegisterUser {
  final AuthRepository _repo;
  RegisterUser(this._repo);

  Future<AuthSession> call({
    required String email,
    required String password,
  }) {
    return _repo.register(email: email, password: password);
  }
}
