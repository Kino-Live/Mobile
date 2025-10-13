// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieDto _$MovieDtoFromJson(Map<String, dynamic> json) => MovieDto(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  posterUrl: json['poster_url'] as String,
  rating: (json['rating'] as num).toDouble(),
);
