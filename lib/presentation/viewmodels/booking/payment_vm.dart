import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/domain/entities/orders/order.dart';
import 'package:kinolive_mobile/domain/entities/payments/check_liqpay_status.dart';
import 'package:kinolive_mobile/domain/entities/payments/liqpay_init_payment.dart';
import 'package:kinolive_mobile/domain/usecases/orders/create_order.dart';
import 'package:kinolive_mobile/domain/usecases/payments/init_liqpay_payment.dart';
import 'package:kinolive_mobile/presentation/screens/booking/payment/payment_screen.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';
import 'package:kinolive_mobile/shared/providers/liqpay_providers.dart';
import 'package:kinolive_mobile/shared/providers/orders_providers.dart';

final paymentVmProvider =
NotifierProvider.family<PaymentVm, PaymentState, PaymentScreenArgs>(
      (args) => PaymentVm(),
);

enum PaymentStatus { idle, processing, success, error }

class PaymentState {
  final PaymentStatus status;
  final String? error;
  final Order? order;

  final LiqpayInitPayment? liqpayPayment;

  final String? liqpayOrderId;

  const PaymentState({
    this.status = PaymentStatus.idle,
    this.error,
    this.order,
    this.liqpayPayment,
    this.liqpayOrderId,
  });

  bool get isProcessing => status == PaymentStatus.processing;
  bool get isSuccess => status == PaymentStatus.success;
  bool get hasError =>
      status == PaymentStatus.error && (error ?? '').isNotEmpty;

  PaymentState copyWith({
    PaymentStatus? status,
    String? error,
    Order? order,
    LiqpayInitPayment? liqpayPayment,
    String? liqpayOrderId,
  }) {
    return PaymentState(
      status: status ?? this.status,
      error: error,
      order: order ?? this.order,
      liqpayPayment: liqpayPayment ?? this.liqpayPayment,
      liqpayOrderId: liqpayOrderId ?? this.liqpayOrderId,
    );
  }
}

class PaymentVm extends Notifier<PaymentState> {
  late final CreateOrder _createOrder;
  late final InitLiqPayPayment _initLiqpayPayment;
  late final CheckLiqPayStatus _checkLiqpayStatus;

  @override
  PaymentState build() {
    _createOrder = ref.read(createOrderProvider);
    _initLiqpayPayment = ref.read(initLiqPayPaymentProvider);
    _checkLiqpayStatus = ref.read(checkLiqPayStatusProvider);
    return const PaymentState();
  }

  Future<LiqpayInitPayment?> initLiqpay(PaymentScreenArgs args) async {
    if (state.isProcessing) return null;

    state = state.copyWith(
      status: PaymentStatus.processing,
      error: null,
      order: null,
      liqpayPayment: null,
      liqpayOrderId: null,
    );

    try {
      final hallInfo = args.hallInfo;

      final orderId =
          'cinema_${hallInfo.showtime.id}_${DateTime.now().millisecondsSinceEpoch}';

      final payment = await _initLiqpayPayment(
        amount: args.totalPrice,
        currency: args.totalCurrency,
        orderId: orderId,
        description: 'Tickets for ${args.movieTitle}',
      );

      state = state.copyWith(
        status: PaymentStatus.idle,
        error: null,
        liqpayPayment: payment,
        liqpayOrderId: orderId,
      );

      return payment;
    } on AppException catch (e) {
      state = state.copyWith(
        status: PaymentStatus.error,
        error: e.message,
        liqpayPayment: null,
        liqpayOrderId: null,
      );
      return null;
    } catch (_) {
      state = state.copyWith(
        status: PaymentStatus.error,
        error: 'Payment could not be initialized.',
        liqpayPayment: null,
        liqpayOrderId: null,
      );
      return null;
    }
  }

  Future<String?> checkLiqpayStatus() async {
    final orderId = state.liqpayOrderId;
    if (orderId == null || orderId.isEmpty) {
      return null;
    }

    try {
      final status = await _checkLiqpayStatus(orderId: orderId);
      return status;
    } on AppException catch (e) {
      state = state.copyWith(
        status: PaymentStatus.error,
        error: e.message,
      );
      return null;
    } catch (_) {
      state = state.copyWith(
        status: PaymentStatus.error,
        error: 'Could not check payment status.',
      );
      return null;
    }
  }

  Future<void> createOrderAfterLiqpay(PaymentScreenArgs args) async {
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
    } catch (_) {
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
