import 'package:kinolive_mobile/data/models/booking/hall_dto.dart';
import 'package:kinolive_mobile/data/sources/remote/booking_api_service.dart';
import 'package:kinolive_mobile/domain/entities/booking/day_schedule.dart';
import 'package:kinolive_mobile/domain/entities/booking/hall.dart';
import 'package:kinolive_mobile/domain/entities/booking/movie_schedule.dart';
import 'package:kinolive_mobile/domain/entities/booking/showtime.dart';
import 'package:kinolive_mobile/domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingApiService apiService;

  BookingRepositoryImpl(this.apiService);

  @override
  Future<MovieSchedule> getMovieSchedule(int movieId) async {
    final movieScheduleDto = await apiService.getMovieShowTimesAll(movieId);

    final daySchedules = movieScheduleDto.days.map(
          (date, scheduleDto) => MapEntry(
        date,
        DaySchedule(
          twoD: scheduleDto.twoD
              .map(
                (showtimeDto) => ShowTime(
              id: showtimeDto.showtimeId,
              movieId: movieId,
              date: date,
              quality: '2D',
              startIso: showtimeDto.startIso,
              endIso: showtimeDto.endIso,
              hallId: showtimeDto.hallId,
            ),
          )
              .toList(),
          threeD: scheduleDto.threeD
              .map(
                (showtimeDto) => ShowTime(
              id: showtimeDto.showtimeId,
              movieId: movieId,
              date: date,
              quality: '3D',
              startIso: showtimeDto.startIso,
              endIso: showtimeDto.endIso,
              hallId: showtimeDto.hallId,
            ),
          )
              .toList(),
        ),
      ),
    );

    return MovieSchedule(
      movieId: movieScheduleDto.movieId,
      days: daySchedules,
      availableDays: movieScheduleDto.availableDays,
    );
  }

  @override
  Future<DaySchedule> getMovieScheduleForDate({
    required int movieId,
    required String date,
  }) async {
    final dayScheduleDto =
    await apiService.getMovieShowTimesForDate(movieId: movieId, date: date);

    final twoDShowtimes = dayScheduleDto.twoD
        .map(
          (showtimeDto) => ShowTime(
        id: showtimeDto.showtimeId,
        movieId: movieId,
        date: date,
        quality: '2D',
        startIso: showtimeDto.startIso,
        endIso: showtimeDto.endIso,
        hallId: showtimeDto.hallId,
      ),
    )
        .toList();

    final threeDShowtimes = dayScheduleDto.threeD
        .map(
          (showtimeDto) => ShowTime(
        id: showtimeDto.showtimeId,
        movieId: movieId,
        date: date,
        quality: '3D',
        startIso: showtimeDto.startIso,
        endIso: showtimeDto.endIso,
        hallId: showtimeDto.hallId,
      ),
    )
        .toList();

    return DaySchedule(twoD: twoDShowtimes, threeD: threeDShowtimes);
  }

  @override
  Future<ShowTime> getShowTimeById(String showtimeId) async {
    final showtimeDto = await apiService.getShowTimeById(showtimeId);

    return ShowTime(
      id: showtimeDto.showtimeId,
      movieId: showtimeDto.movieId,
      date: showtimeDto.date,
      quality: showtimeDto.quality,
      startIso: showtimeDto.startIso,
      endIso: showtimeDto.endIso,
      hallId: showtimeDto.hallId,
    );
  }

  @override
  Future<HallInfo> getHallForShowTime(String showtimeId) async {
    final hallInfoDto = await apiService.getHallForShowTime(showtimeId);

    final hallRows = hallInfoDto.hall.rows.map((rowDto) {
      final seats = rowDto.seats.map((seatDto) {
        final seatStatus = switch (seatDto.status) {
          HallSeatStatusDto.available => HallSeatStatus.available,
          HallSeatStatusDto.reserved => HallSeatStatus.reserved,
          HallSeatStatusDto.blocked => HallSeatStatus.blocked,
        };

        return HallSeat(
          code: seatDto.code,
          status: seatStatus,
          price: seatDto.price,
          currency: seatDto.currency,
        );
      }).toList();

      return HallRow(rowName: rowDto.row, seats: seats);
    }).toList();

    return HallInfo(
      showtime: ShowtimeMeta(
        id: hallInfoDto.showtime.showtimeId,
        movieId: hallInfoDto.showtime.movieId,
        date: hallInfoDto.showtime.date,
        quality: hallInfoDto.showtime.quality,
        startIso: hallInfoDto.showtime.startIso,
        endIso: hallInfoDto.showtime.endIso,
        hallId: hallInfoDto.showtime.hallId,
      ),
      cinema: CinemaMeta(
        id: hallInfoDto.cinema.id,
        name: hallInfoDto.cinema.name,
        address: hallInfoDto.cinema.address,
        city: hallInfoDto.cinema.city,
      ),
      hall: HallLayout(
        id: hallInfoDto.hall.id,
        name: hallInfoDto.hall.name,
        rows: hallRows,
      ),
    );
  }
}
