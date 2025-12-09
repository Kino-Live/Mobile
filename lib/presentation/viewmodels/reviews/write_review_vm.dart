import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/domain/entities/reviews/review.dart';
import 'package:kinolive_mobile/domain/usecases/reviews/create_review.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';
import 'package:kinolive_mobile/shared/providers/reviews_providers.dart';

final writeReviewVmProvider =
    NotifierProvider<WriteReviewVm, WriteReviewState>(WriteReviewVm.new);

enum WriteReviewStatus { idle, loading, success, error }

class WriteReviewState {
  final WriteReviewStatus status;
  final Review? review;
  final String? error;

  const WriteReviewState({
    this.status = WriteReviewStatus.idle,
    this.review,
    this.error,
  });

  bool get isLoading => status == WriteReviewStatus.loading;
  bool get hasError => status == WriteReviewStatus.error;
  bool get isSuccess => status == WriteReviewStatus.success;

  WriteReviewState copyWith({
    WriteReviewStatus? status,
    Review? review,
    String? error,
  }) {
    return WriteReviewState(
      status: status ?? this.status,
      review: review ?? this.review,
      error: error,
    );
  }
}

class WriteReviewVm extends Notifier<WriteReviewState> {
  late final CreateReview _createReview;

  @override
  WriteReviewState build() {
    _createReview = ref.read(createReviewProvider);
    return const WriteReviewState();
  }

  Future<void> submitReview({
    required int movieId,
    required int rating,
    required String comment,
  }) async {
    if (state.isLoading) return;

    state = state.copyWith(
      status: WriteReviewStatus.loading,
      error: null,
    );

    try {
      final review = await _createReview(
        movieId: movieId,
        rating: rating,
        comment: comment,
      );

      state = state.copyWith(
        status: WriteReviewStatus.success,
        review: review,
        error: null,
      );
    } on AppException catch (e) {
      state = state.copyWith(
        status: WriteReviewStatus.error,
        error: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        status: WriteReviewStatus.error,
        error: e.toString(),
      );
    }
  }

  void clearError() => state = state.copyWith(error: null);
  void reset() => state = const WriteReviewState();
}

