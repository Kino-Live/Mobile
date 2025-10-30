import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/domain/entities/booking/hall.dart';
import 'package:kinolive_mobile/domain/entities/booking/showtime.dart';
import 'package:kinolive_mobile/domain/usecases/booking/get_hall_for_showtime.dart';
import 'package:kinolive_mobile/domain/usecases/booking/get_showtime_by_id.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';
import 'package:kinolive_mobile/shared/providers/booking_provider.dart';

class SeatSelectionArgs {
  final int movieId;
  final String showtimeId;
  const SeatSelectionArgs({required this.movieId, required this.showtimeId});
}

final seatSelectionVmProvider = NotifierProvider.family<SeatSelectionVm, SeatSelectionState, SeatSelectionArgs>(
    (args) => SeatSelectionVm(),
);

enum SeatSelectionStatus { idle, loading, loaded, error }

class SeatSelectionState {
  final SeatSelectionStatus status;
  final String? error;

  final int movieId;
  final String showtimeId;

  final HallInfo? hallInfo;
  final String? date;       // YYYY-MM-DD
  final String? startIso;
  final String? endIso;
  final String quality;     // "2D" / "3D"

  final Set<String> selected;

  const SeatSelectionState({
    this.status = SeatSelectionStatus.idle,
    this.error,
    this.movieId = 0,
    this.showtimeId = '',
    this.hallInfo,
    this.date,
    this.startIso,
    this.endIso,
    this.quality = '2D',
    this.selected = const {},
  });

  bool get isLoading => status == SeatSelectionStatus.loading;
  bool get hasError  => status == SeatSelectionStatus.error;
  bool get isLoaded  => status == SeatSelectionStatus.loaded;

  String get dateText  => date ?? hallInfo?.showtime.date ?? '';
  String get timeRange => _timeRange(startIso ?? hallInfo?.showtime.startIso, endIso ?? hallInfo?.showtime.endIso);
  bool   get is3D      => (quality.isNotEmpty ? quality : (hallInfo?.showtime.quality ?? '2D')) == '3D';

  int get selectedCount => selected.length;

  SeatSelectionState copyWith({
    SeatSelectionStatus? status,
    String? error,
    int? movieId,
    String? showtimeId,
    HallInfo? hallInfo,
    String? date,
    String? startIso,
    String? endIso,
    String? quality,
    Set<String>? selected,
  }) {
    return SeatSelectionState(
      status: status ?? this.status,
      error: error,
      movieId: movieId ?? this.movieId,
      showtimeId: showtimeId ?? this.showtimeId,
      hallInfo: hallInfo ?? this.hallInfo,
      date: date ?? this.date,
      startIso: startIso ?? this.startIso,
      endIso: endIso ?? this.endIso,
      quality: quality ?? this.quality,
      selected: selected ?? this.selected,
    );
  }

  static String _timeRange(String? start, String? end) {
    if (start == null || end == null || start.isEmpty || end.isEmpty) return '';
    final s = start.split('T').last.substring(0, 5);
    final e = end.split('T').last.substring(0, 5);
    return '$s - $e';
  }
}

class SeatSelectionVm extends Notifier<SeatSelectionState> {
  late final GetHallForShowtime _getHall;
  late final GetShowtimeById _getShowtime;

  @override
  SeatSelectionState build() {
    _getHall = ref.read(getHallForShowtimeProvider);
    _getShowtime = ref.read(getShowtimeByIdProvider);
    return const SeatSelectionState();
  }

  Future<void> init(String showtimeId, {int? movieId, bool force = false}) async {
    if (state.isLoading && !force) return;

    state = state.copyWith(
      status: SeatSelectionStatus.loading,
      error: null,
      movieId: movieId ?? state.movieId,
      showtimeId: showtimeId,
      selected: <String>{},
    );

    try {
      final hallInfo = await _getHall(showtimeId);

      Showtime? st;
      try {
        st = await _getShowtime(showtimeId);
      } catch (_) {
      }

      final resolvedMovieId = movieId ?? hallInfo.showtime.movieId;
      final resolvedDate    = st?.date    ?? hallInfo.showtime.date;
      final resolvedStart   = st?.startIso?? hallInfo.showtime.startIso;
      final resolvedEnd     = st?.endIso  ?? hallInfo.showtime.endIso;
      final resolvedQuality = st?.quality ?? hallInfo.showtime.quality;

      state = state.copyWith(
        status: SeatSelectionStatus.loaded,
        hallInfo: hallInfo,
        movieId: resolvedMovieId,
        date: resolvedDate,
        startIso: resolvedStart,
        endIso: resolvedEnd,
        quality: resolvedQuality,
        error: null,
      );
    } on AppException catch (e) {
      state = state.copyWith(status: SeatSelectionStatus.error, error: e.message);
    } catch (e) {
      state = state.copyWith(status: SeatSelectionStatus.error, error: e.toString());
    }
  }

  void clearError() => state = state.copyWith(error: null);

  bool canSelect(String seatCode) {
    final layout = state.hallInfo?.hall.rows ?? const <HallRow>[];
    for (final r in layout) {
      for (final s in r.seats) {
        if (s.code == seatCode) {
          return s.status == HallSeatStatus.available || state.selected.contains(seatCode);
        }
      }
    }
    return false;
  }

  void toggleSeat(String seatCode) {
    if (!canSelect(seatCode)) return;
    final sel = {...state.selected};
    sel.contains(seatCode) ? sel.remove(seatCode) : sel.add(seatCode);
    state = state.copyWith(selected: sel);
  }

  void clearSelection() => state = state.copyWith(selected: <String>{});

  List<String> getSelectedSeats() => state.selected.toList()..sort();
}
