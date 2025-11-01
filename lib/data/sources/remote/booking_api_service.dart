import 'package:dio/dio.dart';
import 'package:kinolive_mobile/data/mappers/network_error_mapper.dart';
import 'package:kinolive_mobile/data/models/booking/day_showtimes_dto.dart';
import 'package:kinolive_mobile/data/models/booking/hall_dto.dart';
import 'package:kinolive_mobile/data/models/booking/movie_showtimes_all_dto.dart';
import 'package:kinolive_mobile/data/models/booking/showtime_details_dto.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';

class BookingApiService {
  final Dio _dio;
  BookingApiService(this._dio);

  Future<MovieShowtimesAllDto> getMovieShowTimesAll(int movieId) async {
    try {
      final Response<Map<String, dynamic>> resp =
      await _dio.get('/movies/$movieId/showtimes');

      final data = resp.data;
      if (data == null) {
        throw const NetworkException('Empty response from server');
      }
      return MovieShowtimesAllDto.fromJson(data);
    } on DioException catch (e) {
      throw NetworkErrorMapper.map(e);
    } catch (_) {
      throw const SomethingGetWrong();
    }
  }

  Future<DayShowtimesDto> getMovieShowTimesForDate({
    required int movieId,
    required String date,
  }) async {
    try {
      final Response<Map<String, dynamic>> resp =
      await _dio.get('/movies/$movieId/showtimes', queryParameters: {
        'date': date,
      });

      final data = resp.data;
      if (data == null) {
        throw const NetworkException('Empty response from server');
      }

      final dayJson = data['day'];
      if (dayJson is! Map<String, dynamic>) {
        return const DayShowtimesDto(twoD: [], threeD: []);
      }
      return DayShowtimesDto.fromJson(dayJson);
    } on DioException catch (e) {
      throw NetworkErrorMapper.map(e);
    } catch (_) {
      throw const SomethingGetWrong();
    }
  }

  Future<ShowtimeDetailsDto> getShowTimeById(String showtimeId) async {
    try {
      final Response<Map<String, dynamic>> resp =
      await _dio.get('/showtimes/$showtimeId');

      final data = resp.data;
      if (data == null) {
        throw const NetworkException('Empty response from server');
      }
      final st = data['showtime'];
      if (st is! Map<String, dynamic>) {
        throw const NetworkException('Malformed showtime payload');
      }
      return ShowtimeDetailsDto.fromJson(st);
    } on DioException catch (e) {
      throw NetworkErrorMapper.map(e);
    } catch (_) {
      throw const SomethingGetWrong();
    }
  }

  Future<HallForShowtimeDto> getHallForShowTime(String showtimeId) async {
    try {
      final Response<Map<String, dynamic>> resp =
      await _dio.get('/showtimes/$showtimeId/hall');

      final data = resp.data;
      if (data == null) {
        throw const NetworkException('Empty response from server');
      }
      return HallForShowtimeDto.fromJson(data);
    } on DioException catch (e) {
      throw NetworkErrorMapper.map(e);
    } catch (_) {
      throw const SomethingGetWrong();
    }
  }
}
