import 'package:kinolive_mobile/domain/entities/movie.dart';

abstract class MoviesRepository {
  Future<List<Movie>> getNowShowing();
  Future<Movie> getById(int id);
}