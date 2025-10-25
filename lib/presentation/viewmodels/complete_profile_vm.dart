import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CompleteProfileStatus { idle, loading, success, error }

class CompleteProfileState {
  final CompleteProfileStatus status;
  final String? error;

  const CompleteProfileState({
    this.status = CompleteProfileStatus.idle,
    this.error,
  });

  CompleteProfileState copyWith({
    CompleteProfileStatus? status,
    String? error,
  }) {
    return CompleteProfileState(
      status: status ?? this.status,
      error: error,
    );
  }
}

class CompleteProfileVm extends Notifier<CompleteProfileState> {
  @override
  CompleteProfileState build() => const CompleteProfileState();

  Future<void> saveProfile({
    required String name,
    required String phone,
  }) async {
    state = state.copyWith(status: CompleteProfileStatus.loading, error: null);
    try {
      // TODO: replace with a real call usecase/repository
      await Future.delayed(const Duration(milliseconds: 800));

      state = state.copyWith(status: CompleteProfileStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: CompleteProfileStatus.error,
        error: 'Failed to save profile',
      );
    }
  }

  void reset() => state = const CompleteProfileState();
}

final completeProfileVmProvider =
NotifierProvider<CompleteProfileVm, CompleteProfileState>(
  CompleteProfileVm.new,
);