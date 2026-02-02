import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/models/product_with_materials.dart';
import '../../../../domain/models/verification_result.dart';
import '../../../../core/providers/repository_providers.dart';

/// スキャン画面の状態
class ScanState {
  /// 現在のアクティブ製品（マスタからロード）
  final ProductWithMaterials? activeProduct;
  
  /// スキャン履歴
  final List<VerificationResult> scanHistory;
  
  /// 最新の照合結果
  final VerificationResult? latestResult;
  
  /// スキャン中かどうか
  final bool isScanning;
  
  /// 確認待機中かどうか（trueの場合、次のスキャンをブロック）
  final bool isPendingConfirmation;
  
  /// エラーメッセージ
  final String? errorMessage;
  
  /// デバッグ情報（原因切り分け用）
  final String? debugInfo;

  const ScanState({
    this.activeProduct,
    this.scanHistory = const [],
    this.latestResult,
    this.isScanning = true,
    this.isPendingConfirmation = false,
    this.errorMessage,
    this.debugInfo,
  });

  /// コピーを作成
  ScanState copyWith({
    ProductWithMaterials? activeProduct,
    List<VerificationResult>? scanHistory,
    VerificationResult? latestResult,
    bool? isScanning,
    bool? isPendingConfirmation,
    String? errorMessage,
    String? debugInfo,
    bool clearActiveProduct = false,
    bool clearLatestResult = false,
    bool clearErrorMessage = false,
  }) {
    return ScanState(
      activeProduct: clearActiveProduct ? null : (activeProduct ?? this.activeProduct),
      scanHistory: scanHistory ?? this.scanHistory,
      latestResult: clearLatestResult ? null : (latestResult ?? this.latestResult),
      isScanning: isScanning ?? this.isScanning,
      isPendingConfirmation: isPendingConfirmation ?? this.isPendingConfirmation,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      debugInfo: debugInfo ?? this.debugInfo,
    );
  }
}

/// スキャン状態のNotifier (Riverpod 3.x対応)
class ScanNotifier extends Notifier<ScanState> {
  @override
  ScanState build() {
    // 初期状態は製品未選択
    return const ScanState();
  }

  /// デバッグ情報を設定
  void setDebugInfo(String info) {
    state = state.copyWith(debugInfo: info);
  }

  /// アクティブ製品を設定（製品マスタから検索して設定）
  Future<void> setActiveProduct(int productId) async {
    final repo = ref.read(productRepositoryProvider);
    final product = await repo.getProduct(productId);
    if (product != null) {
      state = state.copyWith(activeProduct: product);
    }
  }

  /// アクティブ製品を直接設定
  void setActiveProductDirect(ProductWithMaterials product) {
    state = state.copyWith(activeProduct: product);
  }

  /// アクティブ製品をクリア
  void clearActiveProduct() {
    state = state.copyWith(clearActiveProduct: true);
  }

  /// バーコードを照合し結果を追加
  VerificationResult verifyBarcode(String barcode) {
    final timestamp = DateTime.now();
    final product = state.activeProduct;

    VerificationResult result;

    if (barcode.isEmpty) {
      result = VerificationResult(
        scannedBarcode: barcode,
        status: VerificationStatus.notFound,
        message: 'バーコードが読み取れませんでした',
        timestamp: timestamp,
      );
    } else if (product == null) {
      result = VerificationResult(
        scannedBarcode: barcode,
        status: VerificationStatus.notFound,
        message: '製品が選択されていません',
        timestamp: timestamp,
      );
    } else if (product.containsMaterial(barcode)) {
      result = VerificationResult(
        scannedBarcode: barcode,
        status: VerificationStatus.correct,
        message: '正解！正しい材料です',
        timestamp: timestamp,
      );
    } else {
      result = VerificationResult(
        scannedBarcode: barcode,
        status: VerificationStatus.incorrect,
        message: '不正解！この材料は必要ありません',
        timestamp: timestamp,
      );
    }

    addResult(result);
    return result;
  }

  /// 照合結果を追加
  void addResult(VerificationResult result) {
    // 重複チェック (設定時間を考慮)
    if (state.scanHistory.isNotEmpty) {
      final last = state.scanHistory.last;
      if (last.scannedBarcode == result.scannedBarcode) {
        final diff = result.timestamp.difference(last.timestamp).inMilliseconds;
        // 同一バーコードの場合、一定時間は無視
        if (diff < 1000) return; 
      }
    }

    state = state.copyWith(
      latestResult: result,
      scanHistory: [...state.scanHistory, result],
      isPendingConfirmation: true, // 待機モードを有効化
    );

    // データベースに保存
    _saveToDatabase(result);
  }

  Future<void> _saveToDatabase(VerificationResult result) async {
    try {
      final repository = ref.read(scanHistoryRepositoryProvider);
      final productId = state.activeProduct?.modelNumber ?? 'UNKNOWN';
      
      await repository.saveResult(
        orderNumber: productId,
        barcode: result.scannedBarcode,
        isCorrect: result.isCorrect,
        errorCode: result.status != VerificationStatus.correct ? result.status.name : null,
      );
    } catch (e) {
      // ログ保存エラーは致命的ではないが記録
      debugPrint('Failed to save scan history: $e');
    }
  }

  /// スキャンをリセット
  void reset() {
    state = state.copyWith(
      clearLatestResult: true,
      scanHistory: [],
      isPendingConfirmation: false,
    );
  }

  /// スキャン状態を切り替え
  void setScanning(bool isScanning) {
    state = state.copyWith(isScanning: isScanning);
  }

  /// 結果を確認し、待機モードを解除（次のスキャンを許可）
  void confirmResult() {
    state = state.copyWith(
      isPendingConfirmation: false,
      clearLatestResult: true, // 結果表示もクリア
    );
  }

  /// エラーを設定
  void setError(String message) {
    state = state.copyWith(
      errorMessage: message,
      clearLatestResult: true,
      isPendingConfirmation: true, // エラー時も確認待ち（ボタン表示）状態にする
    );
  }

  /// エラーをクリア
  void clearError() {
    state = state.copyWith(
      clearErrorMessage: true,
      isPendingConfirmation: false, // エラーを閉じたらスキャン可能に戻す
    );
  }
}

/// スキャン状態のProvider (Riverpod 3.x対応)
final scanStateProvider = NotifierProvider<ScanNotifier, ScanState>(() {
  return ScanNotifier();
});
