import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/domain/entities/booking/day_schedule.dart';
import 'package:kinolive_mobile/domain/entities/booking/movie_schedule.dart';
import 'package:kinolive_mobile/domain/entities/booking/showtime.dart';
import 'package:kinolive_mobile/domain/usecases/booking/get_movie_schedule.dart';
import 'package:kinolive_mobile/domain/usecases/booking/get_movie_schedule_for_date.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';
import 'package:kinolive_mobile/shared/providers/booking_provider.dart';

final scheduleVmProvider = NotifierProvider.family<ScheduleVm, ScheduleState, int>(
      (id) => ScheduleVm(),
);

enum ScheduleStatus { idle, loading, loaded, error }

class ScheduleState {
  final ScheduleStatus status;
  final String? error;
  final int movieId;
  final Map<String, DaySchedule> daysMap;
  final List<String> availableDays;
  final int selectedDayIndex;
  final String quality;
  final List<ShowTime> times;
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
  bool get hasError => status == ScheduleStatus.error;

  String? get selectedDate =>
      (availableDays.isEmpty || selectedDayIndex < 0 || selectedDayIndex >= availableDays.length)
          ? null
          : availableDays[selectedDayIndex];

  ShowTime? get selectedShowtime =>
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
    List<ShowTime>? times,
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
    _getAll = ref.read(getMovieScheduleProvider);
    _getForDate = ref.read(getMovieScheduleForDateProvider);
    return const ScheduleState();
  }

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
      final map = Map<String, DaySchedule>.from(full.days);
      final days = List<String>.from(full.availableDays)..sort();

      var selectedIndex = 0;
      if (days.isNotEmpty) selectedIndex = 0;

      final times = _buildTimesFor(map[days.elementAtOrNull(selectedIndex)]);
      state = state.copyWith(
        status: ScheduleStatus.loaded,
        daysMap: map,
        availableDays: days,
        selectedDayIndex: selectedIndex,
        times: times,
        selectedTimeIndex: 0,
      );

      _reconcileStateAfterRefresh();
    } on AppException catch (e) {
      state = state.copyWith(status: ScheduleStatus.error, error: e.message);
    } catch (e) {
      state = state.copyWith(status: ScheduleStatus.error, error: e.toString());
    }
  }

  void clearError() => state = state.copyWith(error: null);

  void setQuality(bool is3D) {
    final desired = is3D ? '3D' : '2D';
    if (desired == state.quality) return;

    final date = state.selectedDate;
    final iso = state.selectedShowtime?.startIso;

    if (date != null && iso != null) {
      final wantedAvailable = isQualityAvailableFor(date: date, startIso: iso, quality: desired);
      if (!wantedAvailable) {
        final alt = desired == '3D' ? '2D' : '3D';
        final altAvailable = isQualityAvailableFor(date: date, startIso: iso, quality: alt);
        if (altAvailable) {
          _setQualityInternal(alt);
          return;
        }
        _fallbackToFirstAvailableForDay(date, prefer2D: true);
        return;
      }
    }

    _setQualityInternal(desired);
  }

  Future<void> selectDay(int index) async {
    if (index < 0 || index >= state.availableDays.length) return;
    final date = state.availableDays[index];

    if (!state.daysMap.containsKey(date)) {
      await _loadDay(date);
      if (state.hasError) return;
    }

    final times = _buildTimesFor(state.daysMap[date]);
    state = state.copyWith(
      selectedDayIndex: index,
      times: times,
      selectedTimeIndex: 0,
    );

    _reconcileStateAfterRefresh();
  }

  Future<void> shiftDay(int delta) async {
    if (state.availableDays.isEmpty) return;
    final i = (state.selectedDayIndex + delta).clamp(0, state.availableDays.length - 1);
    await selectDay(i);
  }

  void selectTime(int index) {
    if (index < 0 || index >= state.times.length) return;
    state = state.copyWith(selectedTimeIndex: index);

    final date = state.selectedDate;
    final iso = state.selectedShowtime?.startIso;
    if (date == null || iso == null) return;

    final cur = state.quality;
    if (!isQualityAvailableFor(date: date, startIso: iso, quality: cur)) {
      final has3D = isQualityAvailableFor(date: date, startIso: iso, quality: '3D');
      final has2D = isQualityAvailableFor(date: date, startIso: iso, quality: '2D');
      if (has3D && !has2D) {
        _setQualityInternal('3D');
      } else if (has2D && !has3D) {
        _setQualityInternal('2D');
      } else {
        _fallbackToFirstAvailableForDay(date, prefer2D: true);
      }
    }
  }

  void shiftTime(int delta) {
    if (state.times.isEmpty) return;
    final i = (state.selectedTimeIndex + delta).clamp(0, state.times.length - 1);
    selectTime(i);
  }

  String? getShowtimeIdFor({
    required String date,
    required String startIso,
    required String quality, // '2D' | '3D'
  }) {
    final day = state.daysMap[date];
    if (day == null) return null;
    final list = (quality == '3D') ? day.threeD : day.twoD;
    for (final t in list) {
      if (t.startIso == startIso) return t.id;
    }
    return null;
  }

  String? getSelectedShowtimeIdForCurrentQuality() {
    final date = state.selectedDate;
    final iso = state.selectedShowtime?.startIso;
    if (date == null || iso == null) return null;
    return getShowtimeIdFor(date: date, startIso: iso, quality: state.quality);
  }

  void _setQualityInternal(String q) {
    state = state.copyWith(quality: q);
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

  List<ShowTime> _buildTimesFor(DaySchedule? day) {
    if (day == null) return const [];
    final all = <ShowTime>[];
    all..addAll(day.twoD)..addAll(day.threeD);
    final byIso = <String, ShowTime>{};
    for (final t in all) {
      byIso[t.startIso] = t;
    }
    final list = byIso.values.toList()..sort((a, b) => a.startIso.compareTo(b.startIso));
    return list;
  }

  bool isQualityAvailableFor({
    required String date,
    required String startIso,
    required String quality,
  }) {
    final day = state.daysMap[date];
    if (day == null) return false;
    final list = (quality == '3D') ? day.threeD : day.twoD;
    return list.any((t) => t.startIso == startIso);
  }

  void _reconcileStateAfterRefresh() {
    final date = state.selectedDate;
    final iso = state.selectedShowtime?.startIso;
    if (date == null || iso == null) return;

    if (!isQualityAvailableFor(date: date, startIso: iso, quality: state.quality)) {
      final has3D = isQualityAvailableFor(date: date, startIso: iso, quality: '3D');
      final has2D = isQualityAvailableFor(date: date, startIso: iso, quality: '2D');

      if (has3D && !has2D) {
        _setQualityInternal('3D');
      } else if (has2D && !has3D) {
        _setQualityInternal('2D');
      } else {
        _fallbackToFirstAvailableForDay(date, prefer2D: true);
      }
    }
  }

  void _fallbackToFirstAvailableForDay(String date, {bool prefer2D = true}) {
    final day = state.daysMap[date];
    if (day == null) return;

    if (prefer2D && day.twoD.isNotEmpty) {
      _setQualityInternal('2D');
      _setSelectedTimeByIso(day.twoD.first.startIso, day);
      return;
    }
    if (day.threeD.isNotEmpty) {
      _setQualityInternal('3D');
      _setSelectedTimeByIso(day.threeD.first.startIso, day);
      return;
    }
    if (day.twoD.isNotEmpty) {
      _setQualityInternal('2D');
      _setSelectedTimeByIso(day.twoD.first.startIso, day);
      return;
    }
  }

  void _setSelectedTimeByIso(String iso, DaySchedule day) {
    final times = _buildTimesFor(day);
    final idx = times.indexWhere((t) => t.startIso == iso);
    state = state.copyWith(
      times: times,
      selectedTimeIndex: idx >= 0 ? idx : 0,
    );
  }
}

extension<E> on List<E> {
  E? elementAtOrNull(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }
}
