import 'package:json_annotation/json_annotation.dart';

part 'movie_dto.g.dart';

@JsonSerializable(createToJson: false)
class MovieDto {
  final int id;
  final String title;

  @JsonKey(name: 'original_title')
  final String originalTitle;

  @JsonKey(name: 'poster_url')
  final String posterUrl;

  final int year;

  @JsonKey(name: 'age_restrictions')
  final String ageRestrictions;

  final List<String> genres;
  final String language;
  final String duration;
  final String producer;
  final String director;
  final List<String> cast;
  final String description;

  @JsonKey(name: 'trailer_url')
  final String trailerUrl;

  final double rating;

  const MovieDto({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.posterUrl,
    required this.year,
    required this.ageRestrictions,
    required this.genres,
    required this.language,
    required this.duration,
    required this.producer,
    required this.director,
    required this.cast,
    required this.description,
    required this.trailerUrl,
    required this.rating,
  });

  factory MovieDto.fromJson(Map<String, dynamic> json) =>
      _$MovieDtoFromJson(json);
}
