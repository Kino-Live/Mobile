import 'package:kinolive_mobile/domain/entities/payments/liqpay_init_payment.dart';
import 'package:kinolive_mobile/domain/repositories/liqpay_repository.dart';

class InitLiqPayPayment {
  final LiqPayRepository _repo;

  InitLiqPayPayment(this._repo);

  Future<LiqpayInitPayment> call({
    required double amount,
    required String currency,
    required String orderId,
    required String description,
    String? email,
  }) {
    return _repo.initPayment(
      amount: amount,
      currency: currency,
      orderId: orderId,
      description: description,
      email: email,
    );
  }
}
