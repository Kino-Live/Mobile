// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'showtime_slot_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowtimeSlotDto _$ShowtimeSlotDtoFromJson(Map<String, dynamic> json) =>
    ShowtimeSlotDto(
      showtimeId: json['showtime_id'] as String,
      startIso: json['start_iso'] as String,
      endIso: json['end_iso'] as String,
      hallId: (json['hall_id'] as num).toInt(),
    );
