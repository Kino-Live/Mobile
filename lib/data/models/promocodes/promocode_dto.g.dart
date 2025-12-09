// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promocode_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromocodeDto _$PromocodeDtoFromJson(Map<String, dynamic> json) => PromocodeDto(
  id: json['id'] as String,
  code: json['code'] as String,
  userEmail: json['user_email'] as String,
  amount: (json['amount'] as num).toDouble(),
  currency: json['currency'] as String,
  createdAt: json['created_at'] as String,
  expiresAt: json['expires_at'] as String,
  usedAt: json['used_at'] as String?,
  orderId: json['order_id'] as String,
  usedInOrderId: json['used_in_order_id'] as String?,
  status: json['status'] as String,
  isActive: json['is_active'] as bool,
);

Map<String, dynamic> _$PromocodeDtoToJson(PromocodeDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'user_email': instance.userEmail,
      'amount': instance.amount,
      'currency': instance.currency,
      'created_at': instance.createdAt,
      'expires_at': instance.expiresAt,
      'used_at': instance.usedAt,
      'order_id': instance.orderId,
      'used_in_order_id': instance.usedInOrderId,
      'status': instance.status,
      'is_active': instance.isActive,
    };
