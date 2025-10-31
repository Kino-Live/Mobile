import 'package:kinolive_mobile/domain/entities/booking/showtime.dart';

class DaySchedule {
  final List<ShowTime> twoD;
  final List<ShowTime> threeD;

  const DaySchedule({
    required this.twoD,
    required this.threeD,
  });

  bool get isEmpty => twoD.isEmpty && threeD.isEmpty;
}
