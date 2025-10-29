import 'package:kinolive_mobile/domain/entities/booking/day_schedule.dart';
import 'package:kinolive_mobile/domain/entities/booking/hall.dart';
import 'package:kinolive_mobile/domain/entities/booking/movie_schedule.dart';
import 'package:kinolive_mobile/domain/entities/booking/showtime.dart';

abstract class BookingRepository {
  Future<MovieSchedule> getMovieSchedule(int movieId);

  Future<DaySchedule> getMovieScheduleForDate({
    required int movieId,
    required String date,
  });

  Future<Showtime> getShowtimeById(String showtimeId);

  Future<HallInfo> getHallForShowtime(String showtimeId);
}
