import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/audio_provider.dart';

/// 材料登録用の連続スキャン画面
class MaterialScanScreen extends ConsumerStatefulWidget {
  const MaterialScanScreen({super.key});

  @override
  ConsumerState<MaterialScanScreen> createState() => _MaterialScanScreenState();
}

class _MaterialScanScreenState extends ConsumerState<MaterialScanScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );
  
  final Set<String> _scannedBarcodes = {};
  bool _isFlashOn = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    final barcodes = capture.barcodes;
    bool hasNew = false;

    for (final barcode in barcodes) {
      final code = barcode.rawValue;
      if (code != null && code.isNotEmpty) {
        if (!_scannedBarcodes.contains(code)) {
          setState(() {
            _scannedBarcodes.add(code);
          });
          hasNew = true;
        }
      }
    }

    if (hasNew) {
      // 音声フィードバック
      ref.read(audioServiceProvider).playCorrectSound();
      
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_scannedBarcodes.length}件読み取り済み'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _toggleFlash() {
    setState(() {
      _isFlashOn = !_isFlashOn;
      _controller.toggleTorch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('バーコード連続スキャン'),
        actions: [
          IconButton(
            icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off),
            onPressed: _toggleFlash,
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(_scannedBarcodes.toList());
            },
            child: const Text('完了', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: MobileScanner(
              controller: _controller,
              onDetect: _onDetect,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).colorScheme.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '読み取ったバーコード (${_scannedBarcodes.length}件)',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _scannedBarcodes.length,
                      itemBuilder: (context, index) {
                        final barcode = _scannedBarcodes.elementAt(_scannedBarcodes.length - 1 - index); // 新しい順
                        return ListTile(
                          dense: true,
                          leading: const Icon(Icons.qr_code),
                          title: Text(barcode),
                          trailing: IconButton(
                            icon: const Icon(Icons.close, size: 16),
                            onPressed: () {
                              setState(() {
                                _scannedBarcodes.remove(barcode);
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
