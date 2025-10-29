import 'package:json_annotation/json_annotation.dart';
import 'showtime_details_dto.dart';

part 'hall_dto.g.dart';

@JsonSerializable(createToJson: false)
class HallForShowtimeDto {
  final bool? success;

  final ShowtimeDetailsDto showtime;

  final CinemaInfoDto cinema;
  final HallInfoDto hall;

  const HallForShowtimeDto({
    this.success,
    required this.showtime,
    required this.cinema,
    required this.hall,
  });

  factory HallForShowtimeDto.fromJson(Map<String, dynamic> json) =>
      _$HallForShowtimeDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class CinemaInfoDto {
  final int id;
  final String name;
  final String address;
  final String city;

  const CinemaInfoDto({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
  });

  factory CinemaInfoDto.fromJson(Map<String, dynamic> json) =>
      _$CinemaInfoDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class HallInfoDto {
  final int id;
  final String name;
  final List<HallRowDto> rows;

  final Map<String, String>? legend;

  const HallInfoDto({
    required this.id,
    required this.name,
    required this.rows,
    this.legend,
  });

  factory HallInfoDto.fromJson(Map<String, dynamic> json) =>
      _$HallInfoDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class HallRowDto {
  final String row;
  final List<HallSeatDto> seats;

  const HallRowDto({required this.row, required this.seats});

  factory HallRowDto.fromJson(Map<String, dynamic> json) =>
      _$HallRowDtoFromJson(json);
}

enum HallSeatStatusDto { available, reserved, blocked }

@JsonSerializable(createToJson: false)
class HallSeatDto {
  final String code;
  final HallSeatStatusDto status;

  const HallSeatDto({required this.code, required this.status});

  factory HallSeatDto.fromJson(Map<String, dynamic> json) =>
      _$HallSeatDtoFromJson(json);
}
