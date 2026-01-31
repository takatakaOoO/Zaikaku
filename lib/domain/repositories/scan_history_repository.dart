import '../models/scan_history_entry.dart';

abstract class ScanHistoryRepository {
  Future<void> saveResult({
    required String orderNumber,
    required String barcode,
    required bool isCorrect,
    String? errorCode,
  });

  Future<List<ScanHistoryEntry>> getAllHistory();

  Stream<List<ScanHistoryEntry>> watchAllHistory();
  
  Future<void> clearHistory();
}
