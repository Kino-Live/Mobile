import 'package:kinolive_mobile/data/models/payments/liqpay_init_payment_dto.dart';
import 'package:kinolive_mobile/data/sources/remote/liqpay_api_service.dart';
import 'package:kinolive_mobile/domain/entities/payments/liqpay_init_payment.dart';
import 'package:kinolive_mobile/domain/repositories/liqpay_repository.dart';

class LiqPayRepositoryImpl implements LiqPayRepository {
  final LiqpayApiService _api;

  LiqPayRepositoryImpl(this._api);

  @override
  Future<LiqpayInitPayment> initPayment({
    required double amount,
    required String currency,
    required String orderId,
    required String description,
    String? email,
  }) async {
    final LiqpayInitPaymentDto dto = await _api.createPayment(
      amount: amount,
      currency: currency,
      orderId: orderId,
      description: description,
      email: email,
    );

    return _mapDtoToEntity(dto);
  }

  LiqpayInitPayment _mapDtoToEntity(LiqpayInitPaymentDto dto) {
    return LiqpayInitPayment(
      data: dto.data,
      signature: dto.signature,
      rawParams: dto.params,
    );
  }
}
