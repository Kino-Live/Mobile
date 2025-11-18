import 'package:json_annotation/json_annotation.dart';

part 'liqpay_init_payment_dto.g.dart';

@JsonSerializable()
class LiqpayInitPaymentDto {
  final String data;
  final String signature;

  final Map<String, dynamic>? params;

  LiqpayInitPaymentDto({
    required this.data,
    required this.signature,
    this.params,
  });

  factory LiqpayInitPaymentDto.fromJson(Map<String, dynamic> json) =>
      _$LiqpayInitPaymentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LiqpayInitPaymentDtoToJson(this);
}
