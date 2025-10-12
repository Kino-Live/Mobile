import 'package:kinolive_mobile/domain/repositories/auth_repository.dart';

class IsLoggedIn {
  final AuthRepository _repo;
  IsLoggedIn(this._repo);
  Future<bool> call() => _repo.isLoggedIn();
}