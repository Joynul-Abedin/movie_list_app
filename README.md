# Movie List App

A Flutter application that allows users to manage their movie collection with features like adding movies, marking favorites, and persistent local storage.

## Features

- **View Movies**: Display a list of movies with title and description
- **Add Movies**: Add new movies with form validation
- **Favorite System**: Mark/unmark movies as favorites using heart icons
- **Delete Movies**: Remove movies from the list with confirmation dialog
- **Data Persistence**: Local storage using Hive database
- **State Management**: Riverpod for reactive and scalable state management
- **Comprehensive Testing**: Unit, widget, and integration tests

## Architecture

### State Management
- **Riverpod**: Modern state management solution with compile-time safety
- **StateNotifier**: Manages movie state with immutable state objects
- **Provider Scope**: Dependency injection and state isolation
- **Consumer Widgets**: Reactive UI updates with automatic rebuilds

### Data Persistence
- **Hive**: NoSQL database for local data storage
- **Type Adapters**: Custom serialization for Movie objects
- **Automatic Persistence**: Data survives app restarts

### Project Structure
```
lib/
├── main.dart                 # App entry point with ProviderScope
├── models/
│   └── movie.dart           # Movie data model with Hive annotations
├── providers/
│   └── movie_provider.dart  # Riverpod providers and state notifiers
├── screens/
│   ├── movie_list_screen.dart    # Main screen with ConsumerStatefulWidget
│   └── add_movie_screen.dart     # Form screen with ConsumerStatefulWidget
├── services/
│   └── movie_service.dart   # Data access layer for Hive operations
└── widgets/
    └── movie_card.dart      # Reusable movie display with ConsumerWidget

test/
├── models/
├── providers/               # Riverpod provider tests with ProviderContainer
├── screens/                 # Widget tests with ProviderScope
├── widgets/                 # Component tests with ProviderScope
└── test_helpers/

integration_test/
└── app_test.dart           # End-to-end testing
```

## Getting Started

### Prerequisites
- Flutter SDK (3.8.1 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd movie_list_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

## Usage

### Adding a Movie
1. Tap the floating action button (+) on the main screen
2. Fill in the movie title and description
3. Tap "Add Movie" to save

### Form Validation Rules
- **Title**: 2-100 characters, required
- **Description**: 10-500 characters, required
- Whitespace is automatically trimmed

### Managing Movies
- **Favorite**: Tap the heart icon to toggle favorite status
- **Delete**: Tap the delete icon and confirm in the dialog
- **View**: All movies are displayed in a scrollable list

## Testing

The application includes comprehensive testing coverage:

### Running Tests

**Unit Tests**
```bash
flutter test test/models/
flutter test test/providers/
```

**Widget Tests**
```bash
flutter test test/widgets/
flutter test test/screens/
```

**Integration Tests**
```bash
flutter test integration_test/
```

**All Tests**
```bash
flutter test
```

### Test Coverage

- **Unit Tests**: Model validation, business logic, data persistence
- **Widget Tests**: UI components, form validation, user interactions
- **Integration Tests**: Complete user flows, data persistence across sessions

## Dependencies

### Production Dependencies
- `flutter`: Flutter SDK
- `flutter_riverpod`: Modern state management solution
- `hive`: Local database
- `hive_flutter`: Flutter integration for Hive
- `path_provider`: File system paths

### Development Dependencies
- `flutter_test`: Testing framework
- `hive_generator`: Code generation for Hive
- `build_runner`: Build system
- `integration_test`: End-to-end testing
- `flutter_lints`: Linting rules

## Code Quality

### Linting
The project uses Flutter's recommended linting rules defined in `analysis_options.yaml`.

### Best Practices
- **Separation of Concerns**: Clear separation between UI, business logic, and data layers
- **Error Handling**: Comprehensive error handling with user feedback
- **Input Validation**: Client-side validation with clear error messages
- **Responsive Design**: Adaptive UI components
- **Code Documentation**: Inline comments and comprehensive README

## Performance Considerations

- **Efficient State Management**: Riverpod's fine-grained reactivity minimizes unnecessary rebuilds
- **Local Storage**: Hive provides fast, lightweight data persistence
- **Memory Management**: Automatic provider disposal and state cleanup
- **Lazy Loading**: Efficient list rendering with ListView.builder
- **Compile-time Safety**: Riverpod catches state management errors at compile time

## Troubleshooting

### Common Issues

**Build Runner Issues**
```bash
flutter packages pub run build_runner clean
flutter packages pub run build_runner build --delete-conflicting-outputs
```

**Hive Database Issues**
```bash
# Clear app data or use:
await Hive.deleteFromDisk();
```

**Test Issues**
```bash
flutter clean
flutter pub get
flutter test
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

## License

This project is created for educational purposes as part of a Flutter assessment.
