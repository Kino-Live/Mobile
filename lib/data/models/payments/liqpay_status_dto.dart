import 'package:json_annotation/json_annotation.dart';

part 'liqpay_status_dto.g.dart';

@JsonSerializable()
class LiqPayStatusDto {
  final bool success;

  @JsonKey(name: 'order_id')
  final String orderId;

  final String status;

  final double? amount;
  final String? currency;

  final Map<String, dynamic>? raw;

  LiqPayStatusDto({
    required this.success,
    required this.orderId,
    required this.status,
    this.amount,
    this.currency,
    this.raw,
  });

  factory LiqPayStatusDto.fromJson(Map<String, dynamic> json) =>
      _$LiqPayStatusDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LiqPayStatusDtoToJson(this);
}
