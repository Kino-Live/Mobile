import 'package:kinolive_mobile/data/sources/remote/movie_api_service.dart';
import 'package:kinolive_mobile/domain/entities/movie.dart';
import 'package:kinolive_mobile/domain/repositories/movies_repository.dart';

class MoviesRepositoryImpl implements MoviesRepository {
  final MoviesApiService apiService;

  MoviesRepositoryImpl(this.apiService);

  @override
  Future<List<Movie>> getNowShowing() async {
    final movieDtos = await apiService.getNowShowing();

    final movies = movieDtos.map((movieDto) {
      return Movie(
        id: movieDto.id,
        title: movieDto.title,
        originalTitle: movieDto.originalTitle,
        posterUrl: movieDto.posterUrl,
        year: movieDto.year,
        ageRestrictions: movieDto.ageRestrictions,
        genres: movieDto.genres,
        language: movieDto.language,
        duration: movieDto.duration,
        producer: movieDto.producer,
        director: movieDto.director,
        cast: movieDto.cast,
        description: movieDto.description,
        trailerUrl: movieDto.trailerUrl,
        rating: movieDto.rating,
      );
    }).toList();

    return movies;
  }

  @override
  Future<Movie> getById(int movieId) async {
    final movieDto = await apiService.getById(movieId);

    return Movie(
      id: movieDto.id,
      title: movieDto.title,
      originalTitle: movieDto.originalTitle,
      posterUrl: movieDto.posterUrl,
      year: movieDto.year,
      ageRestrictions: movieDto.ageRestrictions,
      genres: movieDto.genres,
      language: movieDto.language,
      duration: movieDto.duration,
      producer: movieDto.producer,
      director: movieDto.director,
      cast: movieDto.cast,
      description: movieDto.description,
      trailerUrl: movieDto.trailerUrl,
      rating: movieDto.rating,
    );
  }
}
