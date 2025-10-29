import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/data/repositories/booking_repository_impl.dart';
import 'package:kinolive_mobile/data/sources/remote/booking_api_service.dart';
import 'package:kinolive_mobile/domain/repositories/booking_repository.dart';
import 'package:kinolive_mobile/domain/usecases/booking/get_movie_schedule.dart';
import 'package:kinolive_mobile/domain/usecases/booking/get_movie_schedule_for_date.dart';
import 'package:kinolive_mobile/domain/usecases/booking/get_showtime_by_id.dart';
import 'package:kinolive_mobile/domain/usecases/booking/get_hall_for_showtime.dart';
import 'package:kinolive_mobile/shared/providers/network/dio_provider.dart';

final bookingApiServiceProvider = Provider<BookingApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return BookingApiService(dio);
});

final bookingRepositoryProvider = Provider<BookingRepository>((ref) {
  final api = ref.watch(bookingApiServiceProvider);
  return BookingRepositoryImpl(api);
});

final getMovieScheduleProvider = Provider<GetMovieSchedule>((ref) {
  final repo = ref.watch(bookingRepositoryProvider);
  return GetMovieSchedule(repo);
});

final getMovieScheduleForDateProvider = Provider<GetMovieScheduleForDate>((ref) {
  final repo = ref.watch(bookingRepositoryProvider);
  return GetMovieScheduleForDate(repo);
});

final getShowtimeByIdProvider = Provider<GetShowtimeById>((ref) {
  final repo = ref.watch(bookingRepositoryProvider);
  return GetShowtimeById(repo);
});

final getHallForShowtimeProvider = Provider<GetHallForShowtime>((ref) {
  final repo = ref.watch(bookingRepositoryProvider);
  return GetHallForShowtime(repo);
});
