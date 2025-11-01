import 'package:dio/dio.dart';
import 'package:kinolive_mobile/data/mappers/network_error_mapper.dart';
import 'package:kinolive_mobile/data/models/movie_dto.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';

class MoviesApiService {
  final Dio dio;
  MoviesApiService(this.dio);

  Future<List<MovieDto>> getNowShowing() {
    return _tryGet<List<MovieDto>>(
      endpoint: '/movies/now-showing',
      parser: (responseData) {
        if (responseData is! List) {
          throw const InvalidResponseException('Invalid response format.');
        }
        return responseData
            .map((json) => MovieDto.fromJson(json as Map<String, dynamic>))
            .toList();
      },
    );
  }

  Future<MovieDto> getById(int movieId) {
    return _tryGet<MovieDto>(
      endpoint: '/movies/$movieId',
      parser: (responseData) {
        if (responseData is! Map<String, dynamic>) {
          throw const InvalidResponseException('Invalid response format.');
        }
        return MovieDto.fromJson(responseData);
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

  Future<dynamic> _getJson(String endpoint) async {
    final Response<dynamic> response = await dio.get(endpoint);

    final dynamic data = response.data;
    if (data == null) {
      throw const NetworkException('Empty response from server.');
    }

    return data;
  }
}
