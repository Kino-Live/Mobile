import 'package:kinolive_mobile/data/models/booking/hall_dto.dart';
import 'package:kinolive_mobile/data/sources/remote/booking_api_service.dart';
import 'package:kinolive_mobile/domain/entities/booking/day_schedule.dart';
import 'package:kinolive_mobile/domain/entities/booking/hall.dart';
import 'package:kinolive_mobile/domain/entities/booking/movie_schedule.dart';
import 'package:kinolive_mobile/domain/entities/booking/showtime.dart';
import 'package:kinolive_mobile/domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingApiService _apiService;

  BookingRepositoryImpl(this._apiService);

  @override
  Future<MovieSchedule> getMovieSchedule(int movieId) async {
    final response = await _apiService.getMovieShowTimesAll(movieId);

    final mappedDays = response.days.map(
          (date, dailyDto) => MapEntry(
        date,
        DaySchedule(
          twoD: _mapShowTimeList(
            items: dailyDto.twoD,
            movieId: movieId,
            date: date,
            quality: '2D',
          ),
          threeD: _mapShowTimeList(
            items: dailyDto.threeD,
            movieId: movieId,
            date: date,
            quality: '3D',
          ),
        ),
      ),
    );

    return MovieSchedule(
      movieId: response.movieId,
      days: mappedDays,
      availableDays: response.availableDays,
    );
  }

  @override
  Future<DaySchedule> getMovieScheduleForDate({
    required int movieId,
    required String date,
  }) async {
    final response =
    await _apiService.getMovieShowTimesForDate(movieId: movieId, date: date);

    return DaySchedule(
      twoD: _mapShowTimeList(
        items: response.twoD,
        movieId: movieId,
        date: date,
        quality: '2D',
      ),
      threeD: _mapShowTimeList(
        items: response.threeD,
        movieId: movieId,
        date: date,
        quality: '3D',
      ),
    );
  }

  @override
  Future<ShowTime> getShowTimeById(String showtimeId) async {
    final dto = await _apiService.getShowTimeById(showtimeId);
    return ShowTime(
      id: dto.showtimeId,
      movieId: dto.movieId,
      date: dto.date,
      quality: dto.quality,
      startIso: dto.startIso,
      endIso: dto.endIso,
      hallId: dto.hallId,
    );
  }

  @override
  Future<HallInfo> getHallForShowTime(String showtimeId) async {
    final response = await _apiService.getHallForShowTime(showtimeId);

    final rows = response.hall.rows.map(_mapHallRow).toList();

    return HallInfo(
      showtime: ShowtimeMeta(
        id: response.showtime.showtimeId,
        movieId: response.showtime.movieId,
        date: response.showtime.date,
        quality: response.showtime.quality,
        startIso: response.showtime.startIso,
        endIso: response.showtime.endIso,
        hallId: response.showtime.hallId,
      ),
      cinema: CinemaMeta(
        id: response.cinema.id,
        name: response.cinema.name,
        address: response.cinema.address,
        city: response.cinema.city,
      ),
      hall: HallLayout(
        id: response.hall.id,
        name: response.hall.name,
        rows: rows,
      ),
    );
  }

  List<ShowTime> _mapShowTimeList({
    required List<dynamic> items,
    required int movieId,
    required String date,
    required String quality,
  }) {
    return items
        .map((s) => ShowTime(
      id: s.showtimeId,
      movieId: movieId,
      date: date,
      quality: quality,
      startIso: s.startIso,
      endIso: s.endIso,
      hallId: s.hallId,
    ))
        .toList();
  }

  HallRow _mapHallRow(dynamic r) {
    return HallRow(
      rowName: r.row,
      seats: r.seats.map(_mapHallSeat).toList(),
    );
  }

  HallSeat _mapHallSeat(dynamic s) {
    return HallSeat(
      code: s.code,
      status: _mapSeatStatus(s.status),
    );
  }

  HallSeatStatus _mapSeatStatus(HallSeatStatusDto status) {
    switch (status) {
      case HallSeatStatusDto.available:
        return HallSeatStatus.available;
      case HallSeatStatusDto.reserved:
        return HallSeatStatus.reserved;
      case HallSeatStatusDto.blocked:
        return HallSeatStatus.blocked;
    }
  }
}
