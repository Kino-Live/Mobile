import 'package:json_annotation/json_annotation.dart';
import 'day_showtimes_dto.dart';

part 'movie_showtimes_all_dto.g.dart';

@JsonSerializable(createToJson: false)
class MovieShowtimesAllDto {
  @JsonKey(name: 'movie_id')
  final int movieId;

  @JsonKey(fromJson: _daysFromJson)
  final Map<String, DayShowtimesDto> days;

  @JsonKey(name: 'available_days', defaultValue: [])
  final List<String> availableDays;

  const MovieShowtimesAllDto({
    required this.movieId,
    required this.days,
    required this.availableDays,
  });

  factory MovieShowtimesAllDto.fromJson(Map<String, dynamic> json) =>
      _$MovieShowtimesAllDtoFromJson(json);

  // ---- helpers ----
  static Map<String, DayShowtimesDto> _daysFromJson(Object? raw) {
    final map = (raw as Map?)?.cast<String, dynamic>() ?? const <String, dynamic>{};
    final result = <String, DayShowtimesDto>{};
    map.forEach((k, v) {
      if (v is Map<String, dynamic>) {
        result[k] = DayShowtimesDto.fromJson(v);
      } else {
        result[k] = const DayShowtimesDto(twoD: [], threeD: []);
      }
    });
    return result;
  }
}