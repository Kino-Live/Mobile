import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/domain/entities/orders/order.dart';
import 'package:kinolive_mobile/domain/usecases/orders/create_order.dart';
import 'package:kinolive_mobile/presentation/screens/booking/payment/payment_screen.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';
import 'package:kinolive_mobile/shared/providers/orders_providers.dart';

final paymentVmProvider = NotifierProvider.family<PaymentVm, PaymentState, PaymentScreenArgs>(
      (args) => PaymentVm(),
);

enum PaymentStatus { idle, processing, success, error }

class PaymentState {
  final PaymentStatus status;
  final String? error;
  final Order? order;

  const PaymentState({
    this.status = PaymentStatus.idle,
    this.error,
    this.order,
  });

  bool get isProcessing => status == PaymentStatus.processing;
  bool get isSuccess => status == PaymentStatus.success;
  bool get hasError => status == PaymentStatus.error && (error ?? '').isNotEmpty;

  PaymentState copyWith({
    PaymentStatus? status,
    String? error,
    Order? order,
  }) {
    return PaymentState(
      status: status ?? this.status,
      error: error,
      order: order ?? this.order,
    );
  }
}

class PaymentVm extends Notifier<PaymentState> {
  late final CreateOrder _createOrder;

  @override
  PaymentState build() {
    _createOrder = ref.read(createOrderProvider);
    return const PaymentState();
  }

  Future<void> pay(PaymentScreenArgs args) async {
    if (state.isProcessing) return;

    state = state.copyWith(
      status: PaymentStatus.processing,
      error: null,
    );

    try {
      final showtime = args.hallInfo.showtime;
      final hall = args.hallInfo.hall;

      final order = await _createOrder(
        showtimeId: showtime.id,
        movieId: showtime.movieId,
        hallId: hall.id,
        seats: args.selectedCodes,
        totalAmount: args.totalPrice,
        currency: args.totalCurrency,
      );

      state = state.copyWith(
        status: PaymentStatus.success,
        error: null,
        order: order,
      );
    } on AppException catch (e) {
      state = state.copyWith(
        status: PaymentStatus.error,
        error: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        status: PaymentStatus.error,
        error: 'Payment failed. Please try again.',
      );
    }
  }

  void clearError() {
    if (!state.hasError) return;
    state = state.copyWith(
      status: PaymentStatus.idle,
      error: null,
    );
  }

  void clearSuccess() {
    if (!state.isSuccess) return;
    state = state.copyWith(
      status: PaymentStatus.idle,
      error: null,
    );
  }
}
