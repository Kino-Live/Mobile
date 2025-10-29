import 'package:kinolive_mobile/domain/entities/booking/movie_schedule.dart';
import 'package:kinolive_mobile/domain/repositories/booking_repository.dart';

class GetMovieSchedule {
  final BookingRepository _repo;
  GetMovieSchedule(this._repo);

  Future<MovieSchedule> call(int movieId) {
    return _repo.getMovieSchedule(movieId);
  }
}
