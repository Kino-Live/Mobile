import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/domain/entities/orders/order.dart';
import 'package:kinolive_mobile/domain/usecases/orders/get_my_orders.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';
import 'package:kinolive_mobile/shared/providers/orders_providers.dart';

final ticketsHistoryVmProvider =
NotifierProvider<TicketsHistoryVm, TicketsHistoryState>(
  TicketsHistoryVm.new,
);

enum TicketsHistoryStatus { idle, loading, loaded, error }

class TicketsHistoryState {
  final TicketsHistoryStatus status;
  final List<Order> orders;
  final String? error;

  const TicketsHistoryState({
    this.status = TicketsHistoryStatus.idle,
    this.orders = const [],
    this.error,
  });

  bool get isLoading => status == TicketsHistoryStatus.loading;
  bool get hasError => status == TicketsHistoryStatus.error;
  bool get isEmpty => orders.isEmpty;

  TicketsHistoryState copyWith({
    TicketsHistoryStatus? status,
    List<Order>? orders,
    String? error,
  }) {
    return TicketsHistoryState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      error: error,
    );
  }
}

class TicketsHistoryVm extends Notifier<TicketsHistoryState> {
  late final GetMyOrders _getMyOrders;

  @override
  TicketsHistoryState build() {
    _getMyOrders = ref.read(getMyOrdersProvider);
    return const TicketsHistoryState();
  }

  Future<void> load() async {
    if (state.isLoading) return;

    state = state.copyWith(
      status: TicketsHistoryStatus.loading,
      error: null,
      orders: const <Order>[],
    );

    try {
      final orders = await _getMyOrders();
      state = state.copyWith(
        status: TicketsHistoryStatus.loaded,
        orders: orders,
        error: null,
      );
    } on AppException catch (e) {
      state = state.copyWith(
        status: TicketsHistoryStatus.error,
        error: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        status: TicketsHistoryStatus.error,
        error: e.toString(),
      );
    }
  }

  void clearError() => state = state.copyWith(error: null);
  
  void clearHistory() {
    state = state.copyWith(
      status: TicketsHistoryStatus.idle,
      orders: const [],
      error: null,
    );
  }
}
