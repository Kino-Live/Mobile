import 'package:json_annotation/json_annotation.dart';
import 'day_showtimes_dto.dart';

part 'movie_showtimes_all_dto.g.dart';

@JsonSerializable(createToJson: false)
class MovieShowtimesAllDto {
  @JsonKey(name: 'movie_id')
  final int movieId;

  final Map<String, DayShowtimesDto> days;

  @JsonKey(name: 'available_days')
  final List<String> availableDays;

  const MovieShowtimesAllDto({
    required this.movieId,
    required this.days,
    required this.availableDays,
  });

  factory MovieShowtimesAllDto.fromJson(Map<String, dynamic> json) =>
      _$MovieShowtimesAllDtoFromJson(json);
}
