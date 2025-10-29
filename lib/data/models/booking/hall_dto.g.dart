// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hall_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HallForShowtimeDto _$HallForShowtimeDtoFromJson(Map<String, dynamic> json) =>
    HallForShowtimeDto(
      success: json['success'] as bool?,
      showtime: ShowtimeDetailsDto.fromJson(
        json['showtime'] as Map<String, dynamic>,
      ),
      cinema: CinemaInfoDto.fromJson(json['cinema'] as Map<String, dynamic>),
      hall: HallInfoDto.fromJson(json['hall'] as Map<String, dynamic>),
    );

CinemaInfoDto _$CinemaInfoDtoFromJson(Map<String, dynamic> json) =>
    CinemaInfoDto(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
    );

HallInfoDto _$HallInfoDtoFromJson(Map<String, dynamic> json) => HallInfoDto(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  rows: (json['rows'] as List<dynamic>)
      .map((e) => HallRowDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  legend: (json['legend'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
);

HallRowDto _$HallRowDtoFromJson(Map<String, dynamic> json) => HallRowDto(
  row: json['row'] as String,
  seats: (json['seats'] as List<dynamic>)
      .map((e) => HallSeatDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

HallSeatDto _$HallSeatDtoFromJson(Map<String, dynamic> json) => HallSeatDto(
  code: json['code'] as String,
  status: $enumDecode(_$HallSeatStatusDtoEnumMap, json['status']),
);

const _$HallSeatStatusDtoEnumMap = {
  HallSeatStatusDto.available: 'available',
  HallSeatStatusDto.reserved: 'reserved',
  HallSeatStatusDto.blocked: 'blocked',
};
