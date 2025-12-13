// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'online_movie_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnlineMovieDto _$OnlineMovieDtoFromJson(Map<String, dynamic> json) =>
    OnlineMovieDto(
      movieId: (json['movie_id'] as num).toInt(),
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
    );

OnlineMoviePurchaseDto _$OnlineMoviePurchaseDtoFromJson(
  Map<String, dynamic> json,
) => OnlineMoviePurchaseDto(
  orderId: json['order_id'] as String,
  movieId: (json['movie_id'] as num).toInt(),
  price: (json['price'] as num).toDouble(),
  currency: json['currency'] as String,
);

OnlineMovieWatchDto _$OnlineMovieWatchDtoFromJson(Map<String, dynamic> json) =>
    OnlineMovieWatchDto(
      movieId: (json['movie_id'] as num).toInt(),
      videoUrl: json['video_url'] as String,
    );

MyOnlineMovieDto _$MyOnlineMovieDtoFromJson(Map<String, dynamic> json) =>
    MyOnlineMovieDto(
      movieId: (json['movie_id'] as num).toInt(),
      title: json['title'] as String,
      posterUrl: json['poster_url'] as String,
      purchasedAt: json['purchased_at'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String,
    );
