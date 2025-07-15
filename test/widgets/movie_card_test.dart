import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_list_app/models/movie.dart';
import 'package:movie_list_app/providers/movie_provider.dart';
import 'package:movie_list_app/widgets/movie_card.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../test_helpers/fake_path_provider_platform.dart';

void main() {
  group('MovieCard Widget Tests', () {
    late ProviderContainer container;
    const testMovie = Movie(
      id: '1',
      title: 'Test Movie',
      description: 'Test Description',
      isFavorite: false,
    );

    setUpAll(() async {
      PathProviderPlatform.instance = FakePathProviderPlatform();
      await Hive.initFlutter();
      Hive.registerAdapter(MovieAdapter());
    });

    setUp(() async {
      container = ProviderContainer();
      await container.read(movieProvider.notifier).init();
    });

    tearDown(() async {
      container.dispose();
      await Hive.deleteFromDisk();
    });

    Widget createTestWidget(Movie movie) {
      return ProviderScope(
        parent: container,
        child: MaterialApp(
          home: Scaffold(
            body: MovieCard(movie: movie),
          ),
        ),
      );
    }

    testWidgets('should display movie title and description', (tester) async {
      await tester.pumpWidget(createTestWidget(testMovie));

      expect(find.text('Test Movie'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
    });

    testWidgets('should display unfavorite heart icon for non-favorite movie', (tester) async {
      await tester.pumpWidget(createTestWidget(testMovie));

      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);
    });

    testWidgets('should display favorite heart icon for favorite movie', (tester) async {
      const favoriteMovie = Movie(
        id: '1',
        title: 'Test Movie',
        description: 'Test Description',
        isFavorite: true,
      );

      await tester.pumpWidget(createTestWidget(favoriteMovie));

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);
    });

    testWidgets('should display delete icon', (tester) async {
      await tester.pumpWidget(createTestWidget(testMovie));

      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('should show delete confirmation dialog when delete button is tapped', (tester) async {
      await tester.pumpWidget(createTestWidget(testMovie));

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      expect(find.text('Delete Movie'), findsOneWidget);
      expect(find.text('Are you sure you want to delete "Test Movie"?'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('should cancel delete when cancel button is tapped', (tester) async {
      await tester.pumpWidget(createTestWidget(testMovie));

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Delete Movie'), findsNothing);
    });

    testWidgets('should have proper tooltips', (tester) async {
      await tester.pumpWidget(createTestWidget(testMovie));

      final favoriteButton = find.byIcon(Icons.favorite_border);
      final deleteButton = find.byIcon(Icons.delete_outline);

      expect(favoriteButton, findsOneWidget);
      expect(deleteButton, findsOneWidget);

      // Check tooltips by long pressing
      await tester.longPress(favoriteButton);
      await tester.pumpAndSettle();
      expect(find.text('Add to favorites'), findsOneWidget);

      // Dismiss tooltip
      await tester.tap(find.byType(Scaffold));
      await tester.pumpAndSettle();

      await tester.longPress(deleteButton);
      await tester.pumpAndSettle();
      expect(find.text('Delete movie'), findsOneWidget);
    });

    testWidgets('should show correct tooltip for favorite movie', (tester) async {
      const favoriteMovie = Movie(
        id: '1',
        title: 'Test Movie',
        description: 'Test Description',
        isFavorite: true,
      );

      await tester.pumpWidget(createTestWidget(favoriteMovie));

      final favoriteButton = find.byIcon(Icons.favorite);
      await tester.longPress(favoriteButton);
      await tester.pumpAndSettle();
      
      expect(find.text('Remove from favorites'), findsOneWidget);
    });
  });
}