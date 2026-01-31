import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../domain/models/scan_history_entry.dart';

/// スキャン履歴をCSV形式でエクスポートするユースケース
class ExportHistoryUseCase {
  /// 履歴リストをCSV文字列に変換
  String generateCsvContent(List<ScanHistoryEntry> history) {
    // BOM付きUTF-8 (Excelで文字化けを防ぐ)
    const bom = '\uFEFF';
    final buffer = StringBuffer(bom);

    // ヘッダー行
    buffer.writeln('日時,製品/指示番号,スキャンバーコード,結果,エラーコード');

    // データ行
    final dateFormat = DateFormat('yyyy/MM/dd HH:mm:ss');
    for (final entry in history) {
      final timestamp = dateFormat.format(entry.timestamp);
      final orderNumber = _escapeCsvField(entry.orderNumber);
      final barcode = _escapeCsvField(entry.materialBarcode);
      final result = entry.isCorrect ? 'OK' : 'NG';
      final errorCode = entry.errorCode != null ? _escapeCsvField(entry.errorCode!) : '';

      buffer.writeln('$timestamp,$orderNumber,$barcode,$result,$errorCode');
    }

    return buffer.toString();
  }

  /// CSVフィールドのエスケープ処理
  /// カンマ、ダブルクォート、改行が含まれる場合はダブルクォートで囲む
  String _escapeCsvField(String field) {
    if (field.contains(',') || field.contains('"') || field.contains('\n')) {
      // ダブルクォートを二重にエスケープ
      final escaped = field.replaceAll('"', '""');
      return '"$escaped"';
    }
    return field;
  }

  /// CSVを一時ファイルとして保存し、パスを返す
  Future<File> saveToTempFile(List<ScanHistoryEntry> history) async {
    final csvContent = generateCsvContent(history);
    final directory = await getTemporaryDirectory();
    final dateStr = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final file = File('${directory.path}/scan_history_$dateStr.csv');
    await file.writeAsString(csvContent);
    return file;
  }
}
