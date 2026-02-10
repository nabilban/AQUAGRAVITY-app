import 'package:drift/drift.dart';
import '../mixins/uuid_mixin.dart';
import '../mixins/meta_mixin.dart';

/// Drift table for user settings
@DataClassName('UserSettingsEntity')
class UserSettingsTable extends Table with UuidMixin, MetaMixin {
  RealColumn get dailyGoal => real().withDefault(const Constant(2000.0))();
  BoolColumn get reminderEnabled =>
      boolean().withDefault(const Constant(true))();
  IntColumn get reminderInterval => integer().withDefault(const Constant(60))();
}
