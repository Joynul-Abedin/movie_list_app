import 'package:hive/hive.dart';
import '../models/movie.dart';

class MovieService {
  static const String _boxName = 'movies';
  Box<Movie>? _box;

  Future<void> init() async {
    _box = await Hive.openBox<Movie>(_boxName);
  }

  List<Movie> getAllMovies() {
    return _box?.values.toList() ?? [];
  }

  Future<void> addMovie(Movie movie) async {
    await _box?.put(movie.id, movie);
  }

  Future<void> updateMovie(Movie movie) async {
    await _box?.put(movie.id, movie);
  }

  Future<void> deleteMovie(String id) async {
    await _box?.delete(id);
  }

  Future<void> toggleFavorite(String id) async {
    final movie = _box?.get(id);
    if (movie != null) {
      final updatedMovie = movie.copyWith(isFavorite: !movie.isFavorite);
      await _box?.put(id, updatedMovie);
    }
  }

  void dispose() {
    _box?.close();
  }
}