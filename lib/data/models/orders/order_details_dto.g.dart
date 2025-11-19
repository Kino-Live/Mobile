// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_details_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDetailsDto _$OrderDetailsDtoFromJson(Map<String, dynamic> json) =>
    OrderDetailsDto(
      orderId: json['order_id'] as String,
      movieTitle: json['movie_title'] as String,
      showStartIso: json['show_start_iso'] as String,
      cinemaName: json['cinema_name'] as String,
      cinemaAddress: json['cinema_address'] as String,
      cinemaCity: json['cinema_city'] as String,
      seats: (json['seats'] as List<dynamic>).map((e) => e as String).toList(),
      ticketsCount: (json['tickets_count'] as num).toInt(),
    );

Map<String, dynamic> _$OrderDetailsDtoToJson(OrderDetailsDto instance) =>
    <String, dynamic>{
      'order_id': instance.orderId,
      'movie_title': instance.movieTitle,
      'show_start_iso': instance.showStartIso,
      'cinema_name': instance.cinemaName,
      'cinema_address': instance.cinemaAddress,
      'cinema_city': instance.cinemaCity,
      'seats': instance.seats,
      'tickets_count': instance.ticketsCount,
    };
