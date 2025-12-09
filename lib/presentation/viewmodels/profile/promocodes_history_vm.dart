import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/domain/entities/promocodes/promocode.dart';
import 'package:kinolive_mobile/domain/usecases/promocodes/get_my_promocodes.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';
import 'package:kinolive_mobile/shared/providers/promocodes_providers.dart';

final promocodesHistoryVmProvider =
    NotifierProvider<PromocodesHistoryVm, PromocodesHistoryState>(
  PromocodesHistoryVm.new,
);

enum PromocodesHistoryStatus { idle, loading, loaded, error }

class PromocodesHistoryState {
  final PromocodesHistoryStatus status;
  final List<Promocode> promocodes;
  final String? error;

  const PromocodesHistoryState({
    this.status = PromocodesHistoryStatus.idle,
    this.promocodes = const [],
    this.error,
  });

  bool get isLoading => status == PromocodesHistoryStatus.loading;
  bool get hasError => status == PromocodesHistoryStatus.error;
  bool get isEmpty => promocodes.isEmpty;

  PromocodesHistoryState copyWith({
    PromocodesHistoryStatus? status,
    List<Promocode>? promocodes,
    String? error,
  }) {
    return PromocodesHistoryState(
      status: status ?? this.status,
      promocodes: promocodes ?? this.promocodes,
      error: error,
    );
  }
}

class PromocodesHistoryVm extends Notifier<PromocodesHistoryState> {
  late final GetMyPromocodes _getMyPromocodes;

  @override
  PromocodesHistoryState build() {
    _getMyPromocodes = ref.read(getMyPromocodesProvider);
    return const PromocodesHistoryState();
  }

  Future<void> load() async {
    if (state.isLoading) return;

    state = state.copyWith(
      status: PromocodesHistoryStatus.loading,
      error: null,
      promocodes: const <Promocode>[],
    );

    try {
      final promocodes = await _getMyPromocodes();
      state = state.copyWith(
        status: PromocodesHistoryStatus.loaded,
        promocodes: promocodes,
        error: null,
      );
    } on AppException catch (e) {
      state = state.copyWith(
        status: PromocodesHistoryStatus.error,
        error: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        status: PromocodesHistoryStatus.error,
        error: e.toString(),
      );
    }
  }

  void clearError() => state = state.copyWith(error: null);
}

