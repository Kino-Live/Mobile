import 'package:kinolive_mobile/data/models/reviews/review_dto.dart';
import 'package:kinolive_mobile/data/sources/remote/reviews_api_service.dart';
import 'package:kinolive_mobile/domain/entities/reviews/review.dart';
import 'package:kinolive_mobile/domain/repositories/reviews_repository.dart';

class ReviewsRepositoryImpl implements ReviewsRepository {
  final ReviewsApiService _api;

  ReviewsRepositoryImpl(this._api);

  @override
  Future<List<Review>> getMovieReviews(int movieId) async {
    final dtoList = await _api.getMovieReviews(movieId);
    final reviews = dtoList.map(reviewFromDto).toList();
    reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return reviews;
  }

  @override
  Future<Review> createReview({
    required int movieId,
    required int rating,
    required String comment,
  }) async {
    final dto = await _api.createReview(
      movieId: movieId,
      rating: rating,
      comment: comment,
    );
    return reviewFromDto(dto);
  }

  @override
  Future<List<Review>> getMyReviews() async {
    final dtoList = await _api.getMyReviews();
    final reviews = dtoList.map(reviewFromDto).toList();
    reviews.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return reviews;
  }
}

Review reviewFromDto(ReviewDto dto) {
  return Review(
    id: dto.id,
    movieId: dto.movieId,
    userEmail: dto.userEmail,
    userName: dto.userName,
    rating: dto.rating,
    comment: dto.comment,
    createdAt: DateTime.parse(dto.createdAt),
    movieTitle: dto.movieTitle,
    posterUrl: dto.posterUrl,
  );
}

