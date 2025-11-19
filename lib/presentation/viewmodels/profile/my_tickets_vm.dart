import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/domain/entities/orders/order.dart';
import 'package:kinolive_mobile/domain/usecases/orders/get_my_orders.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';
import 'package:kinolive_mobile/shared/providers/orders_providers.dart';

/// Provider for MyTickets view model
final myTicketsVmProvider =
NotifierProvider<MyTicketsVm, MyTicketsState>(MyTicketsVm.new);

/// Loading status for MyTickets
enum MyTicketsStatus { idle, loading, loaded, error }

/// State for MyTickets screen
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

/// View model that loads and manages user's orders (tickets)
class MyTicketsVm extends Notifier<MyTicketsState> {
  late final GetMyOrders _getMyOrders;

  @override
  MyTicketsState build() {
    // Read use case from provider
    _getMyOrders = ref.read(getMyOrdersProvider);
    return const MyTicketsState();
  }

  /// Loads all orders for the current user
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

  /// Clears current error message
  void clearError() => state = state.copyWith(error: null);
}
