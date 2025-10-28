import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kinolive_mobile/domain/entities/movie.dart';
import 'package:kinolive_mobile/domain/usecases/billboard/get_now_showing_movies.dart';
import 'package:kinolive_mobile/shared/errors/app_exception.dart';
import 'package:kinolive_mobile/shared/providers/movies_provider.dart';

final billboardVmProvider =
NotifierProvider<BillboardVm, BillboardState>(BillboardVm.new);

enum BillboardStatus { idle, loading, loaded, error }

class BillboardState {
  final BillboardStatus status;
  final List<Movie> movies;
  final String? error;

  final String query;

  const BillboardState({
    this.status = BillboardStatus.idle,
    this.movies = const [],
    this.error,
    this.query = '',
  });

  bool get isLoading => status == BillboardStatus.loading;
  bool get hasError => status == BillboardStatus.error;
  bool get isEmpty => movies.isEmpty;

  List<Movie> get filteredMovies {
    Iterable<Movie> res = movies;

    final q = query.trim().toLowerCase();
    if (q.isNotEmpty) {
      res = res.where((m) {
        final inTitle = m.title.toLowerCase().contains(q);
        final inGenres = m.genres.any((g) => g.toLowerCase().contains(q));
        return inTitle || inGenres;
      });
    }

    return res.toList();
  }

  BillboardState copyWith({
    BillboardStatus? status,
    List<Movie>? movies,
    String? error,

    String? query,
    Set<String>? selectedGenres,
    double? minRating,
  }) {
    return BillboardState(
      status: status ?? this.status,
      movies: movies ?? this.movies,
      error: error,

      query: query ?? this.query,
    );
  }
}

class BillboardVm extends Notifier<BillboardState> {
  late final GetNowShowingMovies _getNowShowing;

  @override
  BillboardState build() {
    _getNowShowing = ref.read(getNowShowingMoviesProvider);
    return const BillboardState();
  }

  Future<void> load() async {
    if (state.isLoading) return;
    state = state.copyWith(status: BillboardStatus.loading, error: null);

    try {
      final movies = await _getNowShowing();
      state = state.copyWith(
        status: BillboardStatus.loaded,
        movies: movies,
        error: null,
      );
    } on AppException catch (e) {
      state = state.copyWith(status: BillboardStatus.error, error: e.message);
    } catch (e) {
      state = state.copyWith(status: BillboardStatus.error, error: e.toString());
    }
  }

  void clearError() => state = state.copyWith(error: null);

  void setQuery(String v) => state = state.copyWith(query: v);

  void clearQuery() => state = state.copyWith(query: '');

}
