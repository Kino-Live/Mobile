import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/domain/entities/booking/hall.dart';
import 'package:kinolive_mobile/domain/usecases/booking/get_hall_for_showtime.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';
import 'package:kinolive_mobile/shared/providers/booking_provider.dart';

class SeatSelectionArgs {
  final int movieId;
  final String showtimeId;
  const SeatSelectionArgs({required this.movieId, required this.showtimeId});
}

final seatSelectionVmProvider =
NotifierProvider.family<SeatSelectionVm, SeatSelectionState, SeatSelectionArgs>(
      (args) => SeatSelectionVm(),
);

enum SeatSelectionStatus { idle, loading, loaded, error }

class SeatSelectionState {
  final SeatSelectionStatus status;
  final String? error;

  final int movieId;
  final String showtimeId;

  final String date; // YYYY-MM-DD
  final String startIso; // ISO
  final String endIso; // ISO
  final String quality; // "2D" / "3D"

  final HallInfo? hallInfo;
  final Set<String> selected;

  const SeatSelectionState({
    this.status = SeatSelectionStatus.idle,
    this.error,
    this.movieId = 0,
    this.showtimeId = '',
    this.date = '',
    this.startIso = '',
    this.endIso = '',
    this.quality = '2D',
    this.hallInfo,
    this.selected = const {},
  });

  bool get isLoading => status == SeatSelectionStatus.loading;
  bool get hasError => status == SeatSelectionStatus.error;
  bool get isLoaded => status == SeatSelectionStatus.loaded;

  String get dateText {
    final iso = startIso.isNotEmpty ? startIso : hallInfo?.showtime.startIso;
    String ymd = '';
    if (iso != null && iso.contains('T')) {
      ymd = iso.split('T').first;
    } else {
      ymd = date.isNotEmpty ? date : (hallInfo?.showtime.date ?? '');
    }
    if (ymd.isEmpty) return '';

    final dayName = _weekdayEnFromYmd(ymd);
    final dmyShort = _dmyShortFromYmd(ymd);
    return '$dmyShort,\n$dayName';
  }

  String get timeRange {
    String _hhmm(String? iso) {
      if (iso == null || iso.isEmpty) return '';
      final m = RegExp(r'T(\d{2}):(\d{2})').firstMatch(iso);
      if (m != null) return '${m.group(1)}:${m.group(2)}';
      final t = iso.split('T');
      if (t.length > 1 && t[1].length >= 5) return t[1].substring(0, 5);
      return '';
    }

    final s = startIso.isNotEmpty ? startIso : hallInfo?.showtime.startIso;
    final e = endIso.isNotEmpty ? endIso : hallInfo?.showtime.endIso;
    if (s == null || e == null || s.isEmpty || e.isEmpty) return '';
    return '${_hhmm(s)} - ${_hhmm(e)}';
  }

  bool get is3D =>
      (quality.isNotEmpty ? quality : (hallInfo?.showtime.quality ?? '2D')) == '3D';

  int get selectedCount => selected.length;

  SeatSelectionState copyWith({
    SeatSelectionStatus? status,
    String? error,
    int? movieId,
    String? showtimeId,
    String? date,
    String? startIso,
    String? endIso,
    String? quality,
    HallInfo? hallInfo,
    Set<String>? selected,
  }) {
    return SeatSelectionState(
      status: status ?? this.status,
      error: error,
      movieId: movieId ?? this.movieId,
      showtimeId: showtimeId ?? this.showtimeId,
      date: date ?? this.date,
      startIso: startIso ?? this.startIso,
      endIso: endIso ?? this.endIso,
      quality: quality ?? this.quality,
      hallInfo: hallInfo ?? this.hallInfo,
      selected: selected ?? this.selected,
    );
  }
}

class SeatSelectionVm extends Notifier<SeatSelectionState> {
  late final GetHallForShowtime _getHall;

  @override
  SeatSelectionState build() {
    _getHall = ref.read(getHallForShowtimeProvider);
    return const SeatSelectionState();
  }

  Future<void> init({
    required int movieId,
    required String showtimeId,
    bool force = false,
  }) async {
    if (state.isLoading && !force) return;

    state = state.copyWith(
      status: SeatSelectionStatus.loading,
      error: null,
      movieId: movieId,
      showtimeId: showtimeId,
      selected: <String>{},
    );

    try {
      final hallInfo = await _getHall(showtimeId);
      final st = hallInfo.showtime;

      state = state.copyWith(
        status: SeatSelectionStatus.loaded,
        hallInfo: hallInfo,
        date: st.date,
        startIso: st.startIso,
        endIso: st.endIso,
        quality: st.quality,
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

// =================== HELPERS ===================

// YYYY-MM-DD -> dd.MM.yyyy
String _dmyShortFromYmd(String ymd) {
  final p = ymd.split('-');
  if (p.length != 3) return ymd;
  return '${p[2].padLeft(2, '0')}.${p[1].padLeft(2, '0')}.${p[0]}';
}

String _weekdayEnFromYmd(String ymd) {
  try {
    final dt = DateTime.parse(ymd);
    const names = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return names[(dt.weekday - 1) % 7];
  } catch (_) {
    return '';
  }
}
