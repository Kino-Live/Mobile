import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/data/repositories/movies_repository_impl.dart';
import 'package:kinolive_mobile/data/sources/remote/movie_api_service.dart';
import 'package:kinolive_mobile/domain/entities/movie.dart';
import 'package:kinolive_mobile/domain/repositories/movies_repository.dart';
import 'package:kinolive_mobile/domain/usecases/billboard/get_now_showing_movies.dart';
import 'package:kinolive_mobile/domain/usecases/movie_details/get_movie_details.dart';
import 'package:kinolive_mobile/shared/providers/network/dio_provider.dart';

final moviesApiServiceProvider = Provider<MoviesApiService>((ref) {
  return MoviesApiService(ref.read(dioProvider));
});

final moviesRepositoryProvider = Provider<MoviesRepository>((ref) {
  return MoviesRepositoryImpl(ref.read(moviesApiServiceProvider));
});

final getNowShowingMoviesProvider = Provider<GetNowShowingMovies>((ref) {
  return GetNowShowingMovies(ref.read(moviesRepositoryProvider));
});

final getMovieDetailsProvider = Provider<GetMovieDetails>((ref) {
  return GetMovieDetails(ref.read(moviesRepositoryProvider));
});

final movieDetailsFutureProvider =
FutureProvider.family<Movie, int>((ref, id) {
  final usecase = ref.read(getMovieDetailsProvider);
  return usecase(id);
});
