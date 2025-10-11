import 'package:kinolive_mobile/domain/repositories/auth_repository.dart';

class LogoutUser {
  final AuthRepository _repo;
  LogoutUser(this._repo);
  Future<void> call() => _repo.logout();
}