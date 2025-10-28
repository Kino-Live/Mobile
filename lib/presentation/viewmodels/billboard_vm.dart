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
  final Set<String> selectedGenres;
  final double minRating;

  const BillboardState({
    this.status = BillboardStatus.idle,
    this.movies = const [],
    this.error,
    this.query = '',
    this.selectedGenres = const {},
    this.minRating = 0,
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

    if (selectedGenres.isNotEmpty) {
      res = res.where((m) => m.genres.any(selectedGenres.contains));
    }

    if (minRating > 0) {
      res = res.where((m) => (m.rating) >= minRating);
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
      selectedGenres: selectedGenres ?? this.selectedGenres,
      minRating: minRating ?? this.minRating,
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

  void toggleGenre(String genre) {
    final set = {...state.selectedGenres};
    if (set.contains(genre)) {
      set.remove(genre);
    } else {
      set.add(genre);
    }
    state = state.copyWith(selectedGenres: set);
  }

  void setMinRating(double value) =>
      state = state.copyWith(minRating: value.clamp(0, 10));

  void clearFilters() =>
      state = state.copyWith(selectedGenres: {}, minRating: 0);
}
