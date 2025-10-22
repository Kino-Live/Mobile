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
        originalTitle: dto.originalTitle,
        posterUrl: dto.posterUrl,
        year: dto.year,
        ageRestrictions: dto.ageRestrictions,
        genres: dto.genres,
        language: dto.language,
        duration: dto.duration,
        producer: dto.producer,
        director: dto.director,
        cast: dto.cast,
        description: dto.description,
        trailerUrl: dto.trailerUrl,
        rating: dto.rating,
      );
    }).toList();

    return movies;
  }

  @override
  Future<Movie> getById(int id) async {
    final dto = await _api.getById(id);
    return Movie(
      id: dto.id,
      title: dto.title,
      originalTitle: dto.originalTitle,
      posterUrl: dto.posterUrl,
      year: dto.year,
      ageRestrictions: dto.ageRestrictions,
      genres: dto.genres,
      language: dto.language,
      duration: dto.duration,
      producer: dto.producer,
      director: dto.director,
      cast: dto.cast,
      description: dto.description,
      trailerUrl: dto.trailerUrl,
      rating: dto.rating,
    );
  }
}
