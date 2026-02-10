---
trigger: always_on
---

# Flutter Project Development Rules

**Generalized Standards from LiList Project**

## 1. Architecture

**Clean Architecture - 3 Layers:**

```
app/          → Presentation (UI, Pages, BLoC)
core/domain/  → Domain (Models, Repository Interfaces)
core/data/    → Data (Repository Impl, DAOs, APIs)
```

**Folder Structure:**

```
lib/
├── app/
│   ├── commons/        # Shared widgets, extensions
│   ├── features/       # Feature modules
│   │   └── {name}/
│   │       ├── cubit/  # State management
│   │       ├── pages/
│   │       └── widgets/
│   ├── providers/      # DI
│   ├── router/         # Navigation
│   └── ui/            # Theme, constants
├── core/
│   ├── data/
│   │   ├── database/  # Drift tables, DAOs
│   │   ├── datasources/
│   │   └── repositories/
│   ├── domain/
│   │   ├── models/    # Freezed models
│   │   └── repositories/
│   └── utils/
├── resources/generated/
└── main_{env}.dart    # dev, staging, prod
```

## 2. Tech Stack

**Required:**

- `flutter_bloc` + `bloc` - State management
- `freezed` + `freezed_annotation` - Immutable classes
- `auto_route` - Type-safe navigation
- `drift` + `drift_flutter` - SQLite ORM
- `dio` or `chopper` - HTTP client
- `dartz` - Either pattern
- `json_annotation` - Serialization
- `build_runner` - Code generation

**Recommended:**

- `rxdart` - Reactive streams
- `google_fonts` - Typography
- `bloc_test` + `mocktail` - Testing
- `melos` - Build automation

## 3. State Management

**BLoC/Cubit Pattern:**

```dart
class FeatureCubit extends Cubit<FeatureState> {
  FeatureCubit({required this.repository})
    : super(const FeatureState.initial());

  final Repository repository;

  Future<void> loadData() async {
    emit(const FeatureState.loading());
    final result = await repository.getData();
    result.fold(
      (failure) => emit(FeatureState.error(failure.message)),
      (data) => emit(FeatureState.loaded(data)),
    );
  }
}
```

**States with Freezed:**

```dart
@freezed
class FeatureState with _$FeatureState {
  const factory FeatureState.initial() = _Initial;
  const factory FeatureState.loading() = _Loading;
  const factory FeatureState.loaded(Data data) = _Loaded;
  const factory FeatureState.error(String message) = _Error;
}
```

## 4. Navigation

**Auto Route Setup:**

```dart
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    CustomRoute(
      path: '/home',
      page: HomeRoute.page,
      transitionsBuilder: TransitionsBuilders.fadeIn,
    ),
    CustomRoute(
      path: '/detail/:id',
      page: DetailRoute.page,
    ),
  ];
}
```

**Usage:**

```dart
context.router.push(DetailRoute(id: '123'));
context.router.pop();
```

## 5. Database (Drift)

**Table Definition:**

```dart
@DataClassName('UserEntity')
class Users extends Table with UuidMixin, MetaMixin {
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get email => text().unique()();
}

// Reusable mixins
mixin UuidMixin {
  TextColumn get uuid => text().clientDefault(() => Uuid().v4())();
  @override
  Set<Column> get primaryKey => {uuid};
}

mixin MetaMixin {
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}
```

**DAO Pattern:**

```dart
@DriftAccessor(tables: [Users])
class UserDao extends DatabaseAccessor<AppDatabase> {
  Stream<List<UserEntity>> watchAll() => select(users).watch();
  Future<UserEntity?> getById(String id) =>
    (select(users)..where((u) => u.uuid.equals(id))).getSingleOrNull();
  Future<void> insert(UserEntity user) => into(users).insert(user);
}
```

**Repository Implementation:**

```dart
class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl({required this.userDao});
  final UserDao userDao;

  @override
  Stream<List<User>> userStream() =>
    userDao.watchAll().map((e) => e.map((x) => x.toDomain()).toList());

  @override
  Future<Either<Failure, User>> getUser(String id) async {
    try {
      final entity = await userDao.getById(id);
      return entity == null
        ? Left(NotFoundFailure(message: 'User not found'))
        : Right(entity.toDomain());
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }
}
```

## 6. Domain Layer

**Models:**

```dart
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
  }) = _User;
}

extension UserX on User {
  bool get isValid => ValidationUtils.isValidEmail(email);
}
```

**Repository Interface:**

```dart
abstract class UserRepository {
  Stream<List<User>> userStream();
  Future<Either<Failure, User>> getUser(String id);
  Future<Either<Failure, bool>> createUser(User user);
}
```

**Mappers:**

```dart
extension UserEntityX on UserEntity {
  User toDomain() => User(id: uuid, name: name, email: email);
}

extension UserModelX on User {
  UsersCompanion get insertable =>
    UsersCompanion.insert(uuid: Value(id), name: name, email: email);
}
```

## 7. Error Handling

**Either Pattern:**

```dart
Future<Either<Failure, Data>> getData() async {
  try {
    final data = await api.fetch();
    return Right(data);
  } on NetworkException catch (e) {
    return Left(NetworkFailure(message: e.message));
  } catch (e) {
    return Left(UnknownFailure(message: e.toString()));
  }
}
```

**Failures:**

```dart
@freezed
class Failure with _$Failure {
  const factory Failure.database({required String message}) = DatabaseFailure;
  const factory Failure.network({required String message}) = NetworkFailure;
  const factory Failure.notFound({required String message}) = NotFoundFailure;
}
```

## 8. UI & Theme

**Material 3:**

```dart
ThemeData theme(ColorScheme scheme) => ThemeData(
  useMaterial3: true,
  colorScheme: scheme,
  textTheme: GoogleFonts.interTextTheme(),
  scaffoldBackgroundColor: scheme.surfaceContainerLow,
  appBarTheme: AppBarTheme(
    backgroundColor: scheme.surface,
    foregroundColor: scheme.primary,
  ),
);
```

**Constants:**

```dart
class AppDimens {
  static const double x2 = 8;
  static const double x4 = 16;
  static const double x6 = 24;
}

class AppBorderRadius {
  static const small = BorderRadius.all(Radius.circular(8));
  static const medium = BorderRadius.all(Radius.circular(12));
}
```

## 9. Code Generation

**Build Commands:**

```bash
# Generate code
dart run build_runner build --delete-conflicting-outputs

# Clean generated files
find . -name "*.g.dart" -delete
find . -name "*.freezed.dart" -delete
```

**Melos (Optional):**

```yaml
scripts:
  gen:
    run: |
      melos run build
      melos run fix
  build:
    run: dart run build_runner build --delete-conflicting-outputs
  fix:
    run: dart fix --apply
```

## 10. Multi-Environment

**Entry Points:**

```dart
// main_development.dart
void main() => bootstrap(env: Env.dev());

// main_production.dart
void main() => bootstrap(env: Env.prod());
```

**Run Commands:**

```bash
flutter run --flavor development -t lib/main_development.dart
flutter run --flavor production -t lib/main_production.dart
flutter build apk --flavor production -t lib/main_production.dart
```

## 11. Testing

**BLoC Test:**

```dart
blocTest<FeatureCubit, FeatureState>(
  'emits [loading, loaded] when successful',
  build: () {
    when(() => mockRepo.getData()).thenAnswer((_) async => Right(data));
    return FeatureCubit(repository: mockRepo);
  },
  act: (cubit) => cubit.loadData(),
  expect: () => [
    const FeatureState.loading(),
    FeatureState.loaded(data),
  ],
);
```

## 12. Best Practices

**DO:**

- ✅ Use Clean Architecture (3 layers)
- ✅ Use BLoC/Cubit for state
- ✅ Use Freezed for immutability
- ✅ Use Either for error handling
- ✅ Use Auto Route for navigation
- ✅ Use Drift DAO pattern
- ✅ Generate code (build_runner)
- ✅ Support multi-environment
- ✅ Write tests (bloc_test)
- ✅ Use const constructors
- ✅ Follow null safety
- ✅ Document complex logic

**DON'T:**

- ❌ Mix layer responsibilities
- ❌ Use setState for complex state
- ❌ Hardcode environment configs
- ❌ Skip error handling
- ❌ Ignore code generation
- ❌ Skip testing critical paths

## 13. Checklist for New Projects

- [ ] Set up Clean Architecture folders
- [ ] Configure multi-environment (dev/prod)
- [ ] Set up BLoC + Freezed
- [ ] Configure Auto Route
- [ ] Set up Drift database
- [ ] Implement Either error handling
- [ ] Configure Material 3 theme
- [ ] Set up build_runner
- [ ] Configure linting (analysis_options.yaml)
- [ ] Set up testing infrastructure
- [ ] Create README with setup instructions

---

**Source**: LiList Project Analysis | **Purpose**: Reusable Flutter Standards
