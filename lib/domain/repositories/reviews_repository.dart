import 'package:kinolive_mobile/domain/entities/reviews/review.dart';

abstract class ReviewsRepository {
  Future<List<Review>> getMovieReviews(int movieId);
  Future<Review> createReview({
    required int movieId,
    required int rating,
    required String comment,
  });
  Future<List<Review>> getMyReviews();
}

