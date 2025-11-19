import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/domain/entities/orders/order_details.dart';
import 'package:kinolive_mobile/domain/usecases/orders/get_order_details.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';
import 'package:kinolive_mobile/shared/providers/orders_providers.dart';

final ticketDetailsVmProvider =
NotifierProvider.family<TicketDetailsVm, TicketDetailsState, String>(
      (orderId) => TicketDetailsVm(),
);

enum TicketDetailsStatus { idle, loading, loaded, error }

class TicketDetailsState {
  final TicketDetailsStatus status;
  final OrderDetails? order;
  final String? error;

  const TicketDetailsState({
    this.status = TicketDetailsStatus.idle,
    this.order,
    this.error,
  });

  bool get isLoading => status == TicketDetailsStatus.loading;
  bool get hasError => status == TicketDetailsStatus.error;
  bool get isLoaded => status == TicketDetailsStatus.loaded;

  TicketDetailsState copyWith({
    TicketDetailsStatus? status,
    OrderDetails? order,
    String? error,
  }) {
    return TicketDetailsState(
      status: status ?? this.status,
      order: order ?? this.order,
      error: error,
    );
  }
}

class TicketDetailsVm extends Notifier<TicketDetailsState> {
  late final GetOrderDetails _getOrderDetails;

  @override
  TicketDetailsState build() {
    _getOrderDetails = ref.read(getOrderDetailsProvider);
    return const TicketDetailsState();
  }

  Future<void> init(String orderId, {bool force = false}) async {
    state = const TicketDetailsState(
      status: TicketDetailsStatus.loading,
      order: null,
      error: null,
    );

    try {
      final details = await _getOrderDetails(orderId);
      state = TicketDetailsState(
        status: TicketDetailsStatus.loaded,
        order: details,
        error: null,
      );
    } on AppException catch (e) {
      state = TicketDetailsState(
        status: TicketDetailsStatus.error,
        order: null,
        error: e.message,
      );
    } catch (e) {
      state = TicketDetailsState(
        status: TicketDetailsStatus.error,
        order: null,
        error: e.toString(),
      );
    }
  }

  void clearError() => state = state.copyWith(error: null);
}
