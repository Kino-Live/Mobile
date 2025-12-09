import 'package:dio/dio.dart';
import 'package:kinolive_mobile/data/mappers/network_error_mapper.dart';
import 'package:kinolive_mobile/data/models/reviews/review_dto.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';

class ReviewsApiService {
  final Dio _dio;
  ReviewsApiService(this._dio);

  Future<List<ReviewDto>> getMovieReviews(int movieId) async {
    try {
      final Response<Map<String, dynamic>> resp = await _dio.get(
        '/movies/$movieId/reviews',
      );

      final json = resp.data;
      if (json == null) {
        throw const InvalidResponseException('Empty response from server');
      }

      final reviews = json['reviews'];
      if (reviews is! List) {
        return [];
      }

      return reviews
          .map((item) => ReviewDto.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw NetworkErrorMapper.map(e);
    } catch (_) {
      throw const SomethingGetWrong();
    }
  }

  Future<ReviewDto> createReview({
    required int movieId,
    required int rating,
    required String comment,
  }) async {
    try {
      final Response<Map<String, dynamic>> resp = await _dio.post(
        '/movies/$movieId/reviews',
        data: {
          'rating': rating,
          'comment': comment,
        },
      );

      final json = resp.data;
      if (json == null) {
        throw const InvalidResponseException('Empty response from server');
      }

      final review = json['review'];
      if (review is! Map<String, dynamic>) {
        throw const InvalidResponseException('Review missing in response');
      }

      return ReviewDto.fromJson(review);
    } on DioException catch (e) {
      throw NetworkErrorMapper.map(e);
    } catch (_) {
      throw const SomethingGetWrong();
    }
  }

  Future<List<ReviewDto>> getMyReviews() async {
    try {
      final Response<Map<String, dynamic>> resp = await _dio.get('/my-reviews');

      final json = resp.data;
      if (json == null) {
        throw const InvalidResponseException('Empty response from server');
      }

      final reviews = json['reviews'];
      if (reviews is! List) {
        return [];
      }

      return reviews
          .map((item) => ReviewDto.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw NetworkErrorMapper.map(e);
    } catch (_) {
      throw const SomethingGetWrong();
    }
  }
}

