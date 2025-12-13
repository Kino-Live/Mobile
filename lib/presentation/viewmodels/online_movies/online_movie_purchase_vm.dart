import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/domain/entities/payments/liqpay_init_payment.dart';
import 'package:kinolive_mobile/domain/entities/online_movies/online_movie.dart';
import 'package:kinolive_mobile/domain/repositories/online_movies_repository.dart';
import 'package:kinolive_mobile/domain/usecases/payments/check_liqpay_payment_status.dart';
import 'package:kinolive_mobile/domain/usecases/payments/init_liqpay_payment.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';
import 'package:kinolive_mobile/shared/providers/liqpay_providers.dart';
import 'package:kinolive_mobile/shared/providers/online_movies_providers.dart';

final onlineMoviePurchaseVmProvider =
    NotifierProvider.family<OnlineMoviePurchaseVm, OnlineMoviePurchaseState, int>(
  (movieId) => OnlineMoviePurchaseVm()..setMovieId(movieId),
);

enum OnlineMoviePurchaseStatus { idle, processing, success, error }

class OnlineMoviePurchaseState {
  final OnlineMoviePurchaseStatus status;
  final String? error;
  final OnlineMoviePurchase? purchase;
  final LiqpayInitPayment? liqpayPayment;
  final String? liqpayOrderId;

  const OnlineMoviePurchaseState({
    this.status = OnlineMoviePurchaseStatus.idle,
    this.error,
    this.purchase,
    this.liqpayPayment,
    this.liqpayOrderId,
  });

  bool get isProcessing => status == OnlineMoviePurchaseStatus.processing;
  bool get isSuccess => status == OnlineMoviePurchaseStatus.success;
  bool get hasError =>
      status == OnlineMoviePurchaseStatus.error && (error ?? '').isNotEmpty;

  OnlineMoviePurchaseState copyWith({
    OnlineMoviePurchaseStatus? status,
    String? error,
    OnlineMoviePurchase? purchase,
    LiqpayInitPayment? liqpayPayment,
    String? liqpayOrderId,
  }) {
    return OnlineMoviePurchaseState(
      status: status ?? this.status,
      error: error,
      purchase: purchase ?? this.purchase,
      liqpayPayment: liqpayPayment ?? this.liqpayPayment,
      liqpayOrderId: liqpayOrderId ?? this.liqpayOrderId,
    );
  }
}

class OnlineMoviePurchaseVm extends Notifier<OnlineMoviePurchaseState> {
  late final OnlineMoviesRepository _repository;
  late final InitLiqPayPayment _initLiqpayPayment;
  late final CheckLiqPayStatus _checkLiqpayStatus;
  int? _movieId;

  @override
  OnlineMoviePurchaseState build() {
    _repository = ref.read(onlineMoviesRepositoryProvider);
    _initLiqpayPayment = ref.read(initLiqPayPaymentProvider);
    _checkLiqpayStatus = ref.read(checkLiqPayStatusProvider);
    return const OnlineMoviePurchaseState();
  }

  void setMovieId(int movieId) {
    _movieId = movieId;
  }

  Future<LiqpayInitPayment?> initLiqpay(OnlineMovie movie) async {
    if (state.isProcessing || _movieId == null) return null;

    state = state.copyWith(
      status: OnlineMoviePurchaseStatus.processing,
      error: null,
      purchase: null,
      liqpayPayment: null,
      liqpayOrderId: null,
    );

    try {
      final purchaseInfo = await _repository.purchaseMovie(_movieId!);

      final orderId = purchaseInfo.orderId;

      final payment = await _initLiqpayPayment(
        amount: purchaseInfo.price,
        currency: purchaseInfo.currency,
        orderId: orderId,
        description: 'Online movie access',
      );

      state = state.copyWith(
        status: OnlineMoviePurchaseStatus.idle,
        error: null,
        purchase: purchaseInfo,
        liqpayPayment: payment,
        liqpayOrderId: orderId,
      );

      return payment;
    } on AppException catch (e) {
      state = state.copyWith(
        status: OnlineMoviePurchaseStatus.error,
        error: e.message,
        purchase: null,
        liqpayPayment: null,
        liqpayOrderId: null,
      );
      return null;
    } catch (_) {
      state = state.copyWith(
        status: OnlineMoviePurchaseStatus.error,
        error: 'Payment could not be initialized.',
        purchase: null,
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
        status: OnlineMoviePurchaseStatus.error,
        error: e.message,
      );
      return null;
    } catch (_) {
      state = state.copyWith(
        status: OnlineMoviePurchaseStatus.error,
        error: 'Could not check payment status.',
      );
      return null;
    }
  }

  Future<bool> confirmPurchase() async {
    if (state.isProcessing || state.purchase == null || _movieId == null) return false;

    state = state.copyWith(
      status: OnlineMoviePurchaseStatus.processing,
      error: null,
    );

    try {
      await _repository.confirmPurchase(
        _movieId!,
        state.purchase!.orderId,
        state.purchase!.price,
        state.purchase!.currency,
      );

      state = state.copyWith(
        status: OnlineMoviePurchaseStatus.success,
        error: null,
      );

      return true;
    } on AppException catch (e) {
      state = state.copyWith(
        status: OnlineMoviePurchaseStatus.error,
        error: e.message,
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        status: OnlineMoviePurchaseStatus.error,
        error: 'Failed to confirm purchase.',
      );
      return false;
    }
  }

  void clearError() {
    if (!state.hasError) return;
    state = state.copyWith(
      status: OnlineMoviePurchaseStatus.idle,
      error: null,
    );
  }

  void clearSuccess() {
    if (!state.isSuccess) return;
    state = state.copyWith(
      status: OnlineMoviePurchaseStatus.idle,
      error: null,
    );
  }
}
