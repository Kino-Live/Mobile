import 'package:kinolive_mobile/domain/entities/booking/day_schedule.dart';
import 'package:kinolive_mobile/domain/repositories/booking_repository.dart';

class GetMovieScheduleForDate {
  final BookingRepository _repo;
  GetMovieScheduleForDate(this._repo);

  Future<DaySchedule> call({
    required int movieId,
    required String date,
  }) {
    return _repo.getMovieScheduleForDate(movieId: movieId, date: date);
  }
}
