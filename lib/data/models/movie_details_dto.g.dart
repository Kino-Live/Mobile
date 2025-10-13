// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie_details_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieDetailsDto _$MovieDetailsDtoFromJson(Map<String, dynamic> json) =>
    MovieDetailsDto(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      originalTitle: json['original_title'] as String,
      posterUrl: json['poster_url'] as String,
      year: (json['year'] as num).toInt(),
      ageRestrictions: json['age_restrictions'] as String,
      genres: (json['genres'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      language: json['language'] as String,
      duration: json['duration'] as String,
      producer: json['producer'] as String,
      director: json['director'] as String,
      cast: (json['cast'] as List<dynamic>).map((e) => e as String).toList(),
      description: json['description'] as String,
      trailerUrl: json['trailer_url'] as String,
      rating: (json['rating'] as num).toDouble(),
    );
