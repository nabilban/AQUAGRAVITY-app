import 'package:drift/drift.dart';

/// Reusable mixin for UUID primary key
mixin UuidMixin on Table {
  TextColumn get uuid => text()();

  @override
  Set<Column> get primaryKey => {uuid};
}
