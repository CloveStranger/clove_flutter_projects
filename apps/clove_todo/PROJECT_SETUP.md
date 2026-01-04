# Clove Todo - Project Setup Documentation

## Overview

This document describes the project setup and infrastructure for the Clove Todo scheduling application.

## Architecture

The project follows Clean Architecture principles with the following structure:

```
lib/
├── app/                    # Application configuration
├── core/                   # Shared core functionality
│   ├── database/          # Database service (Drift)
│   ├── error/             # Error handling
│   ├── network/           # Network utilities
│   ├── services/          # Core services (notifications, etc.)
│   ├── usecase/           # Base use case classes
│   └── utils/             # Utilities and constants
├── features/              # Feature modules
│   ├── schedule/          # Schedule management feature
│   ├── reminder/          # Reminder system feature
│   └── sync/              # Synchronization feature
└── injection/             # Dependency injection setup
```

## Dependencies

The project uses the following key dependencies:

### Core Framework

- **Flutter**: Cross-platform UI framework
- **Dart**: Programming language

### State Management

- **flutter_bloc**: BLoC pattern implementation
- **equatable**: Value equality

### Dependency Injection

- **get_it**: Service locator
- **injectable**: Code generation for dependency injection

### Database

- **drift**: Type-safe SQL database
- **sqlite3_flutter_libs**: SQLite implementation
- **path_provider**: File system access

### Networking

- **dio**: HTTP client
- **connectivity_plus**: Network connectivity checking

### UI Components

- **table_calendar**: Calendar widget
- **go_router**: Type-safe routing

### Notifications

- **flutter_local_notifications**: Local notifications
- **timezone**: Timezone handling

### Utilities

- **intl**: Internationalization
- **uuid**: UUID generation
- **json_annotation**: JSON serialization
- **dartz**: Functional programming utilities

### Code Generation

- **build_runner**: Code generation runner
- **injectable_generator**: Dependency injection code generation
- **drift_dev**: Database code generation
- **json_serializable**: JSON serialization code generation

## Build Configuration

### Code Generation

The project uses `build.yaml` to configure code generation:

- Drift database code generation
- JSON serialization
- Dependency injection

### Android Configuration

- Core library desugaring enabled for modern Java features
- Minimum SDK version as per Flutter requirements
- Target SDK version for latest Android features

## Getting Started

1. **Install Dependencies**

   ```bash
   flutter pub get
   ```

2. **Generate Code**

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

3. **Run the Application**
   ```bash
   flutter run
   ```

## Development Workflow

1. **Adding New Features**

   - Create feature directory under `lib/features/`
   - Follow Clean Architecture layers (domain, data, presentation)
   - Add dependency injection annotations
   - Run code generation

2. **Database Changes**

   - Update database models in `lib/core/database/`
   - Run code generation to update schema
   - Handle migrations if needed

3. **Code Generation**
   - Run after adding new injectable classes
   - Run after database model changes
   - Run after adding JSON serializable classes

## Testing

The project supports both unit testing and property-based testing:

- Unit tests for specific functionality
- Property-based tests for universal properties
- Integration tests for complete workflows

## Next Steps

This setup provides the foundation for implementing the scheduling features according to the design document. The next tasks involve:

1. Implementing core domain entities
2. Setting up data models and repositories
3. Creating presentation layer components
4. Implementing business logic use cases
