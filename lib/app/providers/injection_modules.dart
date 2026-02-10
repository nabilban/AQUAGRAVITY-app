import 'package:injectable/injectable.dart';
import '../../core/data/database/app_database.dart';
import '../../core/data/database/daos/hydration_dao.dart';
import '../../core/data/database/daos/settings_dao.dart';
import '../../core/data/repositories/hydration_repository_impl.dart';
import '../../core/data/repositories/settings_repository_impl.dart';
import '../../core/domain/repositories/hydration_repository.dart';
import '../../core/domain/repositories/settings_repository.dart';
import '../features/hydration/cubit/hydration_cubit.dart';

/// Database module
@module
abstract class DatabaseModule {
  @lazySingleton
  AppDatabase get database => AppDatabase();

  @lazySingleton
  HydrationDao hydrationDao(AppDatabase db) => db.hydrationDao;

  @lazySingleton
  SettingsDao settingsDao(AppDatabase db) => db.settingsDao;
}

/// Repository module
@module
abstract class RepositoryModule {
  @lazySingleton
  HydrationRepository hydrationRepository(HydrationDao dao) =>
      HydrationRepositoryImpl(hydrationDao: dao);

  @lazySingleton
  SettingsRepository settingsRepository(SettingsDao dao) =>
      SettingsRepositoryImpl(settingsDao: dao);
}

/// Cubit module
@module
abstract class CubitModule {
  @injectable
  HydrationCubit hydrationCubit(
    HydrationRepository hydrationRepo,
    SettingsRepository settingsRepo,
  ) => HydrationCubit(
    hydrationRepository: hydrationRepo,
    settingsRepository: settingsRepo,
  );
}
