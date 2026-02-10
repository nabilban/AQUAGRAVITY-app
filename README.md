# AQUAGRAVITY

**Stay Hydrated. Stay Grounded.**

A physics-based hydration tracking app where UI elements respond to your hydration level—floating when dehydrated, grounded when hydrated.

## 🌊 Concept

AQUAGRAVITY redefines hydration tracking through physics metaphors:

- **Weightless State**: When dehydrated, UI elements float and drift with glassmorphism effects
- **Grounded State**: As you log water intake, elements settle with smooth easeOutBack animations
- **Bubble-Lift Interaction**: Pull floating water droplets down to log your intake

## 🏗️ Architecture

Built with Clean Architecture following comprehensive Flutter development standards:

- **Presentation Layer** (`app/`): BLoC/Cubit state management, pages, widgets
- **Domain Layer** (`core/domain/`): Business models and repository interfaces
- **Data Layer** (`core/data/`): Drift database, DAOs, repository implementations

## 🚀 Getting Started

### Prerequisites

- Flutter 3.38.9 or higher
- Dart 3.10.8 or higher

### Setup

1. **Install dependencies**:

   ```bash
   flutter pub get
   ```

2. **Generate code** (Freezed, Drift, Injectable, Auto Route):

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **Run the development app**:
   ```bash
   flutter run -t lib/main_development.dart
   ```

### Build Commands

- **Development**: `flutter run -t lib/main_development.dart`
- **Production**: `flutter run -t lib/main_production.dart`
- **Build APK**: `flutter build apk -t lib/main_production.dart`

## 🛠️ Tech Stack

- **State Management**: flutter_bloc, rxdart
- **Navigation**: auto_route
- **Database**: drift (SQLite)
- **DI**: get_it, injectable
- **Immutability**: freezed
- **Error Handling**: dartz, fpdart
- **UI**: Material 3, Google Fonts, glassmorphism

## 📝 License

This project is for educational/portfolio purposes.
