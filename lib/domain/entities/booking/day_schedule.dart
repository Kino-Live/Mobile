import 'package:kinolive_mobile/domain/entities/booking/showtime.dart';

class DaySchedule {
  final List<Showtime> twoD;
  final List<Showtime> threeD;

  const DaySchedule({
    required this.twoD,
    required this.threeD,
  });

  bool get isEmpty => twoD.isEmpty && threeD.isEmpty;
}
