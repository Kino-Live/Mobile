// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewDto _$ReviewDtoFromJson(Map<String, dynamic> json) => ReviewDto(
  id: json['id'] as String,
  movieId: (json['movie_id'] as num).toInt(),
  userEmail: json['user_email'] as String,
  userName: json['user_name'] as String,
  rating: (json['rating'] as num).toInt(),
  comment: json['comment'] as String,
  createdAt: json['created_at'] as String,
  movieTitle: json['movie_title'] as String?,
  posterUrl: json['poster_url'] as String?,
);

Map<String, dynamic> _$ReviewDtoToJson(ReviewDto instance) => <String, dynamic>{
  'id': instance.id,
  'movie_id': instance.movieId,
  'user_email': instance.userEmail,
  'user_name': instance.userName,
  'rating': instance.rating,
  'comment': instance.comment,
  'created_at': instance.createdAt,
  'movie_title': instance.movieTitle,
  'poster_url': instance.posterUrl,
};
