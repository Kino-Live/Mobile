import 'package:kinolive_mobile/domain/entities/online_movies/online_movie.dart';

import 'package:kinolive_mobile/domain/entities/online_movies/online_movie.dart';

abstract class OnlineMoviesRepository {
  Future<OnlineMovie?> getMovieInfo(int movieId);
  Future<OnlineMoviePurchase> purchaseMovie(int movieId);
  Future<void> confirmPurchase(int movieId, String orderId, double price, String currency);
  Future<OnlineMovieWatch> getVideoUrl(int movieId);
  Future<List<MyOnlineMovie>> getMyOnlineMovies();
}

