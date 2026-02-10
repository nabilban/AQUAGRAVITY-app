import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables/hydration_logs_table.dart';
import 'tables/user_settings_table.dart';
import 'daos/hydration_dao.dart';
import 'daos/settings_dao.dart';

part 'app_database.g.dart';

/// Main application database
@DriftDatabase(
  tables: [HydrationLogs, UserSettingsTable],
  daos: [HydrationDao, SettingsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'aquagravity_db');
  }
}
