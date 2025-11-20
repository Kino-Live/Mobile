import 'package:kinolive_mobile/domain/entities/auth/user_profile.dart';
import 'package:kinolive_mobile/domain/repositories/auth_repository.dart';

class GetProfile {
  final AuthRepository _repo;

  GetProfile(this._repo);

  Future<UserProfile> call() {
    return _repo.getProfile();
  }
}
