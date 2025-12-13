import 'package:kinolive_mobile/data/sources/remote/online_movies_api_service.dart';
import 'package:kinolive_mobile/domain/entities/online_movies/online_movie.dart';
import 'package:kinolive_mobile/domain/repositories/online_movies_repository.dart';

class OnlineMoviesRepositoryImpl implements OnlineMoviesRepository {
  final OnlineMoviesApiService apiService;

  OnlineMoviesRepositoryImpl(this.apiService);

  @override
  Future<OnlineMovie?> getMovieInfo(int movieId) async {
    try {
      final dto = await apiService.getMovieInfo(movieId);
      return OnlineMovie(
        movieId: dto.movieId,
        price: dto.price,
        currency: dto.currency,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<OnlineMoviePurchase> purchaseMovie(int movieId) async {
    final dto = await apiService.purchaseMovie(movieId);
    return OnlineMoviePurchase(
      orderId: dto.orderId,
      movieId: dto.movieId,
      price: dto.price,
      currency: dto.currency,
    );
  }

  @override
  Future<void> confirmPurchase(int movieId, String orderId, double price, String currency) async {
    await apiService.confirmPurchase(movieId, orderId, price, currency);
  }

  @override
  Future<OnlineMovieWatch> getVideoUrl(int movieId) async {
    final dto = await apiService.getVideoUrl(movieId);
    return OnlineMovieWatch(
      movieId: dto.movieId,
      videoUrl: dto.videoUrl,
    );
  }

  @override
  Future<List<MyOnlineMovie>> getMyOnlineMovies() async {
    final dtos = await apiService.getMyOnlineMovies();
    return dtos.map((dto) {
      return MyOnlineMovie(
        movieId: dto.movieId,
        title: dto.title,
        posterUrl: dto.posterUrl,
        purchasedAt: DateTime.parse(dto.purchasedAt),
        price: dto.price,
        currency: dto.currency,
      );
    }).toList();
  }
}

