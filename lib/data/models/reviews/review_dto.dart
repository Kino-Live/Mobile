import 'package:json_annotation/json_annotation.dart';

part 'review_dto.g.dart';

@JsonSerializable()
class ReviewDto {
  final String id;

  @JsonKey(name: 'movie_id')
  final int movieId;

  @JsonKey(name: 'user_email')
  final String userEmail;

  @JsonKey(name: 'user_name')
  final String userName;

  final int rating;

  final String comment;

  @JsonKey(name: 'created_at')
  final String createdAt;

  @JsonKey(name: 'movie_title')
  final String? movieTitle;

  @JsonKey(name: 'poster_url')
  final String? posterUrl;

  const ReviewDto({
    required this.id,
    required this.movieId,
    required this.userEmail,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.movieTitle,
    this.posterUrl,
  });

  factory ReviewDto.fromJson(Map<String, dynamic> json) =>
      _$ReviewDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewDtoToJson(this);
}

