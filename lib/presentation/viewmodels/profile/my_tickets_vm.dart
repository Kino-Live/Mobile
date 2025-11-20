import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/domain/entities/orders/order.dart';
import 'package:kinolive_mobile/domain/usecases/orders/get_my_orders.dart';
import 'package:kinolive_mobile/domain/usecases/orders/refund_order.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';
import 'package:kinolive_mobile/shared/providers/orders_providers.dart';

final myTicketsVmProvider =
NotifierProvider<MyTicketsVm, MyTicketsState>(MyTicketsVm.new);

enum MyTicketsStatus { idle, loading, loaded, error }

class MyTicketsState {
  final MyTicketsStatus status;
  final List<Order> orders;
  final String? error;

  const MyTicketsState({
    this.status = MyTicketsStatus.idle,
    this.orders = const [],
    this.error,
  });

  bool get isLoading => status == MyTicketsStatus.loading;
  bool get hasError => status == MyTicketsStatus.error;
  bool get isEmpty => orders.isEmpty;

  MyTicketsState copyWith({
    MyTicketsStatus? status,
    List<Order>? orders,
    String? error,
  }) {
    return MyTicketsState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      error: error,
    );
  }
}

class MyTicketsVm extends Notifier<MyTicketsState> {
  late final GetMyOrders _getMyOrders;
  late final RefundOrder _refundOrder;

  @override
  MyTicketsState build() {
    _getMyOrders = ref.read(getMyOrdersProvider);
    _refundOrder = ref.read(refundOrderProvider);
    return const MyTicketsState();
  }

  Future<void> load() async {
    if (state.isLoading) return;

    state = state.copyWith(
      status: MyTicketsStatus.loading,
      error: null,
      orders: const <Order>[],
    );

    try {
      final orders = await _getMyOrders();
      state = state.copyWith(
        status: MyTicketsStatus.loaded,
        orders: orders,
        error: null,
      );
    } on AppException catch (e) {
      state = state.copyWith(
        status: MyTicketsStatus.error,
        error: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        status: MyTicketsStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> refund(String orderId) async {
    try {
      final updated = await _refundOrder(orderId);
      final updatedList = state.orders
          .map((o) => o.id == orderId ? updated : o)
          .toList(growable: false);

      state = state.copyWith(
        status: MyTicketsStatus.loaded,
        orders: updatedList,
        error: null,
      );
    } on AppException catch (e) {
      state = state.copyWith(
        error: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
      );
    }
  }

  void clearError() => state = state.copyWith(error: null);
}
