import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/domain/entities/auth/user_profile.dart';
import 'package:kinolive_mobile/domain/usecases/auth/update_profile.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';
import 'package:kinolive_mobile/shared/providers/auth_provider.dart';

final editProfileVmProvider =
    NotifierProvider<EditProfileVm, EditProfileState>(EditProfileVm.new);

enum EditProfileStatus { idle, loading, success, error }

class EditProfileState {
  final EditProfileStatus status;
  final UserProfile? profile;
  final String? error;
  final Map<String, String>? fieldErrors;

  const EditProfileState({
    this.status = EditProfileStatus.idle,
    this.profile,
    this.error,
    this.fieldErrors,
  });

  bool get isLoading => status == EditProfileStatus.loading;
  bool get hasError => status == EditProfileStatus.error;
  bool get isSuccess => status == EditProfileStatus.success;

  EditProfileState copyWith({
    EditProfileStatus? status,
    UserProfile? profile,
    String? error,
    Map<String, String>? fieldErrors,
  }) {
    return EditProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      error: error,
      fieldErrors: fieldErrors,
    );
  }
}

class EditProfileVm extends Notifier<EditProfileState> {
  late final UpdateProfile _updateProfile;

  @override
  EditProfileState build() {
    _updateProfile = ref.read(updateProfileProvider);
    return const EditProfileState();
  }

  void setInitialProfile(UserProfile profile) {
    state = state.copyWith(profile: profile);
  }

  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? username,
    String? phoneNumber,
    DateTime? dateOfBirth,
  }) async {
    if (state.isLoading) return;

    state = state.copyWith(
      status: EditProfileStatus.loading,
      error: null,
      fieldErrors: null,
    );

    try {
      final updatedProfile = await _updateProfile(
        firstName: firstName,
        lastName: lastName,
        username: username,
        phoneNumber: phoneNumber,
        dateOfBirth: dateOfBirth,
      );

      state = state.copyWith(
        status: EditProfileStatus.success,
        profile: updatedProfile,
        error: null,
        fieldErrors: null,
      );
    } on AppException catch (e) {
      if (e is ValidationException && e.fields != null) {
        state = state.copyWith(
          status: EditProfileStatus.error,
          error: e.message,
          fieldErrors: e.fields,
        );
      } else {
        state = state.copyWith(
          status: EditProfileStatus.error,
          error: e.message,
          fieldErrors: null,
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: EditProfileStatus.error,
        error: e.toString(),
        fieldErrors: null,
      );
    }
  }

  void clearError() => state = state.copyWith(error: null, fieldErrors: null);
}

