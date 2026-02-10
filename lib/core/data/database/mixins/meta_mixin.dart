import 'package:drift/drift.dart';

/// Reusable mixin for metadata fields (createdAt, deletedAt)
mixin MetaMixin on Table {
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();

  DateTimeColumn get deletedAt => dateTime().nullable()();
}
