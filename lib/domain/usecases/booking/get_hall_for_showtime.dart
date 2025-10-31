import 'package:kinolive_mobile/domain/entities/booking/hall.dart';
import 'package:kinolive_mobile/domain/repositories/booking_repository.dart';

class GetHallForShowtime {
  final BookingRepository _repo;
  GetHallForShowtime(this._repo);

  Future<HallInfo> call(String showtimeId) {
    return _repo.getHallForShowTime(showtimeId);
  }
}
