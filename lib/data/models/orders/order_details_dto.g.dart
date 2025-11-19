// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_details_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDetailsDto _$OrderDetailsDtoFromJson(Map<String, dynamic> json) =>
    OrderDetailsDto(
      orderId: json['order_id'] as String,
      movieId: (json['movie_id'] as num).toInt(),
      hallId: (json['hall_id'] as num).toInt(),
      showtimeId: json['showtime_id'] as String,
      seats: (json['seats'] as List<dynamic>).map((e) => e as String).toList(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      currency: json['currency'] as String,
      status: json['status'] as String,
      createdAt: json['created_at'] as String,
      paidAt: json['paid_at'] as String?,
    );

Map<String, dynamic> _$OrderDetailsDtoToJson(OrderDetailsDto instance) =>
    <String, dynamic>{
      'order_id': instance.orderId,
      'movie_id': instance.movieId,
      'hall_id': instance.hallId,
      'showtime_id': instance.showtimeId,
      'seats': instance.seats,
      'total_amount': instance.totalAmount,
      'currency': instance.currency,
      'status': instance.status,
      'created_at': instance.createdAt,
      'paid_at': instance.paidAt,
    };
