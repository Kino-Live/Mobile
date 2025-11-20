import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/domain/entities/auth/user_profile.dart';
import 'package:kinolive_mobile/domain/usecases/auth/get_profile.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';
import 'package:kinolive_mobile/shared/providers/auth_provider.dart';

final profileVmProvider =
NotifierProvider<ProfileVm, ProfileState>(ProfileVm.new);

enum ProfileStatus { idle, loading, loaded, error }

class ProfileState {
  final ProfileStatus status;
  final UserProfile? profile;
  final String? error;

  const ProfileState({
    this.status = ProfileStatus.idle,
    this.profile,
    this.error,
  });

  bool get isLoading => status == ProfileStatus.loading;
  bool get hasError => status == ProfileStatus.error;
  bool get isLoaded => status == ProfileStatus.loaded && profile != null;

  ProfileState copyWith({
    ProfileStatus? status,
    UserProfile? profile,
    String? error,
  }) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      error: error,
    );
  }
}

class ProfileVm extends Notifier<ProfileState> {
  late final GetProfile _getProfile;

  @override
  ProfileState build() {
    _getProfile = ref.read(getProfileProvider);
    return const ProfileState();
  }

  Future<void> load() async {
    if (state.isLoading) return;

    state = state.copyWith(
      status: ProfileStatus.loading,
      error: null,
      profile: null,
    );

    try {
      final profile = await _getProfile();
      state = state.copyWith(
        status: ProfileStatus.loaded,
        profile: profile,
        error: null,
      );
    } on AppException catch (e) {
      state = state.copyWith(
        status: ProfileStatus.error,
        error: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        status: ProfileStatus.error,
        error: e.toString(),
      );
    }
  }

  void clearError() => state = state.copyWith(error: null);
}
