// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'liqpay_init_payment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiqpayInitPaymentDto _$LiqpayInitPaymentDtoFromJson(
  Map<String, dynamic> json,
) => LiqpayInitPaymentDto(
  data: json['data'] as String,
  signature: json['signature'] as String,
  params: json['params'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$LiqpayInitPaymentDtoToJson(
  LiqpayInitPaymentDto instance,
) => <String, dynamic>{
  'data': instance.data,
  'signature': instance.signature,
  'params': instance.params,
};
