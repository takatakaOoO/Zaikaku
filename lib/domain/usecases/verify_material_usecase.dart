import '../models/manufacturing_order.dart';
import '../models/verification_result.dart';

/// 材料照合のユースケース
/// 
/// スキャンされたバーコードが製造指示書の必要材料リストに含まれているかチェックします。
class VerifyMaterialUseCase {
  /// 材料照合を実行
  /// 
  /// [scannedBarcode] スキャンされたバーコード
  /// [order] 現在の製造指示書
  /// 
  /// 戻り値: 照合結果
  VerificationResult execute(String scannedBarcode, ManufacturingOrder order) {
    final timestamp = DateTime.now();

    // バーコードが空の場合
    if (scannedBarcode.isEmpty) {
      return VerificationResult(
        scannedBarcode: scannedBarcode,
        status: VerificationStatus.notFound,
        message: 'バーコードが読み取れませんでした',
        timestamp: timestamp,
      );
    }

    // 製造指示書の必要材料リストに含まれているかチェック
    if (order.containsMaterial(scannedBarcode)) {
      return VerificationResult(
        scannedBarcode: scannedBarcode,
        status: VerificationStatus.correct,
        message: '正解！正しい材料です',
        timestamp: timestamp,
      );
    } else {
      return VerificationResult(
        scannedBarcode: scannedBarcode,
        status: VerificationStatus.incorrect,
        message: '不正解！この材料は必要ありません',
        timestamp: timestamp,
      );
    }
  }
}
