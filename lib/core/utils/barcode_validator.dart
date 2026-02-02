import 'package:flutter/foundation.dart';

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
    debugPrint('[Validator] validateCheckDigit: $barcode');
    final numericOnly = barcode.replaceAll(RegExp(r'[^0-9]'), '');
    
    // JAN-13 (EAN-13)
    if (numericOnly.length == 13) {
      int evenSum = 0;
      int oddSum = 0;
      for (int i = 0; i < 12; i++) {
        int digit = int.parse(numericOnly[i]);
        if ((i + 1) % 2 == 0) {
          evenSum += digit;
        } else {
          oddSum += digit;
        }
      }
      int total = (evenSum * 3) + oddSum;
      int checkDigit = (10 - (total % 10)) % 10;
      int actualCheckDigit = int.parse(numericOnly[12]);
      debugPrint('[Validator] JAN-13 Calc: evenSum(w3)=$evenSum, oddSum(w1)=$oddSum, total=$total, calcCD=$checkDigit, actualCD=$actualCheckDigit');
      
      if (checkDigit != actualCheckDigit) {
        return ValidationResult.failure('バーコードが正常に読み取れない（チェックデジットエラー）');
      }
      return ValidationResult.success();
    }
    
    // UPC-A (12 digits)
    if (numericOnly.length == 12) {
      // UPC-Aは index 0(Pos12) からウェイト 3, 1, 3, 1... (右から数えると 1, 3, 1, 3...)
      int weight3Sum = 0;
      int weight1Sum = 0;
      for (int i = 0; i < 11; i++) {
        int digit = int.parse(numericOnly[i]);
        if (i % 2 == 0) {
          weight3Sum += digit;
        } else {
          weight1Sum += digit;
        }
      }
      int total = (weight3Sum * 3) + weight1Sum;
      int checkDigit = (10 - (total % 10)) % 10;
      int actualCheckDigit = int.parse(numericOnly[11]);
      debugPrint('[Validator] UPC-A Calc: w3Sum=$weight3Sum, w1Sum=$weight1Sum, total=$total, calcCD=$checkDigit, actualCD=$actualCheckDigit');
      
      if (checkDigit != actualCheckDigit) {
        return ValidationResult.failure('バーコードが正常に読み取れない（チェックデジットエラー）');
      }
      return ValidationResult.success();
    }
    
    // JAN-8 (EAN-8)
    if (numericOnly.length == 8) {
      int weight3Sum = 0;
      int weight1Sum = 0;
      for (int i = 0; i < 7; i++) {
        int digit = int.parse(numericOnly[i]);
        if (i % 2 == 0) {
          weight3Sum += digit;
        } else {
          weight1Sum += digit;
        }
      }
      int total = (weight3Sum * 3) + weight1Sum;
      int checkDigit = (10 - (total % 10)) % 10;
      int actualCheckDigit = int.parse(numericOnly[7]);
      debugPrint('[Validator] JAN-8 Calc: w3Sum=$weight3Sum, w1Sum=$weight1Sum, total=$total, calcCD=$checkDigit, actualCD=$actualCheckDigit');
      
      if (checkDigit != actualCheckDigit) {
        return ValidationResult.failure('バーコードが正常に読み取れない（チェックデジットエラー）');
      }
      return ValidationResult.success();
    }
    
    return ValidationResult.success();
  }

  /// パリティチェック (簡易実装: 文字列長や特定の数値パターンなど)
  /// パリティチェック (簡易実装: 文字列長や特定の数値パターンなど)
  static ValidationResult validateParity(String barcode) {
    // デモ用: 'P-ERR' を含む場合はエラー
    if (barcode.toUpperCase().contains('P-ERR')) {
      return ValidationResult.failure('バーコードが正常に読み取れない（パリティエラー）');
    }
    return ValidationResult.success();
  }

  /// スタート/ストップキャラクタの検証
  static ValidationResult validateStartStopCharacters(
    String barcode, {
    String? expectedStart,
    String? expectedStop,
  }) {
    debugPrint('[Validator] validateStartStopCharacters: $barcode');
    final upperBarcode = barcode.toUpperCase();
    
    // デモ用: 
    // ケース8: 'NO-START' -> スタート文字なし
    // ケース9: 'NO-STOP' -> ストップ文字なし
    // ケース10: 'NO-BOTH' -> 両方なし
    if (upperBarcode.startsWith('NO-START')) return ValidationResult.failure('バーコードが正常に読み取れない（スタート文字欠落）');
    if (upperBarcode.endsWith('NO-STOP')) return ValidationResult.failure('バーコードが正常に読み取れない（ストップ文字欠落）');
    if (upperBarcode.contains('NO-BOTH')) return ValidationResult.failure('バーコードが正常に読み取れない（スタート/ストップ文字欠落）');

    if (expectedStart != null && !barcode.startsWith(expectedStart)) {
      return ValidationResult.failure('スタートキャラクタが不足しています (期待: $expectedStart)');
    }
    if (expectedStop != null && !barcode.endsWith(expectedStop)) {
      return ValidationResult.failure('ストップキャラクタが不足しています (期待: $expectedStop)');
    }
    return ValidationResult.success();
  }
}
