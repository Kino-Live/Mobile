import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/domain/entities/reviews/review.dart';
import 'package:kinolive_mobile/domain/usecases/reviews/get_my_reviews.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';
import 'package:kinolive_mobile/shared/providers/reviews_providers.dart';

final reviewsHistoryVmProvider =
    NotifierProvider<ReviewsHistoryVm, ReviewsHistoryState>(
  ReviewsHistoryVm.new,
);

enum ReviewsHistoryStatus { idle, loading, loaded, error }

class ReviewsHistoryState {
  final ReviewsHistoryStatus status;
  final List<Review> reviews;
  final String? error;

  const ReviewsHistoryState({
    this.status = ReviewsHistoryStatus.idle,
    this.reviews = const [],
    this.error,
  });

  bool get isLoading => status == ReviewsHistoryStatus.loading;
  bool get hasError => status == ReviewsHistoryStatus.error;
  bool get isEmpty => reviews.isEmpty;

  ReviewsHistoryState copyWith({
    ReviewsHistoryStatus? status,
    List<Review>? reviews,
    String? error,
  }) {
    return ReviewsHistoryState(
      status: status ?? this.status,
      reviews: reviews ?? this.reviews,
      error: error,
    );
  }
}

class ReviewsHistoryVm extends Notifier<ReviewsHistoryState> {
  late final GetMyReviews _getMyReviews;

  @override
  ReviewsHistoryState build() {
    _getMyReviews = ref.read(getMyReviewsProvider);
    return const ReviewsHistoryState();
  }

  Future<void> load() async {
    if (state.isLoading) return;

    state = state.copyWith(
      status: ReviewsHistoryStatus.loading,
      error: null,
      reviews: const <Review>[],
    );

    try {
      final reviews = await _getMyReviews();
      state = state.copyWith(
        status: ReviewsHistoryStatus.loaded,
        reviews: reviews,
        error: null,
      );
    } on AppException catch (e) {
      state = state.copyWith(
        status: ReviewsHistoryStatus.error,
        error: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        status: ReviewsHistoryStatus.error,
        error: e.toString(),
      );
    }
  }

  void clearError() => state = state.copyWith(error: null);
  
  void clearHistory() {
    state = state.copyWith(
      status: ReviewsHistoryStatus.idle,
      reviews: const [],
      error: null,
    );
  }
}

