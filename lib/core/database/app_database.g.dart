// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ScanHistoriesTable extends ScanHistories
    with TableInfo<$ScanHistoriesTable, ScanHistory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScanHistoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _orderNumberMeta = const VerificationMeta(
    'orderNumber',
  );
  @override
  late final GeneratedColumn<String> orderNumber = GeneratedColumn<String>(
    'order_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _materialBarcodeMeta = const VerificationMeta(
    'materialBarcode',
  );
  @override
  late final GeneratedColumn<String> materialBarcode = GeneratedColumn<String>(
    'material_barcode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCorrectMeta = const VerificationMeta(
    'isCorrect',
  );
  @override
  late final GeneratedColumn<bool> isCorrect = GeneratedColumn<bool>(
    'is_correct',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_correct" IN (0, 1))',
    ),
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
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _errorCodeMeta = const VerificationMeta(
    'errorCode',
  );
  @override
  late final GeneratedColumn<String> errorCode = GeneratedColumn<String>(
    'error_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orderNumber,
    materialBarcode,
    isCorrect,
    timestamp,
    errorCode,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'scan_histories';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScanHistory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_number')) {
      context.handle(
        _orderNumberMeta,
        orderNumber.isAcceptableOrUnknown(
          data['order_number']!,
          _orderNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_orderNumberMeta);
    }
    if (data.containsKey('material_barcode')) {
      context.handle(
        _materialBarcodeMeta,
        materialBarcode.isAcceptableOrUnknown(
          data['material_barcode']!,
          _materialBarcodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_materialBarcodeMeta);
    }
    if (data.containsKey('is_correct')) {
      context.handle(
        _isCorrectMeta,
        isCorrect.isAcceptableOrUnknown(data['is_correct']!, _isCorrectMeta),
      );
    } else if (isInserting) {
      context.missing(_isCorrectMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    }
    if (data.containsKey('error_code')) {
      context.handle(
        _errorCodeMeta,
        errorCode.isAcceptableOrUnknown(data['error_code']!, _errorCodeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScanHistory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScanHistory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      orderNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_number'],
      )!,
      materialBarcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}material_barcode'],
      )!,
      isCorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_correct'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      errorCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_code'],
      ),
    );
  }

  @override
  $ScanHistoriesTable createAlias(String alias) {
    return $ScanHistoriesTable(attachedDatabase, alias);
  }
}

class ScanHistory extends DataClass implements Insertable<ScanHistory> {
  final int id;
  final String orderNumber;
  final String materialBarcode;
  final bool isCorrect;
  final DateTime timestamp;
  final String? errorCode;
  const ScanHistory({
    required this.id,
    required this.orderNumber,
    required this.materialBarcode,
    required this.isCorrect,
    required this.timestamp,
    this.errorCode,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_number'] = Variable<String>(orderNumber);
    map['material_barcode'] = Variable<String>(materialBarcode);
    map['is_correct'] = Variable<bool>(isCorrect);
    map['timestamp'] = Variable<DateTime>(timestamp);
    if (!nullToAbsent || errorCode != null) {
      map['error_code'] = Variable<String>(errorCode);
    }
    return map;
  }

  ScanHistoriesCompanion toCompanion(bool nullToAbsent) {
    return ScanHistoriesCompanion(
      id: Value(id),
      orderNumber: Value(orderNumber),
      materialBarcode: Value(materialBarcode),
      isCorrect: Value(isCorrect),
      timestamp: Value(timestamp),
      errorCode: errorCode == null && nullToAbsent
          ? const Value.absent()
          : Value(errorCode),
    );
  }

  factory ScanHistory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScanHistory(
      id: serializer.fromJson<int>(json['id']),
      orderNumber: serializer.fromJson<String>(json['orderNumber']),
      materialBarcode: serializer.fromJson<String>(json['materialBarcode']),
      isCorrect: serializer.fromJson<bool>(json['isCorrect']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      errorCode: serializer.fromJson<String?>(json['errorCode']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderNumber': serializer.toJson<String>(orderNumber),
      'materialBarcode': serializer.toJson<String>(materialBarcode),
      'isCorrect': serializer.toJson<bool>(isCorrect),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'errorCode': serializer.toJson<String?>(errorCode),
    };
  }

  ScanHistory copyWith({
    int? id,
    String? orderNumber,
    String? materialBarcode,
    bool? isCorrect,
    DateTime? timestamp,
    Value<String?> errorCode = const Value.absent(),
  }) => ScanHistory(
    id: id ?? this.id,
    orderNumber: orderNumber ?? this.orderNumber,
    materialBarcode: materialBarcode ?? this.materialBarcode,
    isCorrect: isCorrect ?? this.isCorrect,
    timestamp: timestamp ?? this.timestamp,
    errorCode: errorCode.present ? errorCode.value : this.errorCode,
  );
  ScanHistory copyWithCompanion(ScanHistoriesCompanion data) {
    return ScanHistory(
      id: data.id.present ? data.id.value : this.id,
      orderNumber: data.orderNumber.present
          ? data.orderNumber.value
          : this.orderNumber,
      materialBarcode: data.materialBarcode.present
          ? data.materialBarcode.value
          : this.materialBarcode,
      isCorrect: data.isCorrect.present ? data.isCorrect.value : this.isCorrect,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      errorCode: data.errorCode.present ? data.errorCode.value : this.errorCode,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScanHistory(')
          ..write('id: $id, ')
          ..write('orderNumber: $orderNumber, ')
          ..write('materialBarcode: $materialBarcode, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('timestamp: $timestamp, ')
          ..write('errorCode: $errorCode')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    orderNumber,
    materialBarcode,
    isCorrect,
    timestamp,
    errorCode,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScanHistory &&
          other.id == this.id &&
          other.orderNumber == this.orderNumber &&
          other.materialBarcode == this.materialBarcode &&
          other.isCorrect == this.isCorrect &&
          other.timestamp == this.timestamp &&
          other.errorCode == this.errorCode);
}

class ScanHistoriesCompanion extends UpdateCompanion<ScanHistory> {
  final Value<int> id;
  final Value<String> orderNumber;
  final Value<String> materialBarcode;
  final Value<bool> isCorrect;
  final Value<DateTime> timestamp;
  final Value<String?> errorCode;
  const ScanHistoriesCompanion({
    this.id = const Value.absent(),
    this.orderNumber = const Value.absent(),
    this.materialBarcode = const Value.absent(),
    this.isCorrect = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.errorCode = const Value.absent(),
  });
  ScanHistoriesCompanion.insert({
    this.id = const Value.absent(),
    required String orderNumber,
    required String materialBarcode,
    required bool isCorrect,
    this.timestamp = const Value.absent(),
    this.errorCode = const Value.absent(),
  }) : orderNumber = Value(orderNumber),
       materialBarcode = Value(materialBarcode),
       isCorrect = Value(isCorrect);
  static Insertable<ScanHistory> custom({
    Expression<int>? id,
    Expression<String>? orderNumber,
    Expression<String>? materialBarcode,
    Expression<bool>? isCorrect,
    Expression<DateTime>? timestamp,
    Expression<String>? errorCode,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderNumber != null) 'order_number': orderNumber,
      if (materialBarcode != null) 'material_barcode': materialBarcode,
      if (isCorrect != null) 'is_correct': isCorrect,
      if (timestamp != null) 'timestamp': timestamp,
      if (errorCode != null) 'error_code': errorCode,
    });
  }

  ScanHistoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? orderNumber,
    Value<String>? materialBarcode,
    Value<bool>? isCorrect,
    Value<DateTime>? timestamp,
    Value<String?>? errorCode,
  }) {
    return ScanHistoriesCompanion(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      materialBarcode: materialBarcode ?? this.materialBarcode,
      isCorrect: isCorrect ?? this.isCorrect,
      timestamp: timestamp ?? this.timestamp,
      errorCode: errorCode ?? this.errorCode,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderNumber.present) {
      map['order_number'] = Variable<String>(orderNumber.value);
    }
    if (materialBarcode.present) {
      map['material_barcode'] = Variable<String>(materialBarcode.value);
    }
    if (isCorrect.present) {
      map['is_correct'] = Variable<bool>(isCorrect.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (errorCode.present) {
      map['error_code'] = Variable<String>(errorCode.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScanHistoriesCompanion(')
          ..write('id: $id, ')
          ..write('orderNumber: $orderNumber, ')
          ..write('materialBarcode: $materialBarcode, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('timestamp: $timestamp, ')
          ..write('errorCode: $errorCode')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ScanHistoriesTable scanHistories = $ScanHistoriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [scanHistories];
}

typedef $$ScanHistoriesTableCreateCompanionBuilder =
    ScanHistoriesCompanion Function({
      Value<int> id,
      required String orderNumber,
      required String materialBarcode,
      required bool isCorrect,
      Value<DateTime> timestamp,
      Value<String?> errorCode,
    });
typedef $$ScanHistoriesTableUpdateCompanionBuilder =
    ScanHistoriesCompanion Function({
      Value<int> id,
      Value<String> orderNumber,
      Value<String> materialBarcode,
      Value<bool> isCorrect,
      Value<DateTime> timestamp,
      Value<String?> errorCode,
    });

class $$ScanHistoriesTableFilterComposer
    extends Composer<_$AppDatabase, $ScanHistoriesTable> {
  $$ScanHistoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orderNumber => $composableBuilder(
    column: $table.orderNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get materialBarcode => $composableBuilder(
    column: $table.materialBarcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorCode => $composableBuilder(
    column: $table.errorCode,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ScanHistoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ScanHistoriesTable> {
  $$ScanHistoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orderNumber => $composableBuilder(
    column: $table.orderNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get materialBarcode => $composableBuilder(
    column: $table.materialBarcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorCode => $composableBuilder(
    column: $table.errorCode,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ScanHistoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScanHistoriesTable> {
  $$ScanHistoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get orderNumber => $composableBuilder(
    column: $table.orderNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get materialBarcode => $composableBuilder(
    column: $table.materialBarcode,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCorrect =>
      $composableBuilder(column: $table.isCorrect, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get errorCode =>
      $composableBuilder(column: $table.errorCode, builder: (column) => column);
}

class $$ScanHistoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScanHistoriesTable,
          ScanHistory,
          $$ScanHistoriesTableFilterComposer,
          $$ScanHistoriesTableOrderingComposer,
          $$ScanHistoriesTableAnnotationComposer,
          $$ScanHistoriesTableCreateCompanionBuilder,
          $$ScanHistoriesTableUpdateCompanionBuilder,
          (
            ScanHistory,
            BaseReferences<_$AppDatabase, $ScanHistoriesTable, ScanHistory>,
          ),
          ScanHistory,
          PrefetchHooks Function()
        > {
  $$ScanHistoriesTableTableManager(_$AppDatabase db, $ScanHistoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScanHistoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScanHistoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScanHistoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> orderNumber = const Value.absent(),
                Value<String> materialBarcode = const Value.absent(),
                Value<bool> isCorrect = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<String?> errorCode = const Value.absent(),
              }) => ScanHistoriesCompanion(
                id: id,
                orderNumber: orderNumber,
                materialBarcode: materialBarcode,
                isCorrect: isCorrect,
                timestamp: timestamp,
                errorCode: errorCode,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String orderNumber,
                required String materialBarcode,
                required bool isCorrect,
                Value<DateTime> timestamp = const Value.absent(),
                Value<String?> errorCode = const Value.absent(),
              }) => ScanHistoriesCompanion.insert(
                id: id,
                orderNumber: orderNumber,
                materialBarcode: materialBarcode,
                isCorrect: isCorrect,
                timestamp: timestamp,
                errorCode: errorCode,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ScanHistoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScanHistoriesTable,
      ScanHistory,
      $$ScanHistoriesTableFilterComposer,
      $$ScanHistoriesTableOrderingComposer,
      $$ScanHistoriesTableAnnotationComposer,
      $$ScanHistoriesTableCreateCompanionBuilder,
      $$ScanHistoriesTableUpdateCompanionBuilder,
      (
        ScanHistory,
        BaseReferences<_$AppDatabase, $ScanHistoriesTable, ScanHistory>,
      ),
      ScanHistory,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ScanHistoriesTableTableManager get scanHistories =>
      $$ScanHistoriesTableTableManager(_db, _db.scanHistories);
}
