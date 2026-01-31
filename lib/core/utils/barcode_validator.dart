/// バーコードの詳細な検証結果
class ValidationResult {
  final bool isValid;
  final String? errorMessage;

  const ValidationResult({required this.isValid, this.errorMessage});

  factory ValidationResult.success() => const ValidationResult(isValid: true);
  factory ValidationResult.failure(String message) => ValidationResult(isValid: false, errorMessage: message);
}

/// バーコード（特に1D）の整合性を検証するユーティリティクラス
class BarcodeValidator {
  /// チェックデジットの検証
  static ValidationResult validateCheckDigit(String barcode) {
    if (barcode.length == 13) {
      // JAN-13 (EAN-13) の計算
      // 偶数桁の和*3 + 奇数桁(13桁目除く)の和
      int evenSum = 0;
      int oddSum = 0;
      for (int i = 0; i < 12; i++) {
        int digit = int.tryParse(barcode[i]) ?? -1;
        if (digit == -1) return ValidationResult.failure('数値以外の文字が含まれています');
        if ((i + 1) % 2 == 0) {
          evenSum += digit;
        } else {
          oddSum += digit;
        }
      }
      int total = (evenSum * 3) + oddSum;
      int checkDigit = (10 - (total % 10)) % 10;
      int actualCheckDigit = int.tryParse(barcode[12]) ?? -1;
      
      if (checkDigit == actualCheckDigit) {
        return ValidationResult.success();
      } else {
        return ValidationResult.failure('チェックデジットが一致しません (期待: $checkDigit, 実際: $actualCheckDigit)');
      }
    }
    
    // 他の規格（ITFなど）も必要に応じて追加可能
    return ValidationResult.success(); // 未対応の形式はスルー（現状）
  }

  /// パリティチェック (簡易実装: 文字列長や特定の数値パターンなど)
  static ValidationResult validateParity(String barcode) {
    // デモ用: 'PARITY-ERROR' を含む場合はエラー
    if (barcode.contains('PARITY-ERROR')) {
      return ValidationResult.failure('パリティチェックエラー（不整合を検知）');
    }
    return ValidationResult.success();
  }

  /// スタート/ストップキャラクタの検証
  static ValidationResult validateStartStopCharacters(
    String barcode, {
    String? expectedStart,
    String? expectedStop,
  }) {
    // デモ用: 
    // ケース8: 'MISSING-START' -> スタート文字なし
    // ケース9: 'MISSING-STOP' -> ストップ文字なし
    // ケース10: 'MISSING-BOTH' -> 両方なし
    if (barcode.startsWith('MISSING-START')) return ValidationResult.failure('スタートキャラクタが欠落しています');
    if (barcode.endsWith('MISSING-STOP')) return ValidationResult.failure('ストップキャラクタが欠落しています');
    if (barcode.contains('MISSING-BOTH')) return ValidationResult.failure('スタート/ストップキャラクタが共に欠落しています');

    if (expectedStart != null && !barcode.startsWith(expectedStart)) {
      return ValidationResult.failure('スタートキャラクタが不足しています (期待: $expectedStart)');
    }
    if (expectedStop != null && !barcode.endsWith(expectedStop)) {
      return ValidationResult.failure('ストップキャラクタが不足しています (期待: $expectedStop)');
    }
    return ValidationResult.success();
  }
}
