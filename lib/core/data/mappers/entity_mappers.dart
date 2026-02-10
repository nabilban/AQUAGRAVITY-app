import 'package:drift/drift.dart';
import 'package:aquagravity/core/data/database/app_database.dart';
import 'package:aquagravity/core/domain/models/hydration_log.dart';
import 'package:aquagravity/core/domain/models/user_settings.dart';

/// Extension to convert HydrationLog to Drift companion
extension HydrationLogToCompanion on HydrationLog {
  /// Convert to Drift companion for database insertion
  HydrationLogsCompanion toCompanion() {
    return HydrationLogsCompanion(
      uuid: Value(id),
      amount: Value(amount),
      timestamp: Value(timestamp),
      note: Value(note),
    );
  }
}

/// Extension to convert HydrationLogEntity to domain model
extension HydrationLogEntityToDomain on HydrationLogEntity {
  /// Convert database entity to domain model
  HydrationLog toDomain() {
    return HydrationLog(
      id: uuid,
      amount: amount,
      timestamp: timestamp,
      note: note,
    );
  }
}

/// Extension to convert UserSettings to Drift companion
extension UserSettingsToCompanion on UserSettings {
  /// Convert to Drift companion for database update
  UserSettingsTableCompanion toCompanion() {
    return UserSettingsTableCompanion(
      uuid: Value(id),
      dailyGoal: Value(dailyGoal),
      reminderEnabled: Value(reminderEnabled),
      reminderInterval: Value(reminderInterval),
    );
  }
}

/// Extension to convert UserSettingsEntity to domain model
extension UserSettingsEntityToDomain on UserSettingsEntity {
  /// Convert database entity to domain model
  UserSettings toDomain() {
    return UserSettings(
      id: uuid,
      dailyGoal: dailyGoal,
      reminderEnabled: reminderEnabled,
      reminderInterval: reminderInterval,
    );
  }
}
