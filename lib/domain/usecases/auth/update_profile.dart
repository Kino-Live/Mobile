import 'package:kinolive_mobile/domain/entities/auth/user_profile.dart';
import 'package:kinolive_mobile/domain/repositories/auth_repository.dart';

class UpdateProfile {
  final AuthRepository _repository;

  UpdateProfile(this._repository);

  Future<UserProfile> call({
    String? firstName,
    String? lastName,
    String? username,
    String? phoneNumber,
    DateTime? dateOfBirth,
  }) async {
    return await _repository.updateProfile(
      firstName: firstName,
      lastName: lastName,
      username: username,
      phoneNumber: phoneNumber,
      dateOfBirth: dateOfBirth,
    );
  }
}

