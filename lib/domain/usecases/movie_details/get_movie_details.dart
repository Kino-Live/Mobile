import 'package:kinolive_mobile/domain/entities/movie.dart';
import 'package:kinolive_mobile/domain/repositories/movies_repository.dart';

class GetMovieDetails {
  final MoviesRepository _repo;
  const GetMovieDetails(this._repo);

  Future<Movie> call(int id) {
    return _repo.getById(id);
  }
}
