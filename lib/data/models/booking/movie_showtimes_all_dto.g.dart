// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_showtimes_all_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieShowtimesAllDto _$MovieShowtimesAllDtoFromJson(
  Map<String, dynamic> json,
) => MovieShowtimesAllDto(
  movieId: (json['movie_id'] as num).toInt(),
  days: MovieShowtimesAllDto._daysFromJson(json['days']),
  availableDays:
      (json['available_days'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
);
