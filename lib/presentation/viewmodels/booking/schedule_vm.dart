import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/domain/entities/booking/day_schedule.dart';
import 'package:kinolive_mobile/domain/entities/booking/movie_schedule.dart';
import 'package:kinolive_mobile/domain/entities/booking/showtime.dart';

import 'package:kinolive_mobile/domain/usecases/booking/get_movie_schedule.dart';
import 'package:kinolive_mobile/domain/usecases/booking/get_movie_schedule_for_date.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';

import '../../../shared/providers/booking_provider.dart' show getMovieScheduleProvider, getMovieScheduleForDateProvider;

final scheduleVmProvider = NotifierProvider.family<ScheduleVm, ScheduleState, int>(
      (id) => ScheduleVm(),
);

enum ScheduleStatus { idle, loading, loaded, error }

class ScheduleState {
  final ScheduleStatus status;
  final String? error;

  final int movieId;

  final Map<String, DaySchedule> daysMap; // "YYYY-MM-DD" -> DaySchedule
  final List<String> availableDays;
  final int selectedDayIndex;

  /// "2D" | "3D"
  final String quality;

  final List<Showtime> times;
  final int selectedTimeIndex;

  const ScheduleState({
    this.status = ScheduleStatus.idle,
    this.error,
    this.movieId = 0,
    this.daysMap = const {},
    this.availableDays = const [],
    this.selectedDayIndex = 0,
    this.quality = '2D',
    this.times = const [],
    this.selectedTimeIndex = 0,
  });

  bool get isLoading => status == ScheduleStatus.loading;
  bool get hasError  => status == ScheduleStatus.error;

  String? get selectedDate =>
      (availableDays.isEmpty || selectedDayIndex < 0 || selectedDayIndex >= availableDays.length)
          ? null
          : availableDays[selectedDayIndex];

  Showtime? get selectedShowtime =>
      (times.isEmpty || selectedTimeIndex < 0 || selectedTimeIndex >= times.length)
          ? null
          : times[selectedTimeIndex];

  ScheduleState copyWith({
    ScheduleStatus? status,
    String? error,
    int? movieId,
    Map<String, DaySchedule>? daysMap,
    List<String>? availableDays,
    int? selectedDayIndex,
    String? quality,
    List<Showtime>? times,
    int? selectedTimeIndex,
  }) {
    return ScheduleState(
      status: status ?? this.status,
      error: error,
      movieId: movieId ?? this.movieId,
      daysMap: daysMap ?? this.daysMap,
      availableDays: availableDays ?? this.availableDays,
      selectedDayIndex: selectedDayIndex ?? this.selectedDayIndex,
      quality: quality ?? this.quality,
      times: times ?? this.times,
      selectedTimeIndex: selectedTimeIndex ?? this.selectedTimeIndex,
    );
  }
}

class ScheduleVm extends Notifier<ScheduleState> {
  late final GetMovieSchedule _getAll;
  late final GetMovieScheduleForDate _getForDate;

  @override
  ScheduleState build() {
    _getAll   = ref.read(getMovieScheduleProvider);
    _getForDate = ref.read(getMovieScheduleForDateProvider);
    return const ScheduleState();
  }

  /// call from initState:
  /// ref.read(scheduleVmProvider(movieId).notifier).init(movieId);
  Future<void> init(int movieId, {bool force = false}) async {
    if (state.isLoading && !force) return;

    state = state.copyWith(
      status: ScheduleStatus.loading,
      error: null,
      movieId: movieId,
      daysMap: const {},
      availableDays: const [],
      selectedDayIndex: 0,
      times: const [],
      selectedTimeIndex: 0,
    );

    try {
      final MovieSchedule full = await _getAll(movieId);

      final map  = Map<String, DaySchedule>.from(full.days);
      final days = List<String>.from(full.availableDays)..sort();

      var selectedIndex = 0;
      if (days.isNotEmpty) {
        // TODO: pick nearest >= today if needed
        selectedIndex = 0;
      }

      final times = _buildTimesFor(
        map[days.elementAtOrNull(selectedIndex)],
        quality: state.quality,
      );

      state = state.copyWith(
        status: ScheduleStatus.loaded,
        daysMap: map,
        availableDays: days,
        selectedDayIndex: selectedIndex,
        times: times,
        selectedTimeIndex: times.isEmpty ? 0 : 0,
      );
    } on AppException catch (e) {
      state = state.copyWith(status: ScheduleStatus.error, error: e.message);
    } catch (e) {
      state = state.copyWith(status: ScheduleStatus.error, error: e.toString());
    }
  }

  void clearError() => state = state.copyWith(error: null);

  // === Actions ===

  void setQuality(bool is3D) {
    final q = is3D ? '3D' : '2D';
    if (q == state.quality) return;
    _setQualityInternal(q);
  }

  Future<void> selectDay(int index) async {
    if (index < 0 || index >= state.availableDays.length) return;

    final date = state.availableDays[index];

    if (!state.daysMap.containsKey(date)) {
      await _loadDay(date);
      if (state.hasError) return;
    }

    final times = _buildTimesFor(state.daysMap[date], quality: state.quality);
    state = state.copyWith(
      selectedDayIndex: index,
      times: times,
      selectedTimeIndex: times.isEmpty ? 0 : 0,
    );
  }

  Future<void> shiftDay(int delta) async {
    if (state.availableDays.isEmpty) return;
    final i = (state.selectedDayIndex + delta).clamp(0, state.availableDays.length - 1);
    await selectDay(i);
  }

  void selectTime(int index) {
    if (index < 0 || index >= state.times.length) return;
    state = state.copyWith(selectedTimeIndex: index);
  }

  void shiftTime(int delta) {
    if (state.times.isEmpty) return;
    final i = (state.selectedTimeIndex + delta).clamp(0, state.times.length - 1);
    selectTime(i);
  }

  String? getSelectedShowtimeId() => state.selectedShowtime?.id;

  // === Helpers ===

  void _setQualityInternal(String q) async {
    final date = state.selectedDate;
    if (date == null) return;

    if (!state.daysMap.containsKey(date)) {
      await _loadDay(date);
      if (state.hasError) return;
    }

    final times = _buildTimesFor(state.daysMap[date], quality: q);
    state = state.copyWith(
      quality: q,
      times: times,
      selectedTimeIndex: times.isEmpty ? 0 : 0,
    );
  }

  Future<void> _loadDay(String date) async {
    try {
      final day = await _getForDate(movieId: state.movieId, date: date);
      final newMap = {...state.daysMap}..[date] = day;
      state = state.copyWith(daysMap: newMap);
    } on AppException catch (e) {
      state = state.copyWith(status: ScheduleStatus.error, error: e.message);
    } catch (e) {
      state = state.copyWith(status: ScheduleStatus.error, error: e.toString());
    }
  }

  List<Showtime> _buildTimesFor(
      DaySchedule? day, {
        required String quality,
      }) {
    if (day == null) return const [];
    final list = (quality == '3D') ? day.threeD : day.twoD;
    final sorted = [...list]..sort((a, b) => a.startIso.compareTo(b.startIso));
    return sorted;
  }
}

extension<E> on List<E> {
  E? elementAtOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }
}
