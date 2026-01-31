import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/audio_provider.dart';
import '../../../domain/models/verification_result.dart';
import '../../../domain/models/product_with_materials.dart';
import '../../../core/utils/barcode_validator.dart';
import '../../product/presentation/providers/product_provider.dart';
import 'providers/scan_state_provider.dart';
import 'providers/scan_settings_provider.dart';

/// バーコードスキャン画面
///
/// Phase 5.4: 読み取り失敗時のフィードバック追加（修正版）
class ScanScreen extends ConsumerStatefulWidget {
  const ScanScreen({super.key});

  @override
  ConsumerState<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends ConsumerState<ScanScreen> {
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );

  bool _isScanTriggered = false;

  Timer? _demoTimer;
  int _demoIndex = 0;
  bool _isDemoRunning = false;
  final List<List<String>> _demoCases = [
    ['QR-SAMPLE-001'], ['4901234567894'], ['MISSING-ITEM']
  ];

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
    _demoTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _demoIndex = (_demoIndex + 1) % _demoCases.length;
      _runDemoCase();
    });
  }

  void _runDemoCase() {
    final barcodes = _demoCases[_demoIndex];
    setState(() => _isScanTriggered = true);
    final capture = BarcodeCapture(
      barcodes: barcodes.map((raw) => Barcode(rawValue: raw, type: BarcodeType.unknown)).toList(),
      image: null, 
    );
    _onBarcodeDetected(capture);
  }

  void _onBarcodeDetected(BarcodeCapture capture) {
    if (!_isScanTriggered) return;
    
    final scanState = ref.read(scanStateProvider);
    if (scanState.isPendingConfirmation) return;

    if (scanState.activeProduct == null) {
      ref.read(scanStateProvider.notifier).setError('製品を選択してください');
      setState(() => _isScanTriggered = false);
      return;
    }

    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    setState(() => _isScanTriggered = false);
    // エラー表示があればクリア
    ref.read(scanStateProvider.notifier).clearError();

    final settings = ref.read(scanSettingsProvider);
    final scanNotifier = ref.read(scanStateProvider.notifier);

    for (final barcodeObj in barcodes) {
      final barcode = barcodeObj.rawValue;
      if (barcode == null) continue;

      if (settings.enableCheckDigit) {
        final check = BarcodeValidator.validateCheckDigit(barcode);
        if (!check.isValid) continue;
      }

      final result = scanNotifier.verifyBarcode(barcode);
      final audioService = ref.read(audioServiceProvider);
      
      if (result.isCorrect) {
        audioService.playCorrectSound();
      } else {
        audioService.playIncorrectSound();
      }
      break; 
    }
  }

  void _onShutterPressed() {
    final notifier = ref.read(scanStateProvider.notifier);
    final state = ref.read(scanStateProvider);
    if (state.isPendingConfirmation) return;

    notifier.clearError();
    Feedback.forTap(context); 

    setState(() => _isScanTriggered = true);
    
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted && _isScanTriggered) {
        setState(() => _isScanTriggered = false);
        notifier.setError('バーコードを読み取れませんでした');
        ref.read(audioServiceProvider).playIncorrectSound();
      }
    });
  }

  Future<void> _showProductSelector() async {
    final List<ProductWithMaterials> products;
    try {
      products = await ref.read(productListProvider.future);
    } catch (e) {
      return;
    }
    if (!mounted) return;
    
    final selected = await showDialog<ProductWithMaterials>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('製品を選択'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text('型番: ${product.modelNumber}'),
                onTap: () => Navigator.pop(context, product),
              );
            },
          ),
        ),
      ),
    );

    if (selected != null) {
      ref.read(scanStateProvider.notifier).setActiveProductDirect(selected);
    }
  }

  Future<void> _pickAndScanImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() => _isScanTriggered = true);
    final result = await _scannerController.analyzeImage(image.path);
    if (result != null && result.barcodes.isNotEmpty) {
      _onBarcodeDetected(BarcodeCapture(barcodes: result.barcodes));
    } else {
      setState(() => _isScanTriggered = false);
      ref.read(scanStateProvider.notifier).setError('画像からバーコードを検出できませんでした');
    }
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(scanStateProvider);
    final settings = ref.watch(scanSettingsProvider);
    final size = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).padding.top;
    
    const topBarHeight = 60.0;
    final overlayTop = topPadding + topBarHeight + 16.0;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. カメラ
          Positioned.fill(
            child: MobileScanner(
              controller: _scannerController,
              onDetect: _onBarcodeDetected,
            ),
          ),
          
          // 2. ガイド枠 (上部固定)
          Positioned(
            top: overlayTop,
            left: 0,
            right: 0,
            child: Center(
              child: _buildScanOverlay(settings),
            ),
          ),

          // 3. 上部バー
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => context.pop(),
                      style: IconButton.styleFrom(backgroundColor: Colors.black45),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: _showProductSelector,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white30),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                scanState.activeProduct?.name ?? '製品を選択してください',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (scanState.activeProduct != null)
                                Text(
                                  scanState.activeProduct!.modelNumber,
                                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white),
                      onPressed: () => context.push('/settings'),
                       style: IconButton.styleFrom(backgroundColor: Colors.black45),
                    ),
                    GestureDetector(
                      onLongPress: _toggleDemo,
                      onDoubleTap: _pickAndScanImage,
                      child: Container(width: 40, height: 40, color: Colors.transparent),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 4. 結果表示 OR エラー表示
          if (scanState.latestResult != null || scanState.errorMessage != null)
            Positioned(
              top: overlayTop + 20,
              left: 16,
              right: 16,
              child: _buildResultOrErrorOverlay(scanState),
            ),

          // 5. 下部エリア (ボタン + リスト)
          Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              alignment: Alignment.bottomCenter,
              clipBehavior: Clip.none,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: size.height * 0.45,
                        ),
                        child: _buildMaterialListPanel(scanState),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  right: 24,
                  top: -40,
                  child: _buildShutterButton(scanState),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanOverlay(ScanSettings settings) {
    final isNarrow = settings.rangeMode == ScanRangeMode.singleNarrow;
    return Container(
      width: 250,
      height: isNarrow ? 100 : 250,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: isNarrow 
        ? Center(child: Container(height: 2, width: 230, color: Colors.red)) 
        : null,
    );
  }

  /// 成功結果またはエラーを表示
  Widget _buildResultOrErrorOverlay(ScanState state) {
    // エラーがある場合
    if (state.errorMessage != null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red, width: 3),
          boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black26)],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 32),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    state.errorMessage!,
                    style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
             Padding(
              padding: const EdgeInsets.only(top: 12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => ref.read(scanStateProvider.notifier).clearError(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('閉じる'),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // 結果がある場合
    final result = state.latestResult!;
    final isCorrect = result.status == VerificationStatus.correct;
    final color = isCorrect ? Colors.green : Colors.red;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 3),
        boxShadow: const [BoxShadow(blurRadius: 10, color: Colors.black26)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isCorrect ? Icons.check_circle : Icons.error, color: color, size: 32),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  result.message ?? '',
                  style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          if (state.isPendingConfirmation)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => ref.read(scanStateProvider.notifier).confirmResult(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('確認して次へ'),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildShutterButton(ScanState state) {
    final isPending = state.isPendingConfirmation;
    
    return InkWell(
      onTap: isPending ? null : _onShutterPressed,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: isPending ? Colors.grey : Colors.red.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
          boxShadow: const [BoxShadow(blurRadius: 8, color: Colors.black38)],
        ),
        child: _isScanTriggered
          ? const CircularProgressIndicator(color: Colors.white)
          : const Icon(Icons.camera_alt, color: Colors.white, size: 40),
      ),
    );
  }

  Widget _buildMaterialListPanel(ScanState state) {
    final product = state.activeProduct;
    if (product == null || product.materialBarcodes.isEmpty) {
      return const SizedBox(width: double.infinity, height: 40);
    }
    
    final materials = product.materialBarcodes;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  const Icon(Icons.list, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    '必要な材料 (${_getMatchedCount(state)} / ${materials.length})',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24, height: 1),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: materials.length,
              separatorBuilder: (_, __) => const Divider(color: Colors.white10, height: 1),
              itemBuilder: (context, index) {
                final code = materials[index];
                final isDone = state.scanHistory.any(
                  (h) => h.scannedBarcode == code && h.status == VerificationStatus.correct
                );
                
                return ListTile(
                  dense: true,
                  visualDensity: const VisualDensity(vertical: -4),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  title: Text(code, style: const TextStyle(fontSize: 14, color: Colors.white)),
                  leading: const Icon(Icons.qr_code, size: 16, color: Colors.white70),
                  trailing: isDone 
                    ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
                    : const Icon(Icons.radio_button_unchecked, color: Colors.white30, size: 20),
                );
              },
            ),
            SizedBox(height: MediaQuery.of(context).viewPadding.bottom + 16),
          ],
        ),
      ),
    );
  }

  int _getMatchedCount(ScanState state) {
    if (state.activeProduct == null) return 0;
    return state.activeProduct!.materialBarcodes.where((code) {
       return state.scanHistory.any(
         (h) => h.scannedBarcode == code && h.status == VerificationStatus.correct
       );
    }).length;
  }
}
