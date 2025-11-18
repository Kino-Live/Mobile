import 'package:json_annotation/json_annotation.dart';

part 'liqpay_init_payment_dto.g.dart';

@JsonSerializable()
class LiqPayInitPaymentDto {
  final String data;
  final String signature;

  final Map<String, dynamic>? params;

  LiqPayInitPaymentDto({
    required this.data,
    required this.signature,
    this.params,
  });

  factory LiqPayInitPaymentDto.fromJson(Map<String, dynamic> json) =>
      _$LiqpayInitPaymentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LiqpayInitPaymentDtoToJson(this);
}
