import 'package:kinolive_mobile/domain/entities/booking/showtime.dart';
import 'package:kinolive_mobile/domain/repositories/booking_repository.dart';

class GetShowtimeById {
  final BookingRepository _repo;
  GetShowtimeById(this._repo);

  Future<Showtime> call(String showtimeId) {
    return _repo.getShowtimeById(showtimeId);
  }
}
