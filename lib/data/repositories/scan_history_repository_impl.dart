import 'package:drift/drift.dart';
import '../../core/database/app_database.dart';
import '../../domain/models/scan_history_entry.dart';
import '../../domain/repositories/scan_history_repository.dart';

class ScanHistoryRepositoryImpl implements ScanHistoryRepository {
  final AppDatabase _db;

  ScanHistoryRepositoryImpl(this._db);

  @override
  Future<void> saveResult({
    required String orderNumber,
    required String barcode,
    required bool isCorrect,
    String? errorCode,
  }) async {
    await _db.into(_db.scanHistories).insert(
      ScanHistoriesCompanion.insert(
        orderNumber: orderNumber,
        materialBarcode: barcode,
        isCorrect: isCorrect,
        errorCode: Value(errorCode),
      ),
    );
  }

  @override
  Future<List<ScanHistoryEntry>> getAllHistory() async {
    final results = await (_db.select(_db.scanHistories)
          ..orderBy([(t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc)]))
        .get();

    return results.map((row) => ScanHistoryEntry(
      id: row.id,
      orderNumber: row.orderNumber,
      materialBarcode: row.materialBarcode,
      isCorrect: row.isCorrect,
      timestamp: row.timestamp,
      errorCode: row.errorCode,
    )).toList();
  }

  @override
  Stream<List<ScanHistoryEntry>> watchAllHistory() {
    return (_db.select(_db.scanHistories)
          ..orderBy([(t) => OrderingTerm(expression: t.timestamp, mode: OrderingMode.desc)]))
        .watch()
        .map((rows) => rows.map((row) => ScanHistoryEntry(
              id: row.id,
              orderNumber: row.orderNumber,
              materialBarcode: row.materialBarcode,
              isCorrect: row.isCorrect,
              timestamp: row.timestamp,
              errorCode: row.errorCode,
            )).toList());
  }

  @override
  Future<void> clearHistory() async {
    await _db.delete(_db.scanHistories).go();
  }
}
