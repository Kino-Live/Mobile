// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'liqpay_init_payment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiqPayInitPaymentDto _$LiqPayInitPaymentDtoFromJson(
  Map<String, dynamic> json,
) => LiqPayInitPaymentDto(
  data: json['data'] as String,
  signature: json['signature'] as String,
  params: json['params'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$LiqPayInitPaymentDtoToJson(
  LiqPayInitPaymentDto instance,
) => <String, dynamic>{
  'data': instance.data,
  'signature': instance.signature,
  'params': instance.params,
};
