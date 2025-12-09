import 'package:kinolive_mobile/domain/entities/reviews/review.dart';
import 'package:kinolive_mobile/domain/repositories/reviews_repository.dart';

class CreateReview {
  final ReviewsRepository _repository;

  CreateReview(this._repository);

  Future<Review> call({
    required int movieId,
    required int rating,
    required String comment,
  }) async {
    return await _repository.createReview(
      movieId: movieId,
      rating: rating,
      comment: comment,
    );
  }
}

