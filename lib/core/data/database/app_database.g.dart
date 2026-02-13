// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $HydrationLogsTable extends HydrationLogs
    with TableInfo<$HydrationLogsTable, HydrationLogEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HydrationLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 500),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    uuid,
    createdAt,
    deletedAt,
    amount,
    timestamp,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hydration_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<HydrationLogEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uuid};
  @override
  HydrationLogEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return HydrationLogEntity(
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $HydrationLogsTable createAlias(String alias) {
    return $HydrationLogsTable(attachedDatabase, alias);
  }
}

class HydrationLogEntity extends DataClass
    implements Insertable<HydrationLogEntity> {
  final String uuid;
  final DateTime createdAt;
  final DateTime? deletedAt;
  final double amount;
  final DateTime timestamp;
  final String? note;
  const HydrationLogEntity({
    required this.uuid,
    required this.createdAt,
    this.deletedAt,
    required this.amount,
    required this.timestamp,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uuid'] = Variable<String>(uuid);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['amount'] = Variable<double>(amount);
    map['timestamp'] = Variable<DateTime>(timestamp);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  HydrationLogsCompanion toCompanion(bool nullToAbsent) {
    return HydrationLogsCompanion(
      uuid: Value(uuid),
      createdAt: Value(createdAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      amount: Value(amount),
      timestamp: Value(timestamp),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory HydrationLogEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return HydrationLogEntity(
      uuid: serializer.fromJson<String>(json['uuid']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      amount: serializer.fromJson<double>(json['amount']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uuid': serializer.toJson<String>(uuid),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'amount': serializer.toJson<double>(amount),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'note': serializer.toJson<String?>(note),
    };
  }

  HydrationLogEntity copyWith({
    String? uuid,
    DateTime? createdAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    double? amount,
    DateTime? timestamp,
    Value<String?> note = const Value.absent(),
  }) => HydrationLogEntity(
    uuid: uuid ?? this.uuid,
    createdAt: createdAt ?? this.createdAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    amount: amount ?? this.amount,
    timestamp: timestamp ?? this.timestamp,
    note: note.present ? note.value : this.note,
  );
  HydrationLogEntity copyWithCompanion(HydrationLogsCompanion data) {
    return HydrationLogEntity(
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      amount: data.amount.present ? data.amount.value : this.amount,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('HydrationLogEntity(')
          ..write('uuid: $uuid, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('amount: $amount, ')
          ..write('timestamp: $timestamp, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(uuid, createdAt, deletedAt, amount, timestamp, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is HydrationLogEntity &&
          other.uuid == this.uuid &&
          other.createdAt == this.createdAt &&
          other.deletedAt == this.deletedAt &&
          other.amount == this.amount &&
          other.timestamp == this.timestamp &&
          other.note == this.note);
}

class HydrationLogsCompanion extends UpdateCompanion<HydrationLogEntity> {
  final Value<String> uuid;
  final Value<DateTime> createdAt;
  final Value<DateTime?> deletedAt;
  final Value<double> amount;
  final Value<DateTime> timestamp;
  final Value<String?> note;
  final Value<int> rowid;
  const HydrationLogsCompanion({
    this.uuid = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.amount = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  HydrationLogsCompanion.insert({
    required String uuid,
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    required double amount,
    required DateTime timestamp,
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : uuid = Value(uuid),
       amount = Value(amount),
       timestamp = Value(timestamp);
  static Insertable<HydrationLogEntity> custom({
    Expression<String>? uuid,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? deletedAt,
    Expression<double>? amount,
    Expression<DateTime>? timestamp,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uuid != null) 'uuid': uuid,
      if (createdAt != null) 'created_at': createdAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (amount != null) 'amount': amount,
      if (timestamp != null) 'timestamp': timestamp,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  HydrationLogsCompanion copyWith({
    Value<String>? uuid,
    Value<DateTime>? createdAt,
    Value<DateTime?>? deletedAt,
    Value<double>? amount,
    Value<DateTime>? timestamp,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return HydrationLogsCompanion(
      uuid: uuid ?? this.uuid,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      amount: amount ?? this.amount,
      timestamp: timestamp ?? this.timestamp,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HydrationLogsCompanion(')
          ..write('uuid: $uuid, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('amount: $amount, ')
          ..write('timestamp: $timestamp, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserSettingsTableTable extends UserSettingsTable
    with TableInfo<$UserSettingsTableTable, UserSettingsEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uuidMeta = const VerificationMeta('uuid');
  @override
  late final GeneratedColumn<String> uuid = GeneratedColumn<String>(
    'uuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now(),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dailyGoalMeta = const VerificationMeta(
    'dailyGoal',
  );
  @override
  late final GeneratedColumn<double> dailyGoal = GeneratedColumn<double>(
    'daily_goal',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(2000.0),
  );
  static const VerificationMeta _reminderEnabledMeta = const VerificationMeta(
    'reminderEnabled',
  );
  @override
  late final GeneratedColumn<bool> reminderEnabled = GeneratedColumn<bool>(
    'reminder_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reminder_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _reminderIntervalMeta = const VerificationMeta(
    'reminderInterval',
  );
  @override
  late final GeneratedColumn<int> reminderInterval = GeneratedColumn<int>(
    'reminder_interval',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(60),
  );
  static const VerificationMeta _bedTimeHourMeta = const VerificationMeta(
    'bedTimeHour',
  );
  @override
  late final GeneratedColumn<int> bedTimeHour = GeneratedColumn<int>(
    'bed_time_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(22),
  );
  static const VerificationMeta _wakeUpHourMeta = const VerificationMeta(
    'wakeUpHour',
  );
  @override
  late final GeneratedColumn<int> wakeUpHour = GeneratedColumn<int>(
    'wake_up_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(7),
  );
  @override
  List<GeneratedColumn> get $columns => [
    uuid,
    createdAt,
    deletedAt,
    dailyGoal,
    reminderEnabled,
    reminderInterval,
    bedTimeHour,
    wakeUpHour,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_settings_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserSettingsEntity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uuid')) {
      context.handle(
        _uuidMeta,
        uuid.isAcceptableOrUnknown(data['uuid']!, _uuidMeta),
      );
    } else if (isInserting) {
      context.missing(_uuidMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('daily_goal')) {
      context.handle(
        _dailyGoalMeta,
        dailyGoal.isAcceptableOrUnknown(data['daily_goal']!, _dailyGoalMeta),
      );
    }
    if (data.containsKey('reminder_enabled')) {
      context.handle(
        _reminderEnabledMeta,
        reminderEnabled.isAcceptableOrUnknown(
          data['reminder_enabled']!,
          _reminderEnabledMeta,
        ),
      );
    }
    if (data.containsKey('reminder_interval')) {
      context.handle(
        _reminderIntervalMeta,
        reminderInterval.isAcceptableOrUnknown(
          data['reminder_interval']!,
          _reminderIntervalMeta,
        ),
      );
    }
    if (data.containsKey('bed_time_hour')) {
      context.handle(
        _bedTimeHourMeta,
        bedTimeHour.isAcceptableOrUnknown(
          data['bed_time_hour']!,
          _bedTimeHourMeta,
        ),
      );
    }
    if (data.containsKey('wake_up_hour')) {
      context.handle(
        _wakeUpHourMeta,
        wakeUpHour.isAcceptableOrUnknown(
          data['wake_up_hour']!,
          _wakeUpHourMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uuid};
  @override
  UserSettingsEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSettingsEntity(
      uuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uuid'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      dailyGoal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}daily_goal'],
      )!,
      reminderEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reminder_enabled'],
      )!,
      reminderInterval: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_interval'],
      )!,
      bedTimeHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bed_time_hour'],
      )!,
      wakeUpHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wake_up_hour'],
      )!,
    );
  }

  @override
  $UserSettingsTableTable createAlias(String alias) {
    return $UserSettingsTableTable(attachedDatabase, alias);
  }
}

class UserSettingsEntity extends DataClass
    implements Insertable<UserSettingsEntity> {
  final String uuid;
  final DateTime createdAt;
  final DateTime? deletedAt;
  final double dailyGoal;
  final bool reminderEnabled;
  final int reminderInterval;
  final int bedTimeHour;
  final int wakeUpHour;
  const UserSettingsEntity({
    required this.uuid,
    required this.createdAt,
    this.deletedAt,
    required this.dailyGoal,
    required this.reminderEnabled,
    required this.reminderInterval,
    required this.bedTimeHour,
    required this.wakeUpHour,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uuid'] = Variable<String>(uuid);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    map['daily_goal'] = Variable<double>(dailyGoal);
    map['reminder_enabled'] = Variable<bool>(reminderEnabled);
    map['reminder_interval'] = Variable<int>(reminderInterval);
    map['bed_time_hour'] = Variable<int>(bedTimeHour);
    map['wake_up_hour'] = Variable<int>(wakeUpHour);
    return map;
  }

  UserSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return UserSettingsTableCompanion(
      uuid: Value(uuid),
      createdAt: Value(createdAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      dailyGoal: Value(dailyGoal),
      reminderEnabled: Value(reminderEnabled),
      reminderInterval: Value(reminderInterval),
      bedTimeHour: Value(bedTimeHour),
      wakeUpHour: Value(wakeUpHour),
    );
  }

  factory UserSettingsEntity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSettingsEntity(
      uuid: serializer.fromJson<String>(json['uuid']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
      dailyGoal: serializer.fromJson<double>(json['dailyGoal']),
      reminderEnabled: serializer.fromJson<bool>(json['reminderEnabled']),
      reminderInterval: serializer.fromJson<int>(json['reminderInterval']),
      bedTimeHour: serializer.fromJson<int>(json['bedTimeHour']),
      wakeUpHour: serializer.fromJson<int>(json['wakeUpHour']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uuid': serializer.toJson<String>(uuid),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
      'dailyGoal': serializer.toJson<double>(dailyGoal),
      'reminderEnabled': serializer.toJson<bool>(reminderEnabled),
      'reminderInterval': serializer.toJson<int>(reminderInterval),
      'bedTimeHour': serializer.toJson<int>(bedTimeHour),
      'wakeUpHour': serializer.toJson<int>(wakeUpHour),
    };
  }

  UserSettingsEntity copyWith({
    String? uuid,
    DateTime? createdAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    double? dailyGoal,
    bool? reminderEnabled,
    int? reminderInterval,
    int? bedTimeHour,
    int? wakeUpHour,
  }) => UserSettingsEntity(
    uuid: uuid ?? this.uuid,
    createdAt: createdAt ?? this.createdAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    dailyGoal: dailyGoal ?? this.dailyGoal,
    reminderEnabled: reminderEnabled ?? this.reminderEnabled,
    reminderInterval: reminderInterval ?? this.reminderInterval,
    bedTimeHour: bedTimeHour ?? this.bedTimeHour,
    wakeUpHour: wakeUpHour ?? this.wakeUpHour,
  );
  UserSettingsEntity copyWithCompanion(UserSettingsTableCompanion data) {
    return UserSettingsEntity(
      uuid: data.uuid.present ? data.uuid.value : this.uuid,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      dailyGoal: data.dailyGoal.present ? data.dailyGoal.value : this.dailyGoal,
      reminderEnabled: data.reminderEnabled.present
          ? data.reminderEnabled.value
          : this.reminderEnabled,
      reminderInterval: data.reminderInterval.present
          ? data.reminderInterval.value
          : this.reminderInterval,
      bedTimeHour: data.bedTimeHour.present
          ? data.bedTimeHour.value
          : this.bedTimeHour,
      wakeUpHour: data.wakeUpHour.present
          ? data.wakeUpHour.value
          : this.wakeUpHour,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsEntity(')
          ..write('uuid: $uuid, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('dailyGoal: $dailyGoal, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('reminderInterval: $reminderInterval, ')
          ..write('bedTimeHour: $bedTimeHour, ')
          ..write('wakeUpHour: $wakeUpHour')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    uuid,
    createdAt,
    deletedAt,
    dailyGoal,
    reminderEnabled,
    reminderInterval,
    bedTimeHour,
    wakeUpHour,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSettingsEntity &&
          other.uuid == this.uuid &&
          other.createdAt == this.createdAt &&
          other.deletedAt == this.deletedAt &&
          other.dailyGoal == this.dailyGoal &&
          other.reminderEnabled == this.reminderEnabled &&
          other.reminderInterval == this.reminderInterval &&
          other.bedTimeHour == this.bedTimeHour &&
          other.wakeUpHour == this.wakeUpHour);
}

class UserSettingsTableCompanion extends UpdateCompanion<UserSettingsEntity> {
  final Value<String> uuid;
  final Value<DateTime> createdAt;
  final Value<DateTime?> deletedAt;
  final Value<double> dailyGoal;
  final Value<bool> reminderEnabled;
  final Value<int> reminderInterval;
  final Value<int> bedTimeHour;
  final Value<int> wakeUpHour;
  final Value<int> rowid;
  const UserSettingsTableCompanion({
    this.uuid = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.dailyGoal = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.reminderInterval = const Value.absent(),
    this.bedTimeHour = const Value.absent(),
    this.wakeUpHour = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserSettingsTableCompanion.insert({
    required String uuid,
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.dailyGoal = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.reminderInterval = const Value.absent(),
    this.bedTimeHour = const Value.absent(),
    this.wakeUpHour = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : uuid = Value(uuid);
  static Insertable<UserSettingsEntity> custom({
    Expression<String>? uuid,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? deletedAt,
    Expression<double>? dailyGoal,
    Expression<bool>? reminderEnabled,
    Expression<int>? reminderInterval,
    Expression<int>? bedTimeHour,
    Expression<int>? wakeUpHour,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uuid != null) 'uuid': uuid,
      if (createdAt != null) 'created_at': createdAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (dailyGoal != null) 'daily_goal': dailyGoal,
      if (reminderEnabled != null) 'reminder_enabled': reminderEnabled,
      if (reminderInterval != null) 'reminder_interval': reminderInterval,
      if (bedTimeHour != null) 'bed_time_hour': bedTimeHour,
      if (wakeUpHour != null) 'wake_up_hour': wakeUpHour,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserSettingsTableCompanion copyWith({
    Value<String>? uuid,
    Value<DateTime>? createdAt,
    Value<DateTime?>? deletedAt,
    Value<double>? dailyGoal,
    Value<bool>? reminderEnabled,
    Value<int>? reminderInterval,
    Value<int>? bedTimeHour,
    Value<int>? wakeUpHour,
    Value<int>? rowid,
  }) {
    return UserSettingsTableCompanion(
      uuid: uuid ?? this.uuid,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderInterval: reminderInterval ?? this.reminderInterval,
      bedTimeHour: bedTimeHour ?? this.bedTimeHour,
      wakeUpHour: wakeUpHour ?? this.wakeUpHour,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uuid.present) {
      map['uuid'] = Variable<String>(uuid.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (dailyGoal.present) {
      map['daily_goal'] = Variable<double>(dailyGoal.value);
    }
    if (reminderEnabled.present) {
      map['reminder_enabled'] = Variable<bool>(reminderEnabled.value);
    }
    if (reminderInterval.present) {
      map['reminder_interval'] = Variable<int>(reminderInterval.value);
    }
    if (bedTimeHour.present) {
      map['bed_time_hour'] = Variable<int>(bedTimeHour.value);
    }
    if (wakeUpHour.present) {
      map['wake_up_hour'] = Variable<int>(wakeUpHour.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsTableCompanion(')
          ..write('uuid: $uuid, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('dailyGoal: $dailyGoal, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('reminderInterval: $reminderInterval, ')
          ..write('bedTimeHour: $bedTimeHour, ')
          ..write('wakeUpHour: $wakeUpHour, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $HydrationLogsTable hydrationLogs = $HydrationLogsTable(this);
  late final $UserSettingsTableTable userSettingsTable =
      $UserSettingsTableTable(this);
  late final HydrationDao hydrationDao = HydrationDao(this as AppDatabase);
  late final SettingsDao settingsDao = SettingsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    hydrationLogs,
    userSettingsTable,
  ];
}

typedef $$HydrationLogsTableCreateCompanionBuilder =
    HydrationLogsCompanion Function({
      required String uuid,
      Value<DateTime> createdAt,
      Value<DateTime?> deletedAt,
      required double amount,
      required DateTime timestamp,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$HydrationLogsTableUpdateCompanionBuilder =
    HydrationLogsCompanion Function({
      Value<String> uuid,
      Value<DateTime> createdAt,
      Value<DateTime?> deletedAt,
      Value<double> amount,
      Value<DateTime> timestamp,
      Value<String?> note,
      Value<int> rowid,
    });

class $$HydrationLogsTableFilterComposer
    extends Composer<_$AppDatabase, $HydrationLogsTable> {
  $$HydrationLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$HydrationLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $HydrationLogsTable> {
  $$HydrationLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$HydrationLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HydrationLogsTable> {
  $$HydrationLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$HydrationLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HydrationLogsTable,
          HydrationLogEntity,
          $$HydrationLogsTableFilterComposer,
          $$HydrationLogsTableOrderingComposer,
          $$HydrationLogsTableAnnotationComposer,
          $$HydrationLogsTableCreateCompanionBuilder,
          $$HydrationLogsTableUpdateCompanionBuilder,
          (
            HydrationLogEntity,
            BaseReferences<
              _$AppDatabase,
              $HydrationLogsTable,
              HydrationLogEntity
            >,
          ),
          HydrationLogEntity,
          PrefetchHooks Function()
        > {
  $$HydrationLogsTableTableManager(_$AppDatabase db, $HydrationLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HydrationLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HydrationLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HydrationLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> uuid = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HydrationLogsCompanion(
                uuid: uuid,
                createdAt: createdAt,
                deletedAt: deletedAt,
                amount: amount,
                timestamp: timestamp,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String uuid,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                required double amount,
                required DateTime timestamp,
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => HydrationLogsCompanion.insert(
                uuid: uuid,
                createdAt: createdAt,
                deletedAt: deletedAt,
                amount: amount,
                timestamp: timestamp,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$HydrationLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HydrationLogsTable,
      HydrationLogEntity,
      $$HydrationLogsTableFilterComposer,
      $$HydrationLogsTableOrderingComposer,
      $$HydrationLogsTableAnnotationComposer,
      $$HydrationLogsTableCreateCompanionBuilder,
      $$HydrationLogsTableUpdateCompanionBuilder,
      (
        HydrationLogEntity,
        BaseReferences<_$AppDatabase, $HydrationLogsTable, HydrationLogEntity>,
      ),
      HydrationLogEntity,
      PrefetchHooks Function()
    >;
typedef $$UserSettingsTableTableCreateCompanionBuilder =
    UserSettingsTableCompanion Function({
      required String uuid,
      Value<DateTime> createdAt,
      Value<DateTime?> deletedAt,
      Value<double> dailyGoal,
      Value<bool> reminderEnabled,
      Value<int> reminderInterval,
      Value<int> bedTimeHour,
      Value<int> wakeUpHour,
      Value<int> rowid,
    });
typedef $$UserSettingsTableTableUpdateCompanionBuilder =
    UserSettingsTableCompanion Function({
      Value<String> uuid,
      Value<DateTime> createdAt,
      Value<DateTime?> deletedAt,
      Value<double> dailyGoal,
      Value<bool> reminderEnabled,
      Value<int> reminderInterval,
      Value<int> bedTimeHour,
      Value<int> wakeUpHour,
      Value<int> rowid,
    });

class $$UserSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get dailyGoal => $composableBuilder(
    column: $table.dailyGoal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderInterval => $composableBuilder(
    column: $table.reminderInterval,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get bedTimeHour => $composableBuilder(
    column: $table.bedTimeHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wakeUpHour => $composableBuilder(
    column: $table.wakeUpHour,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uuid => $composableBuilder(
    column: $table.uuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get dailyGoal => $composableBuilder(
    column: $table.dailyGoal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderInterval => $composableBuilder(
    column: $table.reminderInterval,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get bedTimeHour => $composableBuilder(
    column: $table.bedTimeHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wakeUpHour => $composableBuilder(
    column: $table.wakeUpHour,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserSettingsTableTable> {
  $$UserSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uuid =>
      $composableBuilder(column: $table.uuid, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<double> get dailyGoal =>
      $composableBuilder(column: $table.dailyGoal, builder: (column) => column);

  GeneratedColumn<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderInterval => $composableBuilder(
    column: $table.reminderInterval,
    builder: (column) => column,
  );

  GeneratedColumn<int> get bedTimeHour => $composableBuilder(
    column: $table.bedTimeHour,
    builder: (column) => column,
  );

  GeneratedColumn<int> get wakeUpHour => $composableBuilder(
    column: $table.wakeUpHour,
    builder: (column) => column,
  );
}

class $$UserSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserSettingsTableTable,
          UserSettingsEntity,
          $$UserSettingsTableTableFilterComposer,
          $$UserSettingsTableTableOrderingComposer,
          $$UserSettingsTableTableAnnotationComposer,
          $$UserSettingsTableTableCreateCompanionBuilder,
          $$UserSettingsTableTableUpdateCompanionBuilder,
          (
            UserSettingsEntity,
            BaseReferences<
              _$AppDatabase,
              $UserSettingsTableTable,
              UserSettingsEntity
            >,
          ),
          UserSettingsEntity,
          PrefetchHooks Function()
        > {
  $$UserSettingsTableTableTableManager(
    _$AppDatabase db,
    $UserSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserSettingsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> uuid = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<double> dailyGoal = const Value.absent(),
                Value<bool> reminderEnabled = const Value.absent(),
                Value<int> reminderInterval = const Value.absent(),
                Value<int> bedTimeHour = const Value.absent(),
                Value<int> wakeUpHour = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserSettingsTableCompanion(
                uuid: uuid,
                createdAt: createdAt,
                deletedAt: deletedAt,
                dailyGoal: dailyGoal,
                reminderEnabled: reminderEnabled,
                reminderInterval: reminderInterval,
                bedTimeHour: bedTimeHour,
                wakeUpHour: wakeUpHour,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String uuid,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<double> dailyGoal = const Value.absent(),
                Value<bool> reminderEnabled = const Value.absent(),
                Value<int> reminderInterval = const Value.absent(),
                Value<int> bedTimeHour = const Value.absent(),
                Value<int> wakeUpHour = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserSettingsTableCompanion.insert(
                uuid: uuid,
                createdAt: createdAt,
                deletedAt: deletedAt,
                dailyGoal: dailyGoal,
                reminderEnabled: reminderEnabled,
                reminderInterval: reminderInterval,
                bedTimeHour: bedTimeHour,
                wakeUpHour: wakeUpHour,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserSettingsTableTable,
      UserSettingsEntity,
      $$UserSettingsTableTableFilterComposer,
      $$UserSettingsTableTableOrderingComposer,
      $$UserSettingsTableTableAnnotationComposer,
      $$UserSettingsTableTableCreateCompanionBuilder,
      $$UserSettingsTableTableUpdateCompanionBuilder,
      (
        UserSettingsEntity,
        BaseReferences<
          _$AppDatabase,
          $UserSettingsTableTable,
          UserSettingsEntity
        >,
      ),
      UserSettingsEntity,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$HydrationLogsTableTableManager get hydrationLogs =>
      $$HydrationLogsTableTableManager(_db, _db.hydrationLogs);
  $$UserSettingsTableTableTableManager get userSettingsTable =>
      $$UserSettingsTableTableTableManager(_db, _db.userSettingsTable);
}
