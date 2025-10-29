// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_showtimes_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DayShowtimesDto _$DayShowtimesDtoFromJson(Map<String, dynamic> json) =>
    DayShowtimesDto(
      twoD: (json['2D'] as List<dynamic>)
          .map((e) => ShowtimeSlotDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      threeD: (json['3D'] as List<dynamic>)
          .map((e) => ShowtimeSlotDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
