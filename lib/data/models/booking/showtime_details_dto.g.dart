// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'showtime_details_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShowtimeDetailsDto _$ShowtimeDetailsDtoFromJson(Map<String, dynamic> json) =>
    ShowtimeDetailsDto(
      showtimeId: json['showtime_id'] as String,
      movieId: (json['movie_id'] as num).toInt(),
      date: json['date'] as String,
      quality: json['quality'] as String,
      startIso: json['start_iso'] as String,
      endIso: json['end_iso'] as String,
      hallId: (json['hall_id'] as num).toInt(),
    );
