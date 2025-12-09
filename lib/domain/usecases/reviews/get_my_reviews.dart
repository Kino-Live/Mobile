import 'package:kinolive_mobile/domain/entities/reviews/review.dart';
import 'package:kinolive_mobile/domain/repositories/reviews_repository.dart';

class GetMyReviews {
  final ReviewsRepository _repository;

  GetMyReviews(this._repository);

  Future<List<Review>> call() {
    return _repository.getMyReviews();
  }
}

