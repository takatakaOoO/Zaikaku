import 'package:flutter_test/flutter_test.dart';
import 'package:zaikaku/core/utils/barcode_validator.dart';

void main() {
  group('BarcodeValidator Tests', () {
    // 4. 1Dコードが1個のみ (正常)
    test('JAN-13 Correct Check Digit', () {
      const barcode = '4901234567894'; // 正しいJAN-13例
      final result = BarcodeValidator.validateCheckDigit(barcode);
      expect(result.isValid, true);
    });

    // 6. 1Dコードでチェックデジットが間違っている
    test('JAN-13 Incorrect Check Digit', () {
      const barcode = '4901234567890'; // 最後が0（正解は4）
      final result = BarcodeValidator.validateCheckDigit(barcode);
      expect(result.isValid, false);
      expect(result.errorMessage, contains('チェックデジットが一致しません'));
    });

    // 8. 1Dコードでスタートキャラクタが欠落している
    test('Missing Start Character', () {
      const barcode = '4901234567894';
      final result = BarcodeValidator.validateStartStopCharacters(barcode, expectedStart: 'A');
      expect(result.isValid, false);
      expect(result.errorMessage, contains('スタートキャラクタが不足'));
    });

    // 9. 1Dコードでストップキャラクタが欠落している
    test('Missing Stop Character', () {
      const barcode = 'A4901234567894';
      final result = BarcodeValidator.validateStartStopCharacters(barcode, expectedStart: 'A', expectedStop: 'B');
      expect(result.isValid, false);
      expect(result.errorMessage, contains('ストップキャラクタが不足'));
    });

    // 10. 1Dコードで両方欠落 (正常なコードに対して、期待値を設定した場合の検知)
    test('Missing Both Start/Stop Characters', () {
      const barcode = '4901234567894';
      final result = BarcodeValidator.validateStartStopCharacters(barcode, expectedStart: 'A', expectedStop: 'B');
      expect(result.isValid, false);
    });

    // 正常系 (スタート/ストップあり)
    test('Correct Start/Stop Characters', () {
      const barcode = 'A4901234567894B';
      final result = BarcodeValidator.validateStartStopCharacters(barcode, expectedStart: 'A', expectedStop: 'B');
      expect(result.isValid, true);
    });
  });
}
