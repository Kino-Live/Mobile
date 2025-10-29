import 'package:json_annotation/json_annotation.dart';

part 'showtime_details_dto.g.dart';

@JsonSerializable(createToJson: false)
class ShowtimeDetailsDto {
  @JsonKey(name: 'showtime_id')
  final String showtimeId;

  @JsonKey(name: 'movie_id')
  final int movieId;

  final String date;

  final String quality;

  @JsonKey(name: 'start_iso')
  final String startIso;

  @JsonKey(name: 'end_iso')
  final String endIso;

  @JsonKey(name: 'hall_id')
  final int hallId;

  const ShowtimeDetailsDto({
    required this.showtimeId,
    required this.movieId,
    required this.date,
    required this.quality,
    required this.startIso,
    required this.endIso,
    required this.hallId,
  });

  factory ShowtimeDetailsDto.fromJson(Map<String, dynamic> json) =>
      _$ShowtimeDetailsDtoFromJson(json);
}
