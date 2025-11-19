import 'package:json_annotation/json_annotation.dart';

part 'order_details_dto.g.dart';

@JsonSerializable()
class OrderDetailsDto {
  @JsonKey(name: 'order_id')
  final String orderId;

  @JsonKey(name: 'movie_id')
  final int movieId;

  @JsonKey(name: 'hall_id')
  final int hallId;

  @JsonKey(name: 'showtime_id')
  final String showtimeId;

  final List<String> seats;

  @JsonKey(name: 'total_amount')
  final double totalAmount;

  final String currency;

  /// paid | cancelled | refunded | pending
  final String status;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'paid_at')
  final String? paidAt;

  const OrderDetailsDto({
    required this.orderId,
    required this.movieId,
    required this.hallId,
    required this.showtimeId,
    required this.seats,
    required this.totalAmount,
    required this.currency,
    required this.status,
    required this.createdAt,
    this.paidAt,
  });

  factory OrderDetailsDto.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailsDtoToJson(this);
}
