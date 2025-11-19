import 'package:json_annotation/json_annotation.dart';

part 'order_details_dto.g.dart';

@JsonSerializable()
class OrderDetailsDto {
  @JsonKey(name: 'order_id')
  final String orderId;

  @JsonKey(name: 'movie_title')
  final String movieTitle;

  @JsonKey(name: 'show_start_iso')
  final String showStartIso;

  @JsonKey(name: 'cinema_name')
  final String cinemaName;

  @JsonKey(name: 'cinema_address')
  final String cinemaAddress;

  @JsonKey(name: 'cinema_city')
  final String cinemaCity;

  final List<String> seats;

  @JsonKey(name: 'tickets_count')
  final int ticketsCount;

  const OrderDetailsDto({
    required this.orderId,
    required this.movieTitle,
    required this.showStartIso,
    required this.cinemaName,
    required this.cinemaAddress,
    required this.cinemaCity,
    required this.seats,
    required this.ticketsCount,
  });

  factory OrderDetailsDto.fromJson(Map<String, dynamic> json)
  => _$OrderDetailsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailsDtoToJson(this);
}