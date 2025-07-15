import 'package:flutter_test/flutter_test.dart';
import 'package:movie_list_app/models/movie.dart';

void main() {
  group('Movie Model Tests', () {
    test('should create a movie with required fields', () {
      const movie = Movie(
        id: '1',
        title: 'Test Movie',
        description: 'Test Description',
      );

      expect(movie.id, '1');
      expect(movie.title, 'Test Movie');
      expect(movie.description, 'Test Description');
      expect(movie.isFavorite, false);
    });

    test('should create a movie with favorite flag', () {
      const movie = Movie(
        id: '1',
        title: 'Test Movie',
        description: 'Test Description',
        isFavorite: true,
      );

      expect(movie.isFavorite, true);
    });

    test('should create a copy with updated values', () {
      const originalMovie = Movie(
        id: '1',
        title: 'Original Title',
        description: 'Original Description',
      );

      final updatedMovie = originalMovie.copyWith(
        title: 'Updated Title',
        isFavorite: true,
      );

      expect(updatedMovie.id, '1');
      expect(updatedMovie.title, 'Updated Title');
      expect(updatedMovie.description, 'Original Description');
      expect(updatedMovie.isFavorite, true);
    });

    test('should maintain equality for identical movies', () {
      const movie1 = Movie(
        id: '1',
        title: 'Test Movie',
        description: 'Test Description',
      );

      const movie2 = Movie(
        id: '1',
        title: 'Test Movie',
        description: 'Test Description',
      );

      expect(movie1, equals(movie2));
      expect(movie1.hashCode, equals(movie2.hashCode));
    });

    test('should not be equal for different movies', () {
      const movie1 = Movie(
        id: '1',
        title: 'Test Movie',
        description: 'Test Description',
      );

      const movie2 = Movie(
        id: '2',
        title: 'Test Movie',
        description: 'Test Description',
      );

      expect(movie1, isNot(equals(movie2)));
    });

    test('should have proper toString representation', () {
      const movie = Movie(
        id: '1',
        title: 'Test Movie',
        description: 'Test Description',
        isFavorite: true,
      );

      final stringRepresentation = movie.toString();
      expect(stringRepresentation, contains('Movie('));
      expect(stringRepresentation, contains('id: 1'));
      expect(stringRepresentation, contains('title: Test Movie'));
      expect(stringRepresentation, contains('description: Test Description'));
      expect(stringRepresentation, contains('isFavorite: true'));
    });
  });
}