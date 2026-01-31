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

class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modelNumberMeta = const VerificationMeta(
    'modelNumber',
  );
  @override
  late final GeneratedColumn<String> modelNumber = GeneratedColumn<String>(
    'model_number',
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
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    modelNumber,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('model_number')) {
      context.handle(
        _modelNumberMeta,
        modelNumber.isAcceptableOrUnknown(
          data['model_number']!,
          _modelNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_modelNumberMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      modelNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model_number'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final int id;
  final String name;
  final String modelNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Product({
    required this.id,
    required this.name,
    required this.modelNumber,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['model_number'] = Variable<String>(modelNumber);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      modelNumber: Value(modelNumber),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      modelNumber: serializer.fromJson<String>(json['modelNumber']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'modelNumber': serializer.toJson<String>(modelNumber),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Product copyWith({
    int? id,
    String? name,
    String? modelNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Product(
    id: id ?? this.id,
    name: name ?? this.name,
    modelNumber: modelNumber ?? this.modelNumber,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      modelNumber: data.modelNumber.present
          ? data.modelNumber.value
          : this.modelNumber,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('modelNumber: $modelNumber, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, modelNumber, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.name == this.name &&
          other.modelNumber == this.modelNumber &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> modelNumber;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.modelNumber = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String modelNumber,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : name = Value(name),
       modelNumber = Value(modelNumber);
  static Insertable<Product> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? modelNumber,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (modelNumber != null) 'model_number': modelNumber,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ProductsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? modelNumber,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      modelNumber: modelNumber ?? this.modelNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (modelNumber.present) {
      map['model_number'] = Variable<String>(modelNumber.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('modelNumber: $modelNumber, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ProductMaterialsTable extends ProductMaterials
    with TableInfo<$ProductMaterialsTable, ProductMaterial> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductMaterialsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<int> productId = GeneratedColumn<int>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
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
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, productId, barcode, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_materials';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductMaterial> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    } else if (isInserting) {
      context.missing(_barcodeMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductMaterial map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductMaterial(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}product_id'],
      )!,
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProductMaterialsTable createAlias(String alias) {
    return $ProductMaterialsTable(attachedDatabase, alias);
  }
}

class ProductMaterial extends DataClass implements Insertable<ProductMaterial> {
  final int id;
  final int productId;
  final String barcode;
  final DateTime createdAt;
  const ProductMaterial({
    required this.id,
    required this.productId,
    required this.barcode,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['product_id'] = Variable<int>(productId);
    map['barcode'] = Variable<String>(barcode);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProductMaterialsCompanion toCompanion(bool nullToAbsent) {
    return ProductMaterialsCompanion(
      id: Value(id),
      productId: Value(productId),
      barcode: Value(barcode),
      createdAt: Value(createdAt),
    );
  }

  factory ProductMaterial.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductMaterial(
      id: serializer.fromJson<int>(json['id']),
      productId: serializer.fromJson<int>(json['productId']),
      barcode: serializer.fromJson<String>(json['barcode']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'productId': serializer.toJson<int>(productId),
      'barcode': serializer.toJson<String>(barcode),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ProductMaterial copyWith({
    int? id,
    int? productId,
    String? barcode,
    DateTime? createdAt,
  }) => ProductMaterial(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    barcode: barcode ?? this.barcode,
    createdAt: createdAt ?? this.createdAt,
  );
  ProductMaterial copyWithCompanion(ProductMaterialsCompanion data) {
    return ProductMaterial(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductMaterial(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('barcode: $barcode, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, productId, barcode, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductMaterial &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.barcode == this.barcode &&
          other.createdAt == this.createdAt);
}

class ProductMaterialsCompanion extends UpdateCompanion<ProductMaterial> {
  final Value<int> id;
  final Value<int> productId;
  final Value<String> barcode;
  final Value<DateTime> createdAt;
  const ProductMaterialsCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.barcode = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ProductMaterialsCompanion.insert({
    this.id = const Value.absent(),
    required int productId,
    required String barcode,
    this.createdAt = const Value.absent(),
  }) : productId = Value(productId),
       barcode = Value(barcode);
  static Insertable<ProductMaterial> custom({
    Expression<int>? id,
    Expression<int>? productId,
    Expression<String>? barcode,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (barcode != null) 'barcode': barcode,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProductMaterialsCompanion copyWith({
    Value<int>? id,
    Value<int>? productId,
    Value<String>? barcode,
    Value<DateTime>? createdAt,
  }) {
    return ProductMaterialsCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      barcode: barcode ?? this.barcode,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<int>(productId.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductMaterialsCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('barcode: $barcode, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ScanHistoriesTable scanHistories = $ScanHistoriesTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $ProductMaterialsTable productMaterials = $ProductMaterialsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    scanHistories,
    products,
    productMaterials,
  ];
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
typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      Value<int> id,
      required String name,
      required String modelNumber,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> modelNumber,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$ProductsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTable, Product> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ProductMaterialsTable, List<ProductMaterial>>
  _productMaterialsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.productMaterials,
    aliasName: $_aliasNameGenerator(
      db.products.id,
      db.productMaterials.productId,
    ),
  );

  $$ProductMaterialsTableProcessedTableManager get productMaterialsRefs {
    final manager = $$ProductMaterialsTableTableManager(
      $_db,
      $_db.productMaterials,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _productMaterialsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get modelNumber => $composableBuilder(
    column: $table.modelNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> productMaterialsRefs(
    Expression<bool> Function($$ProductMaterialsTableFilterComposer f) f,
  ) {
    final $$ProductMaterialsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productMaterials,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductMaterialsTableFilterComposer(
            $db: $db,
            $table: $db.productMaterials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get modelNumber => $composableBuilder(
    column: $table.modelNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get modelNumber => $composableBuilder(
    column: $table.modelNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> productMaterialsRefs<T extends Object>(
    Expression<T> Function($$ProductMaterialsTableAnnotationComposer a) f,
  ) {
    final $$ProductMaterialsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.productMaterials,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductMaterialsTableAnnotationComposer(
            $db: $db,
            $table: $db.productMaterials,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, $$ProductsTableReferences),
          Product,
          PrefetchHooks Function({bool productMaterialsRefs})
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> modelNumber = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                name: name,
                modelNumber: modelNumber,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String modelNumber,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                name: name,
                modelNumber: modelNumber,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productMaterialsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (productMaterialsRefs) db.productMaterials,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (productMaterialsRefs)
                    await $_getPrefetchedData<
                      Product,
                      $ProductsTable,
                      ProductMaterial
                    >(
                      currentTable: table,
                      referencedTable: $$ProductsTableReferences
                          ._productMaterialsRefsTable(db),
                      managerFromTypedResult: (p0) => $$ProductsTableReferences(
                        db,
                        table,
                        p0,
                      ).productMaterialsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.productId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, $$ProductsTableReferences),
      Product,
      PrefetchHooks Function({bool productMaterialsRefs})
    >;
typedef $$ProductMaterialsTableCreateCompanionBuilder =
    ProductMaterialsCompanion Function({
      Value<int> id,
      required int productId,
      required String barcode,
      Value<DateTime> createdAt,
    });
typedef $$ProductMaterialsTableUpdateCompanionBuilder =
    ProductMaterialsCompanion Function({
      Value<int> id,
      Value<int> productId,
      Value<String> barcode,
      Value<DateTime> createdAt,
    });

final class $$ProductMaterialsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ProductMaterialsTable, ProductMaterial> {
  $$ProductMaterialsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias(
        $_aliasNameGenerator(db.productMaterials.productId, db.products.id),
      );

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<int>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProductMaterialsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductMaterialsTable> {
  $$ProductMaterialsTableFilterComposer({
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

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductMaterialsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductMaterialsTable> {
  $$ProductMaterialsTableOrderingComposer({
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

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductMaterialsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductMaterialsTable> {
  $$ProductMaterialsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProductMaterialsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductMaterialsTable,
          ProductMaterial,
          $$ProductMaterialsTableFilterComposer,
          $$ProductMaterialsTableOrderingComposer,
          $$ProductMaterialsTableAnnotationComposer,
          $$ProductMaterialsTableCreateCompanionBuilder,
          $$ProductMaterialsTableUpdateCompanionBuilder,
          (ProductMaterial, $$ProductMaterialsTableReferences),
          ProductMaterial,
          PrefetchHooks Function({bool productId})
        > {
  $$ProductMaterialsTableTableManager(
    _$AppDatabase db,
    $ProductMaterialsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductMaterialsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductMaterialsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductMaterialsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> productId = const Value.absent(),
                Value<String> barcode = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProductMaterialsCompanion(
                id: id,
                productId: productId,
                barcode: barcode,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int productId,
                required String barcode,
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProductMaterialsCompanion.insert(
                id: id,
                productId: productId,
                barcode: barcode,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductMaterialsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable:
                                    $$ProductMaterialsTableReferences
                                        ._productIdTable(db),
                                referencedColumn:
                                    $$ProductMaterialsTableReferences
                                        ._productIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ProductMaterialsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductMaterialsTable,
      ProductMaterial,
      $$ProductMaterialsTableFilterComposer,
      $$ProductMaterialsTableOrderingComposer,
      $$ProductMaterialsTableAnnotationComposer,
      $$ProductMaterialsTableCreateCompanionBuilder,
      $$ProductMaterialsTableUpdateCompanionBuilder,
      (ProductMaterial, $$ProductMaterialsTableReferences),
      ProductMaterial,
      PrefetchHooks Function({bool productId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ScanHistoriesTableTableManager get scanHistories =>
      $$ScanHistoriesTableTableManager(_db, _db.scanHistories);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$ProductMaterialsTableTableManager get productMaterials =>
      $$ProductMaterialsTableTableManager(_db, _db.productMaterials);
}
