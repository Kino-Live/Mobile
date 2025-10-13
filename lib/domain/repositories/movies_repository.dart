import 'package:kinolive_mobile/domain/entities/movie.dart';
import 'package:kinolive_mobile/domain/entities/movie_details.dart';

abstract class MoviesRepository {
  Future<List<Movie>> getNowShowing();
  Future<MovieDetails> getById(int id);
}