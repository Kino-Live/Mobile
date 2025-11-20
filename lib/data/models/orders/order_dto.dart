import 'package:json_annotation/json_annotation.dart';

part 'order_dto.g.dart';

@JsonSerializable()
class OrderDto {
  @JsonKey(name: 'order_id')
  final String orderId;

  @JsonKey(name: 'user_id')
  final String userId;

  final String email;

  @JsonKey(name: 'showtime_id')
  final String showtimeId;

  @JsonKey(name: 'movie_id')
  final int movieId;

  @JsonKey(name: 'hall_id')
  final int hallId;

  final List<String> seats;

  @JsonKey(name: 'total_amount')
  final double totalAmount;

  final String currency;

  /// paid | cancelled | refunded
  final String status;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'paid_at')
  final String? paidAt;

  @JsonKey(name: 'cancelled_at')
  final String? cancelledAt;

  @JsonKey(name: 'refunded_at')
  final String? refundedAt;

  final Map<String, dynamic>? payment;

  @JsonKey(name: 'movie_title')
  final String? movieTitle;

  @JsonKey(name: 'poster_url')
  final String? posterUrl;

  @JsonKey(name: 'show_start_iso')
  final String? showStartIso;

  const OrderDto({
    required this.orderId,
    required this.userId,
    required this.email,
    required this.showtimeId,
    required this.movieId,
    required this.hallId,
    required this.seats,
    required this.totalAmount,
    required this.currency,
    required this.status,
    required this.createdAt,
    this.paidAt,
    this.cancelledAt,
    this.refundedAt,
    this.payment,
    this.movieTitle,
    this.posterUrl,
    this.showStartIso,
  });

  factory OrderDto.fromJson(Map<String, dynamic> json) =>
      _$OrderDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDtoToJson(this);
}
