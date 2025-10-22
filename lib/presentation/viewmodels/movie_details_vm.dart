import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/domain/entities/movie.dart';
import 'package:kinolive_mobile/domain/usecases/movie_details/get_movie_details.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';
import 'package:kinolive_mobile/shared/providers/movies_provider.dart';

final movieDetailsVmProvider =
NotifierProvider.family<MovieDetailsVm, MovieDetailsState, int>((id) => MovieDetailsVm());

enum MovieDetailsStatus { idle, loading, loaded, error }

class MovieDetailsState {
  final MovieDetailsStatus status;
  final Movie? movie;
  final String? error;

  const MovieDetailsState({
    this.status = MovieDetailsStatus.idle,
    this.movie,
    this.error,
  });

  bool get isLoading => status == MovieDetailsStatus.loading;
  bool get hasError  => status == MovieDetailsStatus.error;
  bool get isLoaded  => status == MovieDetailsStatus.loaded;

  MovieDetailsState copyWith({
    MovieDetailsStatus? status,
    Movie? movie,
    String? error,
  }) {
    return MovieDetailsState(
      status: status ?? this.status,
      movie: movie ?? this.movie,
      error: error,
    );
  }
}

class MovieDetailsVm extends Notifier<MovieDetailsState> {
  late final GetMovieDetails _getMovieDetails;
  int? _currentId;

  @override
  MovieDetailsState build() {
    _getMovieDetails = ref.read(getMovieDetailsProvider);
    return const MovieDetailsState();
  }

  Future<void> init(int id) async {
    if (_currentId == id && state.isLoaded) return;
    
    _currentId = id;
    state = state.copyWith(status: MovieDetailsStatus.loading, error: null);

    try {
      final details = await _getMovieDetails(id);
      state = state.copyWith(
        status: MovieDetailsStatus.loaded,
        movie: details,
        error: null,
      );
    } on AppException catch (e) {
      state = state.copyWith(status: MovieDetailsStatus.error, error: e.message);
    } catch (e) {
      state = state.copyWith(status: MovieDetailsStatus.error, error: e.toString());
    }
  }

  void clearError() => state = state.copyWith(error: null);
}