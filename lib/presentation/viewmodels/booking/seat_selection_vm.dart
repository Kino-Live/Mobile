import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/domain/entities/booking/hall.dart';
import 'package:kinolive_mobile/domain/usecases/booking/get_hall_for_showtime.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';
import 'package:kinolive_mobile/shared/providers/booking_provider.dart';

final seatSelectionVmProvider = NotifierProvider.family<SeatSelectionVm, SeatSelectionState, String>(
      (showtimeId) => SeatSelectionVm(),
);

enum SeatSelectionStatus { idle, loading, loaded, error }

class SeatSelectionState {
  final SeatSelectionStatus status;
  final String? error;

  final String showtimeId;
  final HallInfo? hallInfo;
  final Set<String> selected;

  const SeatSelectionState({
    this.status = SeatSelectionStatus.idle,
    this.error,
    this.showtimeId = '',
    this.hallInfo,
    this.selected = const {},
  });

  bool get isLoading => status == SeatSelectionStatus.loading;
  bool get hasError  => status == SeatSelectionStatus.error;
  bool get isLoaded  => status == SeatSelectionStatus.loaded;

  String get dateText  => hallInfo?.showtime.date ?? '';
  String get timeRange => _timeRange(hallInfo?.showtime.startIso, hallInfo?.showtime.endIso);
  bool   get is3D      => (hallInfo?.showtime.quality ?? '2D') == '3D';

  int get selectedCount => selected.length;

  SeatSelectionState copyWith({
    SeatSelectionStatus? status,
    String? error,
    String? showtimeId,
    HallInfo? hallInfo,
    Set<String>? selected,
  }) {
    return SeatSelectionState(
      status: status ?? this.status,
      error: error,
      showtimeId: showtimeId ?? this.showtimeId,
      hallInfo: hallInfo ?? this.hallInfo,
      selected: selected ?? this.selected,
    );
  }

  static String _timeRange(String? start, String? end) {
    if (start == null || end == null) return '';
    final s = start.split('T').last.substring(0, 5);
    final e = end.split('T').last.substring(0, 5);
    return '$s - $e';
  }
}

class SeatSelectionVm extends Notifier<SeatSelectionState> {
  late final GetHallForShowtime _getHall;

  @override
  SeatSelectionState build() {
    _getHall = ref.read(getHallForShowtimeProvider);
    return const SeatSelectionState();
  }

  Future<void> init(String showtimeId, {bool force = false}) async {
    if (state.isLoading && !force) return;

    state = state.copyWith(
      status: SeatSelectionStatus.loading,
      error: null,
      showtimeId: showtimeId,
      selected: <String>{},
    );

    try {
      final hallInfo = await _getHall(showtimeId);
      state = state.copyWith(
        status: SeatSelectionStatus.loaded,
        hallInfo: hallInfo,
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
