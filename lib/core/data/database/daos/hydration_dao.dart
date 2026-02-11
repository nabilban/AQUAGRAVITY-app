import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/hydration_logs_table.dart';

part 'hydration_dao.g.dart';

/// Data Access Object for hydration logs
@DriftAccessor(tables: [HydrationLogs])
class HydrationDao extends DatabaseAccessor<AppDatabase>
    with _$HydrationDaoMixin {
  HydrationDao(super.db);

  /// Watch all hydration logs (excluding deleted ones)
  Stream<List<HydrationLogEntity>> watchAll() {
    return (select(hydrationLogs)
          ..where((tbl) => tbl.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .watch();
  }

  /// Watch today's hydration logs
  Stream<List<HydrationLogEntity>> watchTodayLogs() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(hydrationLogs)
          ..where(
            (tbl) =>
                tbl.deletedAt.isNull() &
                tbl.timestamp.isBiggerOrEqualValue(startOfDay) &
                tbl.timestamp.isSmallerThanValue(endOfDay),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .watch();
  }

  /// Get hydration log by ID
  Future<HydrationLogEntity?> getById(String id) {
    return (select(hydrationLogs)
          ..where((tbl) => tbl.uuid.equals(id) & tbl.deletedAt.isNull()))
        .getSingleOrNull();
  }

  /// Get logs for a specific date
  Future<List<HydrationLogEntity>> getLogsByDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return (select(hydrationLogs)
          ..where(
            (tbl) =>
                tbl.deletedAt.isNull() &
                tbl.timestamp.isBiggerOrEqualValue(startOfDay) &
                tbl.timestamp.isSmallerThanValue(endOfDay),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .get();
  }

  /// Insert a new hydration log
  Future<int> insertLog(HydrationLogsCompanion log) {
    return into(hydrationLogs).insert(log);
  }

  /// Soft delete a hydration log
  Future<int> deleteLog(String id) {
    return (update(hydrationLogs)..where((tbl) => tbl.uuid.equals(id))).write(
      HydrationLogsCompanion(deletedAt: Value(DateTime.now())),
    );
  }

  /// Soft delete all hydration logs
  Future<int> deleteAllLogs() {
    return (update(hydrationLogs)..where((tbl) => tbl.deletedAt.isNull()))
        .write(HydrationLogsCompanion(deletedAt: Value(DateTime.now())));
  }

  /// Get today's total hydration amount
  Future<double> getTodayTotal() async {
    final logs = await watchTodayLogs().first;
    double total = 0.0;
    for (final log in logs) {
      total += log.amount;
    }
    return total;
  }
}
