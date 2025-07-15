import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_list_app/models/movie.dart';
import 'package:movie_list_app/providers/movie_provider.dart';
import 'package:movie_list_app/screens/add_movie_screen.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../test_helpers/fake_path_provider_platform.dart';

void main() {
  group('AddMovieScreen Widget Tests', () {
    late ProviderContainer container;

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

    Widget createTestWidget() {
      return ProviderScope(
        parent: container,
        child: const MaterialApp(
          home: AddMovieScreen(),
        ),
      );
    }

    testWidgets('should display form fields and button', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Add Movie'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Movie Title'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('should show validation errors for empty fields', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Title is required'), findsOneWidget);
      expect(find.text('Description is required'), findsOneWidget);
    });

    testWidgets('should show validation error for short title', (tester) async {
      await tester.pumpWidget(createTestWidget());

      await tester.enterText(find.byType(TextFormField).first, 'A');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Title must be at least 2 characters long'), findsOneWidget);
    });

    testWidgets('should show validation error for short description', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.first, 'Valid Title');
      await tester.enterText(textFields.last, 'Short');
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Description must be at least 10 characters long'), findsOneWidget);
    });

    testWidgets('should show validation error for long title', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final longTitle = 'A' * 101; // 101 characters
      await tester.enterText(find.byType(TextFormField).first, longTitle);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Title must be less than 100 characters'), findsOneWidget);
    });

    testWidgets('should show validation error for long description', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final textFields = find.byType(TextFormField);
      final longDescription = 'A' * 501; // 501 characters
      
      await tester.enterText(textFields.first, 'Valid Title');
      await tester.enterText(textFields.last, longDescription);
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Description must be less than 500 characters'), findsOneWidget);
    });

    testWidgets('should successfully add movie with valid input', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.first, 'Test Movie');
      await tester.enterText(textFields.last, 'This is a valid description for testing');
      
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Check if movie was added to provider
      final state = container.read(movieProvider);
      expect(state.movies.length, 1);
      expect(state.movies.first.title, 'Test Movie');
      expect(state.movies.first.description, 'This is a valid description for testing');
    });

    testWidgets('should show loading indicator when saving', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.first, 'Test Movie');
      await tester.enterText(textFields.last, 'This is a valid description for testing');
      
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump(); // Don't settle to catch loading state

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should disable form fields when loading', (tester) async {
      await tester.pumpWidget(createTestWidget());

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.first, 'Test Movie');
      await tester.enterText(textFields.last, 'This is a valid description for testing');
      
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump(); // Don't settle to catch loading state

      // Try to enter text in disabled fields
      await tester.enterText(textFields.first, 'Should not work');
      await tester.pump();

      // The text should not change because field is disabled
      final titleField = tester.widget<TextFormField>(textFields.first);
      expect(titleField.enabled, false);
    });

    testWidgets('should have proper input decorations', (tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.movie), findsOneWidget);
      expect(find.byIcon(Icons.description), findsOneWidget);
      expect(find.text('Enter movie title'), findsOneWidget);
      expect(find.text('Enter movie description'), findsOneWidget);
    });
  });
}