import 'package:kinolive_mobile/data/models/booking/hall_dto.dart';
import 'package:kinolive_mobile/data/sources/remote/booking_api_service.dart';
import 'package:kinolive_mobile/domain/entities/booking/day_schedule.dart';
import 'package:kinolive_mobile/domain/entities/booking/hall.dart';
import 'package:kinolive_mobile/domain/entities/booking/movie_schedule.dart';
import 'package:kinolive_mobile/domain/entities/booking/showtime.dart';
import 'package:kinolive_mobile/domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingApiService _api;

  BookingRepositoryImpl(this._api);

  @override
  Future<MovieSchedule> getMovieSchedule(int movieId) async {
    final dto = await _api.getMovieShowTimesAll(movieId);
    final days = dto.days.map(
          (key, value) => MapEntry(
        key,
        DaySchedule(
          twoD: value.twoD
              .map(
                (s) => ShowTime(
              id: s.showtimeId,
              movieId: movieId,
              date: key,
              quality: '2D',
              startIso: s.startIso,
              endIso: s.endIso,
              hallId: s.hallId,
            ),
          )
              .toList(),
          threeD: value.threeD
              .map(
                (s) => ShowTime(
              id: s.showtimeId,
              movieId: movieId,
              date: key,
              quality: '3D',
              startIso: s.startIso,
              endIso: s.endIso,
              hallId: s.hallId,
            ),
          )
              .toList(),
        ),
      ),
    );

    return MovieSchedule(
      movieId: dto.movieId,
      days: days,
      availableDays: dto.availableDays,
    );
  }

  @override
  Future<DaySchedule> getMovieScheduleForDate({
    required int movieId,
    required String date,
  }) async {
    final dto = await _api.getMovieShowTimesForDate(movieId: movieId, date: date);
    return DaySchedule(
      twoD: dto.twoD
          .map(
            (s) => ShowTime(
          id: s.showtimeId,
          movieId: movieId,
          date: date,
          quality: '2D',
          startIso: s.startIso,
          endIso: s.endIso,
          hallId: s.hallId,
        ),
      )
          .toList(),
      threeD: dto.threeD
          .map(
            (s) => ShowTime(
          id: s.showtimeId,
          movieId: movieId,
          date: date,
          quality: '3D',
          startIso: s.startIso,
          endIso: s.endIso,
          hallId: s.hallId,
        ),
      )
          .toList(),
    );
  }

  @override
  Future<ShowTime> getShowTimeById(String showtimeId) async {
    final dto = await _api.getShowTimeById(showtimeId);
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
    final dto = await _api.getHallForShowTime(showtimeId);

    final hallRows = dto.hall.rows
        .map(
          (r) => HallRow(
        rowName: r.row,
        seats: r.seats
            .map(
              (s) => HallSeat(
            code: s.code,
            status: switch (s.status) {
              HallSeatStatusDto.available => HallSeatStatus.available,
              HallSeatStatusDto.reserved => HallSeatStatus.reserved,
              HallSeatStatusDto.blocked => HallSeatStatus.blocked,
            },
          ),
        )
            .toList(),
      ),
    )
        .toList();

    return HallInfo(
      showtime: ShowtimeMeta(
        id: dto.showtime.showtimeId,
        movieId: dto.showtime.movieId,
        date: dto.showtime.date,
        quality: dto.showtime.quality,
        startIso: dto.showtime.startIso,
        endIso: dto.showtime.endIso,
        hallId: dto.showtime.hallId,
      ),
      cinema: CinemaMeta(
        id: dto.cinema.id,
        name: dto.cinema.name,
        address: dto.cinema.address,
        city: dto.cinema.city,
      ),
      hall: HallLayout(
        id: dto.hall.id,
        name: dto.hall.name,
        rows: hallRows,
      ),
    );
  }
}
