import 'package:kinolive_mobile/domain/entities/booking/day_schedule.dart';

class MovieSchedule {
  final int movieId;
  final Map<String, DaySchedule> days; // key = "YYYY-MM-DD"
  final List<String> availableDays;

  const MovieSchedule({
    required this.movieId,
    required this.days,
    required this.availableDays,
  });
}
