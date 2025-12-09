import 'package:kinolive_mobile/domain/entities/reviews/review.dart';
import 'package:kinolive_mobile/domain/repositories/reviews_repository.dart';

class GetMovieReviews {
  final ReviewsRepository _repository;

  GetMovieReviews(this._repository);

  Future<List<Review>> call(int movieId) {
    return _repository.getMovieReviews(movieId);
  }
}

