import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';

// Movie service provider
final movieServiceProvider = Provider<MovieService>((ref) {
  return MovieService();
});

// Movie state class
class MovieState {
  final List<Movie> movies;
  final bool isLoading;
  final String? error;

  const MovieState({
    this.movies = const [],
    this.isLoading = false,
    this.error,
  });

  MovieState copyWith({
    List<Movie>? movies,
    bool? isLoading,
    String? error,
  }) {
    return MovieState(
      movies: movies ?? this.movies,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Movie notifier
class MovieNotifier extends StateNotifier<MovieState> {
  final MovieService _movieService;

  MovieNotifier(this._movieService) : super(const MovieState());

  Future<void> init() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _movieService.init();
      final movies = _movieService.getAllMovies();
      state = state.copyWith(movies: movies, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addMovie(String title, String description) async {
    if (title.trim().isEmpty || description.trim().isEmpty) {
      throw ArgumentError('Title and description cannot be empty');
    }

    try {
      final movie = Movie(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title.trim(),
        description: description.trim(),
      );

      await _movieService.addMovie(movie);
      final movies = _movieService.getAllMovies();
      state = state.copyWith(movies: movies, error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  Future<void> toggleFavorite(String id) async {
    try {
      await _movieService.toggleFavorite(id);
      final movies = _movieService.getAllMovies();
      state = state.copyWith(movies: movies, error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteMovie(String id) async {
    try {
      await _movieService.deleteMovie(id);
      final movies = _movieService.getAllMovies();
      state = state.copyWith(movies: movies, error: null);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }
}

// Movie provider
final movieProvider = StateNotifierProvider<MovieNotifier, MovieState>((ref) {
  final movieService = ref.watch(movieServiceProvider);
  return MovieNotifier(movieService);
});