import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/domain/entities/reviews/review.dart';
import 'package:kinolive_mobile/domain/usecases/reviews/get_movie_reviews.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';
import 'package:kinolive_mobile/shared/providers/reviews_providers.dart';

final movieReviewsVmProvider = NotifierProvider.family<MovieReviewsVm, MovieReviewsState, int>(
  (movieId) => MovieReviewsVm(),
);

enum MovieReviewsStatus { idle, loading, loaded, error }

class MovieReviewsState {
  final MovieReviewsStatus status;
  final List<Review> reviews;
  final String? error;

  const MovieReviewsState({
    this.status = MovieReviewsStatus.idle,
    this.reviews = const [],
    this.error,
  });

  bool get isLoading => status == MovieReviewsStatus.loading;
  bool get hasError => status == MovieReviewsStatus.error;
  bool get isEmpty => reviews.isEmpty;

  MovieReviewsState copyWith({
    MovieReviewsStatus? status,
    List<Review>? reviews,
    String? error,
  }) {
    return MovieReviewsState(
      status: status ?? this.status,
      reviews: reviews ?? this.reviews,
      error: error,
    );
  }
}

class MovieReviewsVm extends Notifier<MovieReviewsState> {
  late final GetMovieReviews _getMovieReviews;

  @override
  MovieReviewsState build() {
    _getMovieReviews = ref.read(getMovieReviewsProvider);
    return const MovieReviewsState();
  }

  Future<void> load(int movieId) async {
    // Не блокируем загрузку, если уже загружается - это может быть refresh
    if (state.isLoading && state.reviews.isNotEmpty) return;

    state = state.copyWith(
      status: MovieReviewsStatus.loading,
      error: null,
      reviews: state.reviews, // Сохраняем существующие отзывы во время загрузки
    );

    try {
      final reviews = await _getMovieReviews(movieId);
      state = state.copyWith(
        status: MovieReviewsStatus.loaded,
        reviews: reviews,
        error: null,
      );
    } on AppException catch (e) {
      state = state.copyWith(
        status: MovieReviewsStatus.error,
        error: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        status: MovieReviewsStatus.error,
        error: e.toString(),
      );
    }
  }

  void clearError() => state = state.copyWith(error: null);
}

