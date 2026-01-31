/// 照合結果のステータス
enum VerificationStatus {
  /// 正解 - スキャンされたバーコードが必要材料リストに含まれている
  correct,
  
  /// 不正解 - スキャンされたバーコードが必要材料リストに含まれていない
  incorrect,
  
  /// 見つからない - バーコードがシステムに登録されていない
  notFound,
}

/// 照合結果のデータモデル
/// 
/// バーコードスキャンの照合結果を保持します。
class VerificationResult {
  /// スキャンされたバーコード
  final String scannedBarcode;
  
  /// 照合ステータス
  final VerificationStatus status;
  
  /// メッセージ（オプション）
  final String? message;
  
  /// タイムスタンプ
  final DateTime timestamp;

  const VerificationResult({
    required this.scannedBarcode,
    required this.status,
    this.message,
    required this.timestamp,
  });

  /// 正解かどうか
  bool get isCorrect => status == VerificationStatus.correct;

  /// 不正解かどうか
  bool get isIncorrect => status == VerificationStatus.incorrect;

  /// 見つからないかどうか
  bool get isNotFound => status == VerificationStatus.notFound;

  /// コピーを作成
  VerificationResult copyWith({
    String? scannedBarcode,
    VerificationStatus? status,
    String? message,
    DateTime? timestamp,
  }) {
    return VerificationResult(
      scannedBarcode: scannedBarcode ?? this.scannedBarcode,
      status: status ?? this.status,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
