import 'package:drift/drift.dart';
import '../mixins/uuid_mixin.dart';
import '../mixins/meta_mixin.dart';

/// Drift table for hydration logs
@DataClassName('HydrationLogEntity')
class HydrationLogs extends Table with UuidMixin, MetaMixin {
  RealColumn get amount => real()(); // Amount in milliliters
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get note => text().nullable().withLength(max: 500)();
}
