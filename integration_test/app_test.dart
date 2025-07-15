import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:movie_list_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Movie List App Integration Tests', () {
    testWidgets('complete user flow - add, favorite, and delete movie', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify initial empty state
      expect(find.text('Movie List'), findsOneWidget);
      expect(find.text('No movies yet'), findsOneWidget);
      expect(find.text('Add your first movie using the + button'), findsOneWidget);

      // Navigate to add movie screen
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify add movie screen
      expect(find.text('Add Movie'), findsOneWidget);
      expect(find.text('Movie Title'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);

      // Try to submit empty form (should show validation errors)
      await tester.tap(find.text('Add Movie').last);
      await tester.pumpAndSettle();

      expect(find.text('Title is required'), findsOneWidget);
      expect(find.text('Description is required'), findsOneWidget);

      // Fill in the form with valid data
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Movie Title'),
        'The Matrix',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Description'),
        'A computer programmer discovers reality is a simulation and joins a rebellion.',
      );

      // Submit the form
      await tester.tap(find.text('Add Movie').last);
      await tester.pumpAndSettle();

      // Verify we're back on the main screen with the new movie
      expect(find.text('Movie List'), findsOneWidget);
      expect(find.text('The Matrix'), findsOneWidget);
      expect(find.text('A computer programmer discovers reality is a simulation and joins a rebellion.'), findsOneWidget);
      expect(find.text('Movie added successfully!'), findsOneWidget);

      // Verify the movie is not favorited initially
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);

      // Toggle favorite
      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pumpAndSettle();

      // Verify movie is now favorited
      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);

      // Toggle favorite again
      await tester.tap(find.byIcon(Icons.favorite));
      await tester.pumpAndSettle();

      // Verify movie is no longer favorited
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsNothing);

      // Add another movie
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Movie Title'),
        'Inception',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Description'),
        'A thief who steals corporate secrets through dream-sharing technology.',
      );

      await tester.tap(find.text('Add Movie').last);
      await tester.pumpAndSettle();

      // Verify both movies are displayed
      expect(find.text('The Matrix'), findsOneWidget);
      expect(find.text('Inception'), findsOneWidget);

      // Delete the first movie
      final deleteButtons = find.byIcon(Icons.delete_outline);
      expect(deleteButtons, findsNWidgets(2));

      await tester.tap(deleteButtons.first);
      await tester.pumpAndSettle();

      // Verify delete confirmation dialog
      expect(find.text('Delete Movie'), findsOneWidget);
      expect(find.text('Are you sure you want to delete "The Matrix"?'), findsOneWidget);

      // Cancel deletion
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Verify movie is still there
      expect(find.text('The Matrix'), findsOneWidget);

      // Delete the movie for real
      await tester.tap(deleteButtons.first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Verify movie is deleted and success message is shown
      expect(find.text('The Matrix'), findsNothing);
      expect(find.text('Inception'), findsOneWidget);
      expect(find.text('Movie deleted successfully!'), findsOneWidget);

      // Delete the remaining movie
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Verify we're back to empty state
      expect(find.text('No movies yet'), findsOneWidget);
      expect(find.text('Add your first movie using the + button'), findsOneWidget);
    });

    testWidgets('data persistence test', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Add a movie
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Movie Title'),
        'Persistent Movie',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Description'),
        'This movie should persist across app restarts.',
      );

      await tester.tap(find.text('Add Movie').last);
      await tester.pumpAndSettle();

      // Mark as favorite
      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pumpAndSettle();

      // Verify movie is added and favorited
      expect(find.text('Persistent Movie'), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);

      // Restart the app
      await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
        'flutter/platform',
        null,
        (data) {},
      );

      app.main();
      await tester.pumpAndSettle();

      // Verify data persisted
      expect(find.text('Persistent Movie'), findsOneWidget);
      expect(find.text('This movie should persist across app restarts.'), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);

      // Clean up
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
    });

    testWidgets('form validation edge cases', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Test minimum length validation
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Movie Title'),
        'A', // Too short
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Description'),
        'Short', // Too short
      );

      await tester.tap(find.text('Add Movie').last);
      await tester.pumpAndSettle();

      expect(find.text('Title must be at least 2 characters long'), findsOneWidget);
      expect(find.text('Description must be at least 10 characters long'), findsOneWidget);

      // Test maximum length validation
      final longTitle = 'A' * 101; // Too long
      final longDescription = 'A' * 501; // Too long

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Movie Title'),
        longTitle,
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Description'),
        longDescription,
      );

      await tester.tap(find.text('Add Movie').last);
      await tester.pumpAndSettle();

      expect(find.text('Title must be less than 100 characters'), findsOneWidget);
      expect(find.text('Description must be less than 500 characters'), findsOneWidget);

      // Test whitespace trimming
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Movie Title'),
        '  Valid Title  ',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Description'),
        '  This is a valid description with whitespace  ',
      );

      await tester.tap(find.text('Add Movie').last);
      await tester.pumpAndSettle();

      // Should succeed and trim whitespace
      expect(find.text('Valid Title'), findsOneWidget);
      expect(find.text('This is a valid description with whitespace'), findsOneWidget);
    });
  });
}