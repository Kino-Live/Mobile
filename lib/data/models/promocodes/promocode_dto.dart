import 'package:json_annotation/json_annotation.dart';

part 'promocode_dto.g.dart';

@JsonSerializable()
class PromocodeDto {
  final String id;
  final String code;

  @JsonKey(name: 'user_email')
  final String userEmail;

  final double amount;
  final String currency;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'expires_at')
  final String expiresAt;

  @JsonKey(name: 'used_at')
  final String? usedAt;

  @JsonKey(name: 'order_id')
  final String orderId;

  @JsonKey(name: 'used_in_order_id')
  final String? usedInOrderId;

  final String status;

  @JsonKey(name: 'is_active')
  final bool isActive;

  const PromocodeDto({
    required this.id,
    required this.code,
    required this.userEmail,
    required this.amount,
    required this.currency,
    required this.createdAt,
    required this.expiresAt,
    this.usedAt,
    required this.orderId,
    this.usedInOrderId,
    required this.status,
    required this.isActive,
  });

  factory PromocodeDto.fromJson(Map<String, dynamic> json) =>
      _$PromocodeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PromocodeDtoToJson(this);
}

