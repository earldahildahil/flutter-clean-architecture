---
name: flutter-clean-architecture
description: Build This skill enforces BLoC state management, strict layer separation, and mandatory use of design system constants for all Flutter development in this codebase.
license: Complete terms in LICENSE.txt
---

# Flutter Clean Architecture Skill

This skill enforces BLoC state management, strict layer separation, and mandatory use of design system constants for all Flutter development in this codebase.


## Decision Tree: Choosing Your Approach

```
User task → What are they building?
    │
    ├─ New screen/feature → Full feature implementation:
    │   1. Create feature folder (lib/[feature]/)
    │   2. Define BLoC (bloc/[feature]_event.dart, _state.dart, _bloc.dart)
    │   3. Create data layer (data/datasources/, data/repositories/, data/models/)
    │   4. Build UI (view/[feature]_page.dart, view/widgets/)
    │   5. Import each file directly using package: imports (no barrel files)
    │
    ├─ New widget only → Presentation layer:
    │   1. Feature-specific: feature/view/widgets/
    │   2. Shared/reusable: shared/widgets/
    │   3. Use design system constants (NO hardcoded values)
    │   4. Connect to existing BLoC if needed
    │
    ├─ Data integration → Data layer only:
    │   1. Create datasource (feature/data/datasources/)
    │   2. Create repository (feature/data/repositories/)
    │   3. Wire up in existing or new BLoC
    │
    └─ Refactoring → Identify violations:
        1. Check for hardcoded colors/spacing/typography
        2. Check for business logic in UI
        3. Check for direct SDK calls outside datasources
        4. Check for missing Loading state before async operations
        5. Check for missing Equatable on Events/States
        6. Check for improper error handling (use SnackBar + AppColors.error)
        7. Check for relative imports (replace with package: imports)
```

## Architecture at a Glance

**Module-First Structure**:

```
lib/
├── app/                          # App-wide setup
│   ├── app.dart                  # Root widget
│   ├── assets.dart               # Asset constants
│   ├── config.dart               # Environment config
│   ├── dependency_injection.dart # DI wiring
│   ├── providers.dart            # BLoC/Cubit providers
│   └── router.dart               # Route definitions
├── core/                         # Infrastructure & cross-cutting concerns
│   ├── dependencies/             # Core DI registrations
│   ├── errors/                   # Error & exception types
│   ├── services/                 # Core services (e.g., analytics, connectivity, etc.)
│   ├── utils/                    # Shared utilities (date, distance, validators, etc.)
├── design_system/                # Design tokens & reusable UI components
│   ├── colors.dart               # AppColors
│   ├── dimensions.dart           # AppSpacing, AppRadius
│   ├── typography.dart           # AppTypography
│   ├── styles.dart               # Shared styles
│   ├── theme.dart                # App theme
│   ├── widgets/                  # Core reusable widgets (buttons, inputs, etc.)
├── modules/                      # Feature modules
│   ├── [feature]/                # e.g., address/, meal/, order/, user/
│   │   ├── data/
│   │   │   ├── data_sources/     # Remote/local data sources (API/SDK calls only)
│   │   │   ├── models/           # DTOs with fromJson/toJson
│   │   │   └── repositories/     # Repository implementations
│   │   ├── dependencies/         # Feature-level DI registrations
│   │   ├── domain/
│   │   │   ├── entities/         # Domain models (pure Dart)
│   │   │   ├── repositories/     # Repository interfaces (abstract)
│   │   │   └── use_cases/        # One use case per file
│   │   └── presentation/
│   │       ├── [screen]/         # Screen-level folder (e.g., addresses/, login/)
│   │       │   ├── cubit/        # [screen]_cubit.dart + [screen]_state.dart
│   │       │   ├── widgets/   # Screen-specific widgets
│   │       │   └── [screen]_screen.dart  # Main screen widget
│   │       └── ...               # Other screens within the feature
│   └── shared/                   # Cross-module utilities
│       └── widgets/              # Reusable widgets used by 2+ modules (e.g., error displays, empty states)
│       └── utils/                # e.g., SnackBarManager, theme extensions, formatters
├── main_dev.dart                 # Devlopment entry point
├── main_stg.dart                 # Staging entry point
└── main_prod.dart                # Production entry point
```



**Key Rules:**
- All state changes flow through Cubit/BLoC
- No direct backend SDK calls outside data_sources
- Zero hardcoded values (colors, spacing, typography)
- Repository pattern for all data access
- Feature-specific code stays in its module folder
- Shared code (used by 2+ modules) goes in `modules/shared/`
- **Always use package imports — never relative imports**

---

## Core Libraries

These libraries are **always included** in `pubspec.yaml` for every project. Do not remove or replace them.

### Dependencies

| Package | Purpose |
|---------|---------|
| `cached_network_image` | Efficient network image loading with caching |
| `cupertino_icons` | iOS-style icons for cross-platform UI |
| `date_time_format` | Human-readable date/time formatting |
| `enum_to_string` | Convert enums to/from strings (useful for API serialization) |
| `equatable` | Value equality for BLoC events, states, and entities |
| `flutter_bloc` | BLoC/Cubit state management — the primary state management solution |
| `get_it` | Service locator / dependency injection container |
| `go_router` | Declarative routing with deep link support |
| `logger` | Structured, leveled console logging |
| `package_info_plus` | Access app version, build number, and package name at runtime |
| `sizer` | Responsive sizing — adapts dimensions to screen size |

### Dev Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_flavorizr` | Multi-flavor (dev/stg/prod) build configuration |
| `very_good_analysis` | Strict lint rules enforcing code quality |


### Flavor Configuration

Projects use `flutter_flavorizr` with **dev**, **stg**, and **prod** flavors. Entry points must match:

```
lib/
├── main_dev.dart     # Development flavor
├── main_stg.dart     # Staging flavor
└── main_prod.dart    # Production flavor
```

Each flavor sets a different `app name`, `applicationId`/`bundleId`, and Firebase config:

```yaml
# pubspec.yaml (flavorizr section)
flavorizr:
  flavors:
    dev:
      app:
        name: "[DEV] AppName"
      android:
        applicationId: "com.example.app.dev"
        firebase:
          config: ".firebase/dev/google-services.json"
      ios:
        bundleId: "com.example.app.dev"
        firebase:
          config: ".firebase/dev/GoogleService-Info.plist"
    stg:
      app:
        name: "[STG] AppName"
      android:
        applicationId: "com.example.app.stg"
        firebase:
          config: ".firebase/stg/google-services.json"
      ios:
        bundleId: "com.example.app.stg"
        firebase:
          config: ".firebase/stg/GoogleService-Info.plist"
    prod:
      app:
        name: "AppName"
      android:
        applicationId: "com.example.app"
        firebase:
          config: ".firebase/prod/google-services.json"
      ios:
        bundleId: "com.example.app"
        firebase:
          config: ".firebase/prod/GoogleService-Info.plist"
```

---

## Import Style

**Always use package imports.** Relative imports (`../`, `./`) are forbidden.

```dart
// ✅ CORRECT — package imports
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dinnerstar/modules/order/presentation/orders/cubit/orders_cubit.dart';
import 'package:dinnerstar/modules/order/presentation/orders/cubit/orders_state.dart';
import 'package:dinnerstar/modules/order/domain/entities/order.dart';
import 'package:dinnerstar/modules/order/data/data_sources/order_remote_data_source.dart';
import 'package:dinnerstar/design_system/colors.dart';

// ❌ WRONG — relative imports
import '../orders_cubit.dart';
import './orders_state.dart';
import '../../data/models/order_model.dart';
```


The package name (`dinnerstar`) matches the `name` field in `pubspec.yaml`.

---

## BLoC Implementation

### Event → State → BLoC (Three Files Per Feature)

**Events** — User actions and system triggers:
```dart
abstract class FeatureEvent extends Equatable {
  const FeatureEvent();
  @override
  List<Object?> get props => [];
}

class FeatureActionRequested extends FeatureEvent {
  final String param;
  const FeatureActionRequested({required this.param});
  @override
  List<Object> get props => [param];
}
```

**States** — All possible UI states:
```dart
abstract class FeatureState extends Equatable {
  const FeatureState();
  @override
  List<Object?> get props => [];
}

class FeatureInitial extends FeatureState {}
class FeatureLoading extends FeatureState {}

class FeatureSuccess extends FeatureState {
  final DataType data;
  const FeatureSuccess(this.data);
  @override
  List<Object> get props => [data];
}

class FeatureError extends FeatureState {
  final String message;
  const FeatureError(this.message);
  @override
  List<Object> get props => [message];
}
```

**BLoC** — Event handlers with Loading → Success/Error pattern:
```dart
class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  final FeatureRepository _repository;

  FeatureBloc({required FeatureRepository repository})
      : _repository = repository,
        super(FeatureInitial()) {
    on<FeatureActionRequested>(_onActionRequested);
  }

  Future<void> _onActionRequested(
    FeatureActionRequested event,
    Emitter<FeatureState> emit,
  ) async {
    emit(FeatureLoading());
    try {
      final result = await _repository.doSomething(event.param);
      emit(FeatureSuccess(result));
    } catch (e) {
      emit(FeatureError(e.toString()));
    }
  }
}
```

**CRITICAL**: Always emit `Loading` before async work, then `Success` or `Error`. Never skip the loading state.

---

## Data Layer

**Data Flow:**
```
UI Event → BLoC (emit Loading) → Repository → Datasource (SDK)
    ↓
Response → Repository (map to entity) → BLoC (emit Success/Error) → UI
```

**Datasource** — Backend SDK calls only:
```dart
class FeatureDataSource {
  final SupabaseClient _supabase;
  FeatureDataSource(this._supabase);

  Future<Map<String, dynamic>> fetch() async {
    return await _supabase.from('table').select().single();
  }
}
```

**Repository** — Orchestration and mapping:
```dart
class FeatureRepository {
  final FeatureDataSource _dataSource;
  FeatureRepository(this._dataSource);

  Future<DomainEntity> fetchData() async {
    final response = await _dataSource.fetch();
    return DomainEntity.fromJson(response);
  }
}
```

---

## Design System (Non-Negotiable)

### Colors
✅ `AppColors.primary`, `AppColors.error`, `AppColors.textPrimary`
❌ `Color(0xFF...)`, `Colors.blue`, inline hex values

### Spacing
✅ `AppSpacing.xs` (4), `AppSpacing.sm` (8), `AppSpacing.md` (16), `AppSpacing.lg` (24), `AppSpacing.xl` (32)
✅ `AppSpacing.screenHorizontal` (24), `AppSpacing.screenVertical` (16)
❌ `EdgeInsets.all(16.0)`, hardcoded padding values

### Border Radius
✅ `AppRadius.sm` (8), `AppRadius.md` (12), `AppRadius.lg` (16), `AppRadius.xl` (24)
❌ `BorderRadius.circular(12)`, inline radius values

### Typography
✅ `AppTypography.headlineLarge`, `AppTypography.bodyMedium`, `theme.textTheme.bodyMedium`
❌ `TextStyle(fontSize: 16)`, inline text styles

---

## UI Patterns

### Screen Template
```dart
GradientScaffold(
  body: SafeArea(
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
          child: HeaderWidget(),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
            child: ContentWidget(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
          child: ActionButton(
            onPressed: () => context.read<FeatureBloc>().add(ActionEvent()),
          ),
        ),
      ],
    ),
  ),
)
```

### BLoC Consumer Pattern
```dart
BlocConsumer<FeatureBloc, FeatureState>(
  listener: (context, state) {
    if (state is FeatureError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
      );
    }
  },
  builder: (context, state) {
    if (state is FeatureLoading) return const Center(child: CircularProgressIndicator());
    if (state is FeatureSuccess) return SuccessWidget(data: state.data);
    return const SizedBox.shrink();
  },
)
```

---

## Common Pitfalls

❌ Business logic in widgets → Move to BLoC
❌ Direct Supabase/Firebase calls in repository → Move to datasource
❌ Skipping loading state before async operations → Always emit Loading first
❌ Hardcoded colors like `Color(0xFF4A90A4)` → Use `AppColors.primary`
❌ Magic numbers like `padding: 16` → Use `AppSpacing.md`
❌ Relative imports like `import '../bloc/earnings_bloc.dart'` → Use `import 'package:app/earnings/bloc/earnings_bloc.dart'`

---

## Quick Reference

| Action | Pattern |
|--------|---------|
| Dispatch event | `context.read<Bloc>().add(Event())` |
| Watch state inline | `context.watch<Bloc>().state` |
| Listen + Build | `BlocConsumer` |
| Listen only | `BlocListener` |
| Build only | `BlocBuilder` |

---

## Checklist Before Submitting

- [ ] Events/States/BLoC use `Equatable`
- [ ] All async: Loading → Success/Error
- [ ] No business logic in UI
- [ ] No SDK calls outside datasources
- [ ] Zero hardcoded colors/spacing/typography
- [ ] Error handling shows SnackBar with `AppColors.error`
- [ ] All imports use `package:` style (no relative imports)
- [ ] Code formatted with `dart format`