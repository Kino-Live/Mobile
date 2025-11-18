import 'package:kinolive_mobile/domain/entities/payments/liqpay_init_payment.dart';

abstract class LiqPayRepository {
  Future<LiqpayInitPayment> initPayment({
    required double amount,
    required String currency,
    required String orderId,
    required String description,
    String? email,
  });
}
