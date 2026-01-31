class ScanHistoryEntry {
  final int id;
  final String orderNumber;
  final String materialBarcode;
  final bool isCorrect;
  final DateTime timestamp;
  final String? errorCode;

  ScanHistoryEntry({
    required this.id,
    required this.orderNumber,
    required this.materialBarcode,
    required this.isCorrect,
    required this.timestamp,
    this.errorCode,
  });
}
