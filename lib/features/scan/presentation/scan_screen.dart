import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import '../../../core/providers/audio_provider.dart';
import '../../../data/repositories/mock_order_repository.dart';
import '../../../domain/usecases/verify_material_usecase.dart';
import '../../../domain/models/verification_result.dart';
import '../../../core/utils/barcode_validator.dart';
import 'providers/scan_state_provider.dart';
import 'providers/scan_settings_provider.dart';
import 'settings_screen.dart';

/// バーコードスキャン画面
/// 
/// カメラでバーコードをスキャンし、製造指示書と照合します。
class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    // 初期フォーマットは後で設定反映
  );
  
  final VerifyMaterialUseCase _verifyMaterialUseCase = VerifyMaterialUseCase();
  final MockOrderRepository _orderRepository = MockOrderRepository();
  
  // 連続スキャン防止用
  String? _lastScannedBarcode;
  DateTime? _lastScanTime;
  static const _scanCooldown = Duration(seconds: 2);

  // デモモード用
  Timer? _demoTimer;
  int _demoIndex = 0;
  bool _isDemoRunning = false;

  final List<List<String>> _demoCases = [
    ['QR-SAMPLE-001'],                   // 1. 2D 1個 (OK)
    ['QR-SAMPLE-001', 'QR-SAMPLE-002'],  // 2. 2D 複数
    ['QR-SAMPLE-001', '4901234567894'],  // 3. 2D + 1D (Mixed)
    ['4901234567894'],                   // 4. 1D 1個 (OK)
    ['1234567890123', '9876543210987'],  // 5. 1D 複数
    ['4901234567890'],                   // 6. 1D CDエラー
    ['PARITY-ERROR-CODE'],               // 7. パリティエラー (Mock)
    ['MISSING-START-123'],               // 8. スタート文字欠落
    ['A123MISSING-STOP'],                // 9. ストップ文字欠落
    ['MISSING-BOTH-XYZ'],                // 10. 両方欠落
  ];

  @override
  void initState() {
    super.initState();
    // 初期製造指示書を設定
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final order = _orderRepository.getCurrentOrder();
      ref.read(scanStateProvider.notifier).setOrder(order);
    });
  }

  @override
  void dispose() {
    _demoTimer?.cancel();
    _scannerController.dispose();
    super.dispose();
  }

  void _toggleDemo() {
    setState(() {
      _isDemoRunning = !_isDemoRunning;
      if (_isDemoRunning) {
        _demoIndex = 0;
        _startDemoCycle();
      } else {
        _demoTimer?.cancel();
      }
    });
  }

  void _startDemoCycle() {
    _demoTimer?.cancel();
    _runDemoCase();
    _demoTimer = Timer.periodic(const Duration(seconds: 20), (timer) {
      _demoIndex = (_demoIndex + 1) % _demoCases.length;
      _runDemoCase();
    });
  }

  void _runDemoCase() {
    final barcodes = _demoCases[_demoIndex];
    debugPrint('--- Running Demo Case ${_demoIndex + 1}: $barcodes ---');
    
    // UI通知用にSnackBarを表示
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('テストケース ${_demoIndex + 1}: $barcodes をモック読取中...'),
        duration: const Duration(seconds: 3),
      ),
    );

    // mobile_scannerのBarcodeCaptureを偽装して呼び出し
    final capture = BarcodeCapture(
      barcodes: barcodes.map((raw) => Barcode(rawValue: raw, type: BarcodeType.unknown)).toList(),
    );
    _onBarcodeDetected(capture);
  }

  /// バーコード検出時の処理
  void _onBarcodeDetected(BarcodeCapture capture) {
    final settings = ref.read(scanSettingsProvider);
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    for (final barcodeObj in barcodes) {
      final barcode = barcodeObj.rawValue;
      if (barcode == null) continue;

      // バリデーション (設定に応じて実施)
      if (settings.enableCheckDigit) {
        final checkResult = BarcodeValidator.validateCheckDigit(barcode);
        if (!checkResult.isValid) {
          debugPrint('Validation failed: ${checkResult.errorMessage}');
          continue; 
        }
      }

      // 照合実行
      final scanState = ref.read(scanStateProvider);
      if (scanState.currentOrder == null) return;

      final result = _verifyMaterialUseCase.execute(
        barcode,
        scanState.currentOrder!,
      );

      // 結果を状態に追加
      ref.read(scanStateProvider.notifier).addResult(result);

      // 音声フィードバック
      final audioService = ref.read(audioServiceProvider);
      if (result.isCorrect) {
        audioService.playCorrectSound();
      } else {
        audioService.playIncorrectSound();
      }

      // 単一モードの場合は最初の1つで終了
      if (settings.rangeMode == ScanRangeMode.singleNarrow) {
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(scanStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('材料スキャン'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          // デモ切り替えボタン (デバッグ用)
          IconButton(
            icon: Icon(_isDemoRunning ? Icons.stop_circle : Icons.play_circle_outline),
            color: _isDemoRunning ? Colors.redAccent : null,
            onPressed: _toggleDemo,
            tooltip: _isDemoRunning ? 'デモ停止' : 'デモ再生 (20s周期)',
          ),
          // 【追加】画像ファイル選択ボタン (デバッグ用)
          IconButton(
            icon: const Icon(Icons.image_search),
            onPressed: _pickAndScanImage,
            tooltip: '画像ファイルからスキャン',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
            tooltip: '設定',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(scanStateProvider.notifier).reset();
              _lastScannedBarcode = null;
              _lastScanTime = null;
            },
            tooltip: 'リセット',
          ),
        ],
      ),
      body: Column(
        children: [
          // 製造指示書情報
          _buildOrderInfo(scanState),
          
          // カメラプレビュー
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                MobileScanner(
                  controller: _scannerController,
                  onDetect: _onBarcodeDetected,
                  // ROIの設定 (モバイル環境でのピクセル計算が必要になる場合がある)
                  scanWindow: _getScanWindow(context),
                ),
                // スキャンガイド枠
                _buildScanOverlay(ref.watch(scanSettingsProvider)),

                // デモ用：仮想バーコード表示 (生成画像)
                if (_isDemoRunning)
                  _buildMockBarcodePreview(),
              ],
            ),
          ),
          
          // 照合結果表示
          Expanded(
            flex: 2,
            child: _buildResultPanel(scanState),
          ),
        ],
      ),
    );
  }

  /// 製造指示書情報ウィジェット
  Widget _buildOrderInfo(ScanState state) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Row(
        children: [
          Icon(
            Icons.assignment,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.currentOrder?.orderId ?? '指示書未選択',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                Text(
                  state.currentOrder?.productName ?? '---',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '必要材料: ${state.currentOrder?.requiredMaterialBarcodes.length ?? 0}点',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  /// スキャンウィンドウ（ROI）の計算
  Rect? _getScanWindow(BuildContext context) {
    final settings = ref.watch(scanSettingsProvider);
    if (settings.rangeMode == ScanRangeMode.multiFull) return null;

    final size = MediaQuery.of(context).size;
    // 中央の 280x160 の範囲を正規化 (0.0 - 1.0)
    final width = 280.0 / size.width;
    final height = 160.0 / (size.height * 3 / 5); // Expanded flex 3分
    final left = (1.0 - width) / 2;
    final top = (1.0 - height) / 2;

    return Rect.fromLTRB(left, top, left + width, top + height);
  }

  /// スキャンオーバーレイ
  Widget _buildScanOverlay(ScanSettings settings) {
    final isNarrow = settings.rangeMode == ScanRangeMode.singleNarrow;
    
    return Center(
      child: Container(
        width: 280,
        height: isNarrow ? 80 : 250,
        decoration: BoxDecoration(
          border: Border.all(
            color: isNarrow ? Colors.yellow : Colors.white,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isNarrow ? Icons.linear_scale : Icons.qr_code_scanner,
              color: isNarrow ? Colors.yellow : Colors.white,
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              isNarrow ? 'バーコードを横線に合わせてください' : 'バーコードを枠内に合わせてください',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isNarrow ? Colors.yellow : Colors.white,
                fontSize: 12,
                fontWeight: isNarrow ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 画像ファイルを選択してスキャンを実行
  Future<void> _pickAndScanImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image == null) return;

    // mobile_scannerのコントローラーを使用して画像を解析
    final result = await _scannerController.analyzeImage(image.path);
    
    if (result != null && result.barcodes.isNotEmpty) {
      // 便宜上、最初の1つを処理
      final capture = BarcodeCapture(barcodes: result.barcodes);
      _onBarcodeDetected(capture);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('バーコードが見つかりませんでした')),
        );
      }
    }
  }

  /// デモ用の仮想バーコードプレビュー（生成されたアセット画像を使用）
  Widget _buildMockBarcodePreview() {
    final barcodes = _demoCases[_demoIndex];
    
    // 生成画像パスのマッピング
    final imagePaths = {
      0: 'lib/features/scan/presentation/assets/demo_1.png',  // QR OK
      1: 'lib/features/scan/presentation/assets/demo_2.png',  // 2D Multi
      2: 'lib/features/scan/presentation/assets/demo_3.png',  // 2D + 1D
      3: 'lib/features/scan/presentation/assets/demo_4.png',  // JAN OK
      4: 'lib/features/scan/presentation/assets/demo_5.png',  // 1D Multi
      5: 'lib/features/scan/presentation/assets/demo_6.png',  // JAN Error (CD)
      6: 'lib/features/scan/presentation/assets/demo_7.png',  // Parity Error
      7: 'lib/features/scan/presentation/assets/demo_8.png',  // Missing Start
      8: 'lib/features/scan/presentation/assets/demo_9.png',  // Missing Stop
      9: 'lib/features/scan/presentation/assets/demo_10.png', // Missing Both
    };

    final imagePath = imagePaths[_demoIndex];

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280, maxHeight: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (imagePath != null)
              Flexible(
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Text('画像読込エラー', style: TextStyle(color: Colors.red)));
                  },
                ),
              )
            else
              Container(
                height: 100,
                width: 200,
                color: Colors.grey[200],
                alignment: Alignment.center,
                child: const Text('No Image', style: TextStyle(color: Colors.grey)),
              ),
            const SizedBox(height: 8),
            Text(
              'Case ${_demoIndex + 1}: ${barcodes.first}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 照合結果パネル
  Widget _buildResultPanel(ScanState state) {
    final latestResult = state.latestResult;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: _getResultBackgroundColor(latestResult),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (latestResult == null) ...[
            Icon(
              Icons.info_outline,
              size: 48,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(height: 8),
            Text(
              'バーコードをスキャンしてください',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ] else ...[
            Icon(
              _getResultIcon(latestResult.status),
              size: 64,
              color: _getResultIconColor(latestResult.status),
            ),
            const SizedBox(height: 8),
            Text(
              latestResult.message ?? '',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: _getResultTextColor(latestResult.status),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'バーコード: ${latestResult.scannedBarcode}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _getResultTextColor(latestResult.status).withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '本日のスキャン: ${state.scanHistory.length}回',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }

  /// 結果に応じた背景色
  Color _getResultBackgroundColor(VerificationResult? result) {
    if (result == null) return Theme.of(context).colorScheme.surface;
    switch (result.status) {
      case VerificationStatus.correct:
        return Colors.green.shade50;
      case VerificationStatus.incorrect:
        return Colors.red.shade50;
      case VerificationStatus.notFound:
        return Colors.orange.shade50;
    }
  }

  /// 結果に応じたアイコン
  IconData _getResultIcon(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.correct:
        return Icons.check_circle;
      case VerificationStatus.incorrect:
        return Icons.cancel;
      case VerificationStatus.notFound:
        return Icons.help;
    }
  }

  /// 結果に応じたアイコン色
  Color _getResultIconColor(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.correct:
        return Colors.green;
      case VerificationStatus.incorrect:
        return Colors.red;
      case VerificationStatus.notFound:
        return Colors.orange;
    }
  }

  /// 結果に応じたテキスト色
  Color _getResultTextColor(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.correct:
        return Colors.green.shade800;
      case VerificationStatus.incorrect:
        return Colors.red.shade800;
      case VerificationStatus.notFound:
        return Colors.orange.shade800;
    }
  }
}
