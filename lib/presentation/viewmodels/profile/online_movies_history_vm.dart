import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/domain/entities/online_movies/online_movie.dart';
import 'package:kinolive_mobile/domain/repositories/online_movies_repository.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';
import 'package:kinolive_mobile/shared/providers/online_movies_providers.dart';

final onlineMoviesHistoryVmProvider =
    NotifierProvider<OnlineMoviesHistoryVm, OnlineMoviesHistoryState>(
  () => OnlineMoviesHistoryVm(),
);

enum OnlineMoviesHistoryStatus { idle, loading, loaded, error }

class OnlineMoviesHistoryState {
  final OnlineMoviesHistoryStatus status;
  final List<MyOnlineMovie> movies;
  final String? error;

  const OnlineMoviesHistoryState({
    this.status = OnlineMoviesHistoryStatus.idle,
    this.movies = const [],
    this.error,
  });

  bool get isLoading => status == OnlineMoviesHistoryStatus.loading;
  bool get hasError => status == OnlineMoviesHistoryStatus.error;
  bool get isLoaded => status == OnlineMoviesHistoryStatus.loaded;

  OnlineMoviesHistoryState copyWith({
    OnlineMoviesHistoryStatus? status,
    List<MyOnlineMovie>? movies,
    String? error,
  }) {
    return OnlineMoviesHistoryState(
      status: status ?? this.status,
      movies: movies ?? this.movies,
      error: error,
    );
  }
}

class OnlineMoviesHistoryVm extends Notifier<OnlineMoviesHistoryState> {
  late final OnlineMoviesRepository _repository;

  @override
  OnlineMoviesHistoryState build() {
    _repository = ref.read(onlineMoviesRepositoryProvider);
    return const OnlineMoviesHistoryState();
  }

  Future<void> load() async {
    state = state.copyWith(
      status: OnlineMoviesHistoryStatus.loading,
      error: null,
    );

    try {
      final movies = await _repository.getMyOnlineMovies();
      state = state.copyWith(
        status: OnlineMoviesHistoryStatus.loaded,
        movies: movies,
        error: null,
      );
    } on AppException catch (e) {
      state = state.copyWith(
        status: OnlineMoviesHistoryStatus.error,
        error: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        status: OnlineMoviesHistoryStatus.error,
        error: e.toString(),
      );
    }
  }

  void clearError() => state = state.copyWith(error: null);
}

