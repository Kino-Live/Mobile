// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDto _$OrderDtoFromJson(Map<String, dynamic> json) => OrderDto(
  orderId: json['order_id'] as String,
  userId: json['user_id'] as String,
  email: json['email'] as String,
  showtimeId: json['showtime_id'] as String,
  movieId: (json['movie_id'] as num).toInt(),
  hallId: (json['hall_id'] as num).toInt(),
  seats: (json['seats'] as List<dynamic>).map((e) => e as String).toList(),
  totalAmount: (json['total_amount'] as num).toDouble(),
  currency: json['currency'] as String,
  status: json['status'] as String,
  createdAt: json['created_at'] as String,
  paidAt: json['paid_at'] as String?,
  cancelledAt: json['cancelled_at'] as String?,
  refundedAt: json['refunded_at'] as String?,
  payment: json['payment'] as Map<String, dynamic>?,
  movieTitle: json['movie_title'] as String?,
  posterUrl: json['poster_url'] as String?,
);

Map<String, dynamic> _$OrderDtoToJson(OrderDto instance) => <String, dynamic>{
  'order_id': instance.orderId,
  'user_id': instance.userId,
  'email': instance.email,
  'showtime_id': instance.showtimeId,
  'movie_id': instance.movieId,
  'hall_id': instance.hallId,
  'seats': instance.seats,
  'total_amount': instance.totalAmount,
  'currency': instance.currency,
  'status': instance.status,
  'created_at': instance.createdAt,
  'paid_at': instance.paidAt,
  'cancelled_at': instance.cancelledAt,
  'refunded_at': instance.refundedAt,
  'payment': instance.payment,
  'movie_title': instance.movieTitle,
  'poster_url': instance.posterUrl,
};
