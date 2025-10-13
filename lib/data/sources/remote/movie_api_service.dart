import 'package:dio/dio.dart';
import 'package:kinolive_mobile/data/mappers/network_error_mapper.dart';
import 'package:kinolive_mobile/data/models/movie_dto.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';

class MoviesApiService {
  final Dio _dio;
  MoviesApiService(this._dio);

  Future<List<MovieDto>> getNowShowing() async {
    try {
      final Response<List<dynamic>> res = await _dio.get('/movies/now-showing');

      final data = res.data;
      if (data == null) {
        throw const NetworkException('Empty response from server');
      }

      return data
          .map((e) => MovieDto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw NetworkErrorMapper.map(e);
    } catch (e) {
      throw NetworkErrorMapper.map(e);
    }
  }

  //TODO: Implement getById
  // Future<> getById(int id) async {
  //
  // }
}
