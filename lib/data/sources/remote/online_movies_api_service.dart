import 'package:dio/dio.dart';
import 'package:kinolive_mobile/data/mappers/network_error_mapper.dart';
import 'package:kinolive_mobile/data/models/online_movies/online_movie_dto.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';

class OnlineMoviesApiService {
  final Dio dio;
  OnlineMoviesApiService(this.dio);

  Future<List<OnlineMovieDto>> getAvailableMovies() {
    return _tryGet<List<OnlineMovieDto>>(
      endpoint: '/online-movies',
      parser: (responseData) {
        if (responseData is! List) {
          throw const InvalidResponseException('Invalid response format.');
        }
        return responseData
            .map((json) => OnlineMovieDto.fromJson(json as Map<String, dynamic>))
            .toList();
      },
    );
  }

  Future<OnlineMovieDto> getMovieInfo(int movieId) {
    return _tryGet<OnlineMovieDto>(
      endpoint: '/online-movies/$movieId',
      parser: (responseData) {
        if (responseData is! Map<String, dynamic>) {
          throw const InvalidResponseException('Invalid response format.');
        }
        return OnlineMovieDto.fromJson(responseData);
      },
    );
  }

  Future<OnlineMoviePurchaseDto> purchaseMovie(int movieId) {
    return _tryPost<OnlineMoviePurchaseDto>(
      endpoint: '/online-movies/$movieId/purchase',
      parser: (responseData) {
        if (responseData is! Map<String, dynamic>) {
          throw const InvalidResponseException('Invalid response format.');
        }
        return OnlineMoviePurchaseDto.fromJson(responseData);
      },
    );
  }

  Future<void> confirmPurchase(int movieId, String orderId, double price, String currency) {
    return _tryPost<void>(
      endpoint: '/online-movies/$movieId/confirm-purchase',
      body: {
        'order_id': orderId,
        'price': price,
        'currency': currency,
      },
      parser: (_) => null,
    );
  }

  Future<OnlineMovieWatchDto> getVideoUrl(int movieId) {
    return _tryGet<OnlineMovieWatchDto>(
      endpoint: '/online-movies/$movieId/watch',
      parser: (responseData) {
        if (responseData is! Map<String, dynamic>) {
          throw const InvalidResponseException('Invalid response format.');
        }
        return OnlineMovieWatchDto.fromJson(responseData);
      },
    );
  }

  Future<List<MyOnlineMovieDto>> getMyOnlineMovies() {
    return _tryGet<List<MyOnlineMovieDto>>(
      endpoint: '/my-online-movies',
      parser: (responseData) {
        if (responseData is! List) {
          throw const InvalidResponseException('Invalid response format.');
        }
        return responseData
            .map((json) => MyOnlineMovieDto.fromJson(json as Map<String, dynamic>))
            .toList();
      },
    );
  }

  Future<T> _tryGet<T>({
    required String endpoint,
    required T Function(dynamic data) parser,
  }) async {
    try {
      final dynamic json = await _getJson(endpoint);
      return parser(json);
    } on DioException catch (e) {
      throw NetworkErrorMapper.map(e);
    } on AppException {
      rethrow;
    } catch (_) {
      throw const SomethingGetWrong();
    }
  }

  Future<T> _tryPost<T>({
    required String endpoint,
    required T Function(dynamic data) parser,
    Map<String, dynamic>? body,
  }) async {
    try {
      final dynamic json = await _postJson(endpoint, body: body);
      return parser(json);
    } on DioException catch (e) {
      throw NetworkErrorMapper.map(e);
    } on AppException {
      rethrow;
    } catch (_) {
      throw const SomethingGetWrong();
    }
  }

  Future<dynamic> _getJson(String endpoint) async {
    final Response<dynamic> response = await dio.get(endpoint);

    final dynamic data = response.data;
    if (data == null) {
      throw const NetworkException('Empty response from server.');
    }

    return data;
  }

  Future<dynamic> _postJson(String endpoint, {Map<String, dynamic>? body}) async {
    final Response<dynamic> response = await dio.post(
      endpoint,
      data: body,
    );

    final dynamic data = response.data;
    if (data == null) {
      throw const NetworkException('Empty response from server.');
    }

    return data;
  }
}

