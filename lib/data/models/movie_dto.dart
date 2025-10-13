import 'package:json_annotation/json_annotation.dart';

part 'movie_dto.g.dart';

@JsonSerializable(createToJson: false)
class MovieDto {
  final int id;
  final String title;

  @JsonKey(name: 'poster_url')
  final String posterUrl;

  final double rating;

  const MovieDto({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.rating,
  });

  factory MovieDto.fromJson(Map<String, dynamic> json) =>
      _$MovieDtoFromJson(json);
}
