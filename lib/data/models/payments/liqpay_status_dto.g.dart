// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'liqpay_status_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LiqPayStatusDto _$LiqPayStatusDtoFromJson(Map<String, dynamic> json) =>
    LiqPayStatusDto(
      success: json['success'] as bool,
      orderId: json['order_id'] as String,
      status: json['status'] as String,
      amount: (json['amount'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      raw: json['raw'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$LiqPayStatusDtoToJson(LiqPayStatusDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'order_id': instance.orderId,
      'status': instance.status,
      'amount': instance.amount,
      'currency': instance.currency,
      'raw': instance.raw,
    };
