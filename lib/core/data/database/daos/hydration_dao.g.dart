// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hydration_dao.dart';

// ignore_for_file: type=lint
mixin _$HydrationDaoMixin on DatabaseAccessor<AppDatabase> {
  $HydrationLogsTable get hydrationLogs => attachedDatabase.hydrationLogs;
  HydrationDaoManager get managers => HydrationDaoManager(this);
}

class HydrationDaoManager {
  final _$HydrationDaoMixin _db;
  HydrationDaoManager(this._db);
  $$HydrationLogsTableTableManager get hydrationLogs =>
      $$HydrationLogsTableTableManager(_db.attachedDatabase, _db.hydrationLogs);
}
