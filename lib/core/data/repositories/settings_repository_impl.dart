import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';
import 'package:aquagravity/core/domain/models/failure.dart';
import 'package:aquagravity/core/domain/models/user_settings.dart';
import 'package:aquagravity/core/domain/repositories/settings_repository.dart';
import 'package:aquagravity/core/data/database/daos/settings_dao.dart';
import 'package:aquagravity/core/data/database/app_database.dart';

/// Implementation of SettingsRepository using Drift
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsDao _settingsDao;

  SettingsRepositoryImpl({required SettingsDao settingsDao})
    : _settingsDao = settingsDao;

  @override
  Stream<UserSettings> watchSettings() {
    return _settingsDao.watchSettings().map((entity) {
      if (entity == null) {
        // Return default settings if none exist
        return const UserSettings(id: '');
      }
      return entity.toDomain();
    });
  }

  @override
  Future<Either<Failure, UserSettings>> getSettings() async {
    try {
      await _settingsDao.ensureDefaultSettings();
      final entity = await _settingsDao.getSettings();
      if (entity == null) {
        return const Left(Failure.notFound(message: 'Settings not found'));
      }
      return Right(entity.toDomain());
    } catch (e) {
      return Left(Failure.database(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateSettings(UserSettings settings) async {
    try {
      await _settingsDao.upsertSettings(settings.toCompanion());
      return const Right(true);
    } catch (e) {
      return Left(Failure.database(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateDailyGoal(double newGoal) async {
    try {
      // Ensure default settings exist
      await _settingsDao.ensureDefaultSettings();

      final entity = await _settingsDao.getSettings();
      if (entity == null) {
        return const Left(Failure.notFound(message: 'Settings not found'));
      }
      final updatedSettings = entity.toDomain().copyWith(dailyGoal: newGoal);
      await _settingsDao.upsertSettings(updatedSettings.toCompanion());
      return const Right(true);
    } catch (e) {
      return Left(Failure.database(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> resetSettings() async {
    try {
      final entity = await _settingsDao.getSettings();
      if (entity == null) {
        return const Left(Failure.notFound(message: 'Settings not found'));
      }
      await _settingsDao.resetSettings(entity.uuid);
      return const Right(true);
    } catch (e) {
      return Left(Failure.database(message: e.toString()));
    }
  }
}

/// Extension to convert UserSettingsEntity to domain model
extension UserSettingsEntityX on UserSettingsEntity {
  UserSettings toDomain() {
    return UserSettings(
      id: uuid,
      dailyGoal: dailyGoal,
      reminderEnabled: reminderEnabled,
      reminderInterval: reminderInterval,
      bedTimeHour: bedTimeHour,
      wakeUpHour: wakeUpHour,
    );
  }
}

/// Extension to convert domain model to Drift companion
extension UserSettingsCompanionX on UserSettings {
  UserSettingsTableCompanion toCompanion() {
    return UserSettingsTableCompanion(
      uuid: this.id.isEmpty ? Value.absent() : Value(this.id),
      dailyGoal: Value(dailyGoal),
      reminderEnabled: Value(reminderEnabled),
      reminderInterval: Value(reminderInterval),
      bedTimeHour: Value(bedTimeHour),
      wakeUpHour: Value(wakeUpHour),
    );
  }
}
