# Movie List App

A Flutter application that allows users to manage their movie collection with features like adding movies, marking favorites, and persistent local storage.

![Flutter](https://img.shields.io/badge/Flutter-3.8.1+-blue?style=flat-square&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.8.1+-blue?style=flat-square&logo=dart)
![License](https://img.shields.io/badge/License-Educational-green?style=flat-square)

## 📚 Table of Contents

- [Features](#-features)
- [Platform Support](#-platform-support)
- [Quick Start](#-quick-start)
- [Architecture](#-architecture)
- [Project Structure](#-project-structure)
- [Usage Guide](#-usage-guide)
- [Testing](#-testing)
- [Dependencies](#-dependencies)
- [Code Quality](#-code-quality)
- [Performance](#-performance-considerations)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)

## ✨ Features

- **View Movies**: Display a list of movies with title and description
- **Add Movies**: Add new movies with form validation
- **Favorite System**: Mark/unmark movies as favorites using heart icons
- **Delete Movies**: Remove movies from the list with confirmation dialog
- **Data Persistence**: Local storage using Hive database
- **State Management**: Riverpod for reactive and scalable state management
- **Comprehensive Testing**: Unit, widget, and integration tests
- **Material Design 3**: Modern UI with Material 3 components
- **Cross-Platform**: Runs on Android, iOS, Web, macOS, Linux, and Windows

## 🎯 Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| Android  | ✅ Supported | API level 19+ |
| iOS      | ✅ Supported | iOS 12+ |
| Web      | ✅ Supported | Modern browsers |
| macOS    | ✅ Supported | macOS 10.14+ |
| Linux    | ✅ Supported | Ubuntu 18.04+ |
| Windows  | ✅ Supported | Windows 10+ |

## 🚀 Quick Start

### One-Line Setup (if you have Flutter installed)
```bash
git clone https://github.com/Joynul-Abedin/movie_list_app.git && cd movie_list_app && flutter pub get && flutter packages pub run build_runner build && flutter run
```

### Prerequisites
- **Flutter SDK**: 3.8.1 or higher ([Install Flutter](https://docs.flutter.dev/get-started/install))
- **Dart SDK**: 3.8.1+ (included with Flutter)
- **IDE**: Android Studio, VS Code, or IntelliJ with Flutter extensions
- **Device/Emulator**: Physical device or emulator for testing

### Step-by-Step Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Joynul-Abedin/movie_list_app.git
   cd movie_list_app
   ```

2. **Verify Flutter installation**
   ```bash
   flutter doctor
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Generate required files**
   ```bash
   flutter packages pub run build_runner build
   ```

5. **Run the application**
   ```bash
   # Run on default device
   flutter run
   
   # Run on specific platform
   flutter run -d chrome          # Web
   flutter run -d macos           # macOS
   flutter run -d windows         # Windows
   flutter run -d linux           # Linux
   ```

6. **Optional: Run tests to verify setup**
   ```bash
   flutter test
   ```

## 🏗 Architecture

### State Management
- **Riverpod**: Modern state management solution with compile-time safety
- **StateNotifier**: Manages movie state with immutable state objects
- **Provider Scope**: Dependency injection and state isolation
- **Consumer Widgets**: Reactive UI updates with automatic rebuilds

### Data Persistence
- **Hive**: NoSQL database for local data storage
- **Type Adapters**: Custom serialization for Movie objects
- **Automatic Persistence**: Data survives app restarts

## 📁 Project Structure
```
lib/
├── main.dart                 # App entry point with ProviderScope
├── models/
│   ├── movie.dart           # Movie data model with Hive annotations
│   └── movie.g.dart         # Generated Hive adapter
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

## 📖 Usage Guide

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

### Navigation
- **Main Screen**: Displays all movies in a list
- **Add Movie Screen**: Accessed via floating action button
- **Back Navigation**: Use back button or AppBar back arrow

## 🧪 Testing

The application includes comprehensive testing coverage across all layers.

### Running Tests

**All Tests (Recommended)**
```bash
flutter test
```

**Specific Test Categories**
```bash
# Unit Tests
flutter test test/models/
flutter test test/providers/

# Widget Tests
flutter test test/widgets/
flutter test test/screens/

# Integration Tests
flutter test integration_test/
```

**Test with Coverage**
```bash
flutter test --coverage
```

### Test Coverage

- **Unit Tests**: Model validation, business logic, data persistence
- **Widget Tests**: UI components, form validation, user interactions
- **Integration Tests**: Complete user flows, data persistence across sessions
- **Provider Tests**: State management and business logic

## 📦 Dependencies

### Production Dependencies
| Package | Version | Purpose |
|---------|---------|---------|
| `flutter` | SDK | Flutter framework |
| `flutter_riverpod` | ^2.4.9 | State management |
| `hive` | ^2.2.3 | Local database |
| `hive_flutter` | ^1.1.0 | Flutter integration for Hive |
| `path_provider` | ^2.1.2 | File system paths |
| `cupertino_icons` | ^1.0.8 | iOS-style icons |

### Development Dependencies
| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_test` | SDK | Testing framework |
| `hive_generator` | ^2.0.1 | Code generation for Hive |
| `build_runner` | ^2.4.7 | Build system |
| `integration_test` | SDK | End-to-end testing |
| `flutter_lints` | ^5.0.0 | Linting rules |

## 🔧 Code Quality

### Linting
The project uses Flutter's recommended linting rules defined in `analysis_options.yaml`.

```bash
# Run linting
flutter analyze

# Fix auto-fixable issues
dart fix --apply
```

### Best Practices
- **Separation of Concerns**: Clear separation between UI, business logic, and data layers
- **Error Handling**: Comprehensive error handling with user feedback
- **Input Validation**: Client-side validation with clear error messages
- **Responsive Design**: Adaptive UI components
- **Code Documentation**: Inline comments and comprehensive README

## ⚡ Performance Considerations

- **Efficient State Management**: Riverpod's fine-grained reactivity minimizes unnecessary rebuilds
- **Local Storage**: Hive provides fast, lightweight data persistence
- **Memory Management**: Automatic provider disposal and state cleanup
- **Lazy Loading**: Efficient list rendering with ListView.builder
- **Compile-time Safety**: Riverpod catches state management errors at compile time

## 🔍 Troubleshooting

### Common Issues

**Build Runner Issues**
```bash
flutter packages pub run build_runner clean
flutter packages pub run build_runner build --delete-conflicting-outputs
```

**Hive Database Issues**
```bash
# Clear app data or use in code:
await Hive.deleteFromDisk();
```

**Flutter Issues**
```bash
flutter clean
flutter pub get
flutter doctor
```

**Test Issues**
```bash
flutter clean
flutter pub get
flutter test
```

**Platform-Specific Issues**

*Web:*
```bash
flutter run -d chrome --web-renderer html  # If canvas issues
```

*iOS Simulator:*
```bash
open -a Simulator
flutter run
```

*Android Emulator:*
```bash
flutter emulators --launch <emulator_id>
flutter run
```