import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/models/manufacturing_order.dart';
import '../../../../domain/models/verification_result.dart';
import '../../../../core/providers/repository_providers.dart';

/// スキャン画面の状態
class ScanState {
  /// 現在の製造指示書
  final ManufacturingOrder? currentOrder;
  
  /// スキャン履歴
  final List<VerificationResult> scanHistory;
  
  /// 最新の照合結果
  final VerificationResult? latestResult;
  
  /// スキャン中かどうか
  final bool isScanning;
  
  /// エラーメッセージ
  final String? errorMessage;

  const ScanState({
    this.currentOrder,
    this.scanHistory = const [],
    this.latestResult,
    this.isScanning = true,
    this.errorMessage,
  });

  /// コピーを作成
  ScanState copyWith({
    ManufacturingOrder? currentOrder,
    List<VerificationResult>? scanHistory,
    VerificationResult? latestResult,
    bool? isScanning,
    String? errorMessage,
    bool clearLatestResult = false,
    bool clearErrorMessage = false,
  }) {
    return ScanState(
      currentOrder: currentOrder ?? this.currentOrder,
      scanHistory: scanHistory ?? this.scanHistory,
      latestResult: clearLatestResult ? null : (latestResult ?? this.latestResult),
      isScanning: isScanning ?? this.isScanning,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// スキャン状態のNotifier (Riverpod 3.x対応)
class ScanNotifier extends Notifier<ScanState> {
  @override
  ScanState build() {
    // 開発・検証フェーズのため、初期状態でモック指示書をセットしておく
    final mockRepo = ref.read(mockOrderRepositoryProvider);
    return ScanState(
      currentOrder: mockRepo.getCurrentOrder(),
    );
  }

  /// 製造指示書を設定
  void setOrder(ManufacturingOrder order) {
    state = state.copyWith(currentOrder: order);
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
    );

    // データベースに保存
    _saveToDatabase(result);
  }

  Future<void> _saveToDatabase(VerificationResult result) async {
    try {
      final repository = ref.read(scanHistoryRepositoryProvider);
      final orderId = state.currentOrder?.orderId ?? 'UNKNOWN';
      
      await repository.saveResult(
        orderNumber: orderId,
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
    );
  }

  /// スキャン状態を切り替え
  void setScanning(bool isScanning) {
    state = state.copyWith(isScanning: isScanning);
  }

  /// エラーを設定
  void setError(String message) {
    state = state.copyWith(errorMessage: message);
  }

  /// エラーをクリア
  void clearError() {
    state = state.copyWith(clearErrorMessage: true);
  }
}

/// スキャン状態のProvider (Riverpod 3.x対応)
final scanStateProvider = NotifierProvider<ScanNotifier, ScanState>(() {
  return ScanNotifier();
});
