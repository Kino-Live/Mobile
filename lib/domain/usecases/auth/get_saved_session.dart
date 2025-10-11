import 'package:kinolive_mobile/domain/entities/auth_session.dart';
import 'package:kinolive_mobile/domain/repositories/auth_repository.dart';

class GetSavedSession {
  final AuthRepository _repo;
  GetSavedSession(this._repo);
  Future<AuthSession?> call() => _repo.getSavedSession();
}