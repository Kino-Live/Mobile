import 'package:json_annotation/json_annotation.dart';

part 'online_movie_dto.g.dart';

@JsonSerializable(createToJson: false)
class OnlineMovieDto {
  @JsonKey(name: 'movie_id')
  final int movieId;

  final double price;
  final String currency;

  const OnlineMovieDto({
    required this.movieId,
    required this.price,
    required this.currency,
  });

  factory OnlineMovieDto.fromJson(Map<String, dynamic> json) =>
      _$OnlineMovieDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class OnlineMoviePurchaseDto {
  @JsonKey(name: 'order_id')
  final String orderId;

  @JsonKey(name: 'movie_id')
  final int movieId;

  final double price;
  final String currency;

  const OnlineMoviePurchaseDto({
    required this.orderId,
    required this.movieId,
    required this.price,
    required this.currency,
  });

  factory OnlineMoviePurchaseDto.fromJson(Map<String, dynamic> json) =>
      _$OnlineMoviePurchaseDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class OnlineMovieWatchDto {
  @JsonKey(name: 'movie_id')
  final int movieId;

  @JsonKey(name: 'video_url')
  final String videoUrl;

  const OnlineMovieWatchDto({
    required this.movieId,
    required this.videoUrl,
  });

  factory OnlineMovieWatchDto.fromJson(Map<String, dynamic> json) =>
      _$OnlineMovieWatchDtoFromJson(json);
}

@JsonSerializable(createToJson: false)
class MyOnlineMovieDto {
  @JsonKey(name: 'movie_id')
  final int movieId;

  final String title;

  @JsonKey(name: 'poster_url')
  final String posterUrl;

  @JsonKey(name: 'purchased_at')
  final String purchasedAt;

  final double price;
  final String currency;

  const MyOnlineMovieDto({
    required this.movieId,
    required this.title,
    required this.posterUrl,
    required this.purchasedAt,
    required this.price,
    required this.currency,
  });

  factory MyOnlineMovieDto.fromJson(Map<String, dynamic> json) =>
      _$MyOnlineMovieDtoFromJson(json);
}

