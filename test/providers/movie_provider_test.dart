import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_list_app/models/movie.dart';
import 'package:movie_list_app/providers/movie_provider.dart';
import 'package:movie_list_app/services/movie_service.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../test_helpers/fake_path_provider_platform.dart';

void main() {
  group('MovieProvider Tests', () {
    late ProviderContainer container;
    late MovieNotifier movieNotifier;

    setUpAll(() async {
      PathProviderPlatform.instance = FakePathProviderPlatform();
      await Hive.initFlutter();
      Hive.registerAdapter(MovieAdapter());
    });

    setUp(() async {
      container = ProviderContainer();
      movieNotifier = container.read(movieProvider.notifier);
      await movieNotifier.init();
    });

    tearDown(() async {
      container.dispose();
      await Hive.deleteFromDisk();
    });

    test('should initialize with empty movie list', () {
      final state = container.read(movieProvider);
      expect(state.movies, isEmpty);
      expect(state.isLoading, false);
      expect(state.error, isNull);
    });

    test('should add a movie successfully', () async {
      await movieNotifier.addMovie('Test Movie', 'Test Description');

      final state = container.read(movieProvider);
      expect(state.movies.length, 1);
      expect(state.movies.first.title, 'Test Movie');
      expect(state.movies.first.description, 'Test Description');
      expect(state.movies.first.isFavorite, false);
      expect(state.error, isNull);
    });

    test('should throw error for empty title', () async {
      expect(
        () => movieNotifier.addMovie('', 'Test Description'),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should throw error for empty description', () async {
      expect(
        () => movieNotifier.addMovie('Test Movie', ''),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should trim whitespace from title and description', () async {
      await movieNotifier.addMovie('  Test Movie  ', '  Test Description  ');

      final state = container.read(movieProvider);
      expect(state.movies.first.title, 'Test Movie');
      expect(state.movies.first.description, 'Test Description');
    });

    test('should toggle favorite status', () async {
      await movieNotifier.addMovie('Test Movie', 'Test Description');
      final movieId = container.read(movieProvider).movies.first.id;

      expect(container.read(movieProvider).movies.first.isFavorite, false);

      await movieNotifier.toggleFavorite(movieId);
      expect(container.read(movieProvider).movies.first.isFavorite, true);

      await movieNotifier.toggleFavorite(movieId);
      expect(container.read(movieProvider).movies.first.isFavorite, false);
    });

    test('should delete a movie', () async {
      await movieNotifier.addMovie('Test Movie', 'Test Description');
      expect(container.read(movieProvider).movies.length, 1);

      final movieId = container.read(movieProvider).movies.first.id;
      await movieNotifier.deleteMovie(movieId);

      expect(container.read(movieProvider).movies, isEmpty);
    });

    test('should handle multiple movies', () async {
      await movieNotifier.addMovie('Movie 1', 'Description 1');
      await movieNotifier.addMovie('Movie 2', 'Description 2');
      await movieNotifier.addMovie('Movie 3', 'Description 3');

      final state = container.read(movieProvider);
      expect(state.movies.length, 3);
      
      final titles = state.movies.map((m) => m.title).toList();
      expect(titles, contains('Movie 1'));
      expect(titles, contains('Movie 2'));
      expect(titles, contains('Movie 3'));
    });

    test('should persist data across provider instances', () async {
      await movieNotifier.addMovie('Persistent Movie', 'Persistent Description');
      expect(container.read(movieProvider).movies.length, 1);

      // Create new container and provider instance
      final newContainer = ProviderContainer();
      final newNotifier = newContainer.read(movieProvider.notifier);
      await newNotifier.init();

      final newState = newContainer.read(movieProvider);
      expect(newState.movies.length, 1);
      expect(newState.movies.first.title, 'Persistent Movie');
      expect(newState.movies.first.description, 'Persistent Description');
      
      newContainer.dispose();
    });

    test('should handle loading state during initialization', () async {
      final newContainer = ProviderContainer();
      final newNotifier = newContainer.read(movieProvider.notifier);
      
      // Check initial state
      expect(newContainer.read(movieProvider).isLoading, false);
      
      // Start initialization (this will set loading to true briefly)
      final initFuture = newNotifier.init();
      
      // Complete initialization
      await initFuture;
      
      // Check final state
      expect(newContainer.read(movieProvider).isLoading, false);
      
      newContainer.dispose();
    });
  });
}