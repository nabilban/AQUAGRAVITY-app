// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:aquagravity/app/features/hydration/cubit/hydration_cubit.dart'
    as _i660;
import 'package:aquagravity/app/providers/injection_modules.dart' as _i530;
import 'package:aquagravity/core/data/database/app_database.dart' as _i1039;
import 'package:aquagravity/core/data/database/daos/hydration_dao.dart'
    as _i749;
import 'package:aquagravity/core/data/database/daos/settings_dao.dart' as _i522;
import 'package:aquagravity/core/domain/repositories/hydration_repository.dart'
    as _i303;
import 'package:aquagravity/core/domain/repositories/settings_repository.dart'
    as _i979;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final databaseModule = _$DatabaseModule();
    final repositoryModule = _$RepositoryModule();
    final cubitModule = _$CubitModule();
    gh.lazySingleton<_i1039.AppDatabase>(() => databaseModule.database);
    gh.lazySingleton<_i749.HydrationDao>(
      () => databaseModule.hydrationDao(gh<_i1039.AppDatabase>()),
    );
    gh.lazySingleton<_i522.SettingsDao>(
      () => databaseModule.settingsDao(gh<_i1039.AppDatabase>()),
    );
    gh.lazySingleton<_i979.SettingsRepository>(
      () => repositoryModule.settingsRepository(gh<_i522.SettingsDao>()),
    );
    gh.lazySingleton<_i303.HydrationRepository>(
      () => repositoryModule.hydrationRepository(gh<_i749.HydrationDao>()),
    );
    gh.factory<_i660.HydrationCubit>(
      () => cubitModule.hydrationCubit(
        gh<_i303.HydrationRepository>(),
        gh<_i979.SettingsRepository>(),
      ),
    );
    return this;
  }
}

class _$DatabaseModule extends _i530.DatabaseModule {}

class _$RepositoryModule extends _i530.RepositoryModule {}

class _$CubitModule extends _i530.CubitModule {}
