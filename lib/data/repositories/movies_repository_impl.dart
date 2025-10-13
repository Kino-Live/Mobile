import 'package:kinolive_mobile/data/sources/remote/movie_api_service.dart';
import 'package:kinolive_mobile/domain/entities/movie.dart';
import 'package:kinolive_mobile/domain/repositories/movies_repository.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  final MoviesApiService _api;

  MoviesRepositoryImpl(this._api);

  @override
  Future<List<Movie>> getNowShowing() async {
    final dtos = await _api.getNowShowing();
    final movies = dtos.map((dto) {
      return Movie(
        id: dto.id,
        title: dto.title,
        posterUrl: dto.posterUrl,
        rating: dto.rating,
      );
    }).toList();

    return movies;
  }
}
