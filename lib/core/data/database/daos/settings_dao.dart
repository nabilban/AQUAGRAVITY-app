import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../app_database.dart';
import '../tables/user_settings_table.dart';

part 'settings_dao.g.dart';

/// Data Access Object for user settings
@DriftAccessor(tables: [UserSettingsTable])
class SettingsDao extends DatabaseAccessor<AppDatabase>
    with _$SettingsDaoMixin {
  SettingsDao(super.db);

  /// Watch user settings
  Stream<UserSettingsEntity?> watchSettings() {
    return (select(userSettingsTable)
          ..where((tbl) => tbl.deletedAt.isNull())
          ..limit(1))
        .watchSingleOrNull();
  }

  /// Get user settings
  Future<UserSettingsEntity?> getSettings() {
    return (select(userSettingsTable)
          ..where((tbl) => tbl.deletedAt.isNull())
          ..limit(1))
        .getSingleOrNull();
  }

  /// Insert or update user settings
  Future<int> upsertSettings(UserSettingsTableCompanion settings) {
    return into(userSettingsTable).insertOnConflictUpdate(settings);
  }

  /// Create default settings if none exist
  Future<void> ensureDefaultSettings() async {
    final existing = await getSettings();
    if (existing == null) {
      await into(
        userSettingsTable,
      ).insert(UserSettingsTableCompanion.insert(uuid: const Uuid().v4()));
    }
  }

  /// Reset settings to defaults
  Future<int> resetSettings(String id) {
    return (update(
      userSettingsTable,
    )..where((tbl) => tbl.uuid.equals(id))).write(
      const UserSettingsTableCompanion(
        dailyGoal: Value(2000.0),
        reminderEnabled: Value(true),
        reminderInterval: Value(60),
      ),
    );
  }
}
