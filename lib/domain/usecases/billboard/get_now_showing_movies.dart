import 'package:kinolive_mobile/domain/entities/movie.dart';
import 'package:kinolive_mobile/domain/repositories/movies_repository.dart';

class GetNowShowingMovies {
  final MoviesRepository _repo;
  const GetNowShowingMovies(this._repo);

  Future<List<Movie>> call() {
    return _repo.getNowShowing();
  }
}
