import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/data/repositories/reviews_repository_impl.dart';
import 'package:kinolive_mobile/data/sources/remote/reviews_api_service.dart';
import 'package:kinolive_mobile/domain/repositories/reviews_repository.dart';
import 'package:kinolive_mobile/domain/usecases/reviews/create_review.dart';
import 'package:kinolive_mobile/domain/usecases/reviews/get_movie_reviews.dart';
import 'package:kinolive_mobile/domain/usecases/reviews/get_my_reviews.dart';
import 'package:kinolive_mobile/shared/providers/network/dio_provider.dart';

final reviewsApiServiceProvider = Provider<ReviewsApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return ReviewsApiService(dio);
});

final reviewsRepositoryProvider = Provider<ReviewsRepository>((ref) {
  final api = ref.watch(reviewsApiServiceProvider);
  return ReviewsRepositoryImpl(api);
});

final createReviewProvider = Provider<CreateReview>((ref) {
  final repo = ref.watch(reviewsRepositoryProvider);
  return CreateReview(repo);
});

final getMovieReviewsProvider = Provider<GetMovieReviews>((ref) {
  final repo = ref.watch(reviewsRepositoryProvider);
  return GetMovieReviews(repo);
});

final getMyReviewsProvider = Provider<GetMyReviews>((ref) {
  final repo = ref.watch(reviewsRepositoryProvider);
  return GetMyReviews(repo);
});

