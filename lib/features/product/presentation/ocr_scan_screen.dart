import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OCRScanScreen extends StatefulWidget {
  final bool isJapanese; // 製品名(日本語)か型番(英数字)か

  const OCRScanScreen({
    super.key,
    this.isJapanese = false,
  });

  @override
  State<OCRScanScreen> createState() => _OCRScanScreenState();
}

class _OCRScanScreenState extends State<OCRScanScreen> {
  CameraController? _controller;
  late final TextRecognizer _textRecognizer;
  bool _isBusy = false;
  RecognizedText? _recognizedResult;
  
  // カメラリスト
  List<CameraDescription> _cameras = [];

  @override
  void initState() {
    super.initState();
    // 日本語またはデフォルト（Latin）の認識器を初期化
    _textRecognizer = TextRecognizer(
      script: widget.isJapanese 
          ? TextRecognitionScript.japanese 
          : TextRecognitionScript.latin,
    );
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) return;

      // 背面カメラを優先
      final camera = _cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras.first,
      );

      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );

      await _controller!.initialize();
      if (!mounted) return;

      // 画像ストリームの開始
      await _controller!.startImageStream(_processImage);
      setState(() {});
    } catch (e) {
      debugPrint('Error initializing camera: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('カメラの起動に失敗しました: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _textRecognizer.close();
    super.dispose();
  }

  Future<void> _processImage(CameraImage image) async {
    if (_controller == null || _isBusy || !mounted) return;
    _isBusy = true;

    try {
      final inputImage = _inputImageFromCameraImage(image);
      if (inputImage == null) return;

      final recognizedText = await _textRecognizer.processImage(inputImage);
      
      if (mounted) {
        setState(() {
          _recognizedResult = recognizedText;
        });
      }
    } catch (e) {
      debugPrint('Error processing image: $e');
    } finally {
      _isBusy = false;
    }
  }

  // CameraImage -> InputImage 変換
  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_controller == null) return null;

    final camera = _controller!.description;
    final sensorOrientation = camera.sensorOrientation;
    
    final orientations = {
      DeviceOrientation.portraitUp: 0,
      DeviceOrientation.landscapeLeft: 90,
      DeviceOrientation.portraitDown: 180,
      DeviceOrientation.landscapeRight: 270,
    };
    
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null) return null;
    
    final allBytes = WriteBuffer();
    for (final plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final size = Size(image.width.toDouble(), image.height.toDouble());
    
    final rotation = InputImageRotationValue.fromRawValue(sensorOrientation) 
        ?? InputImageRotation.rotation0deg;

    final metadata = InputImageMetadata(
      size: size,
      rotation: rotation,
      format: format,
      bytesPerRow: image.planes.first.bytesPerRow,
    );

    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isJapanese ? '製品名をスキャン' : '型番をスキャン'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: ClipRRect(
              child: CameraPreview(_controller!),
            ),
          ),
          Container(
            height: 250,
            padding: const EdgeInsets.all(8.0),
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    '読み取ったテキスト (タップして選択)',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                  ),
                ),
                Expanded(
                  child: _recognizedResult == null || _recognizedResult!.blocks.isEmpty
                      ? const Center(child: Text('テキストを読み取っています...'))
                      : ListView.separated(
                          itemCount: _recognizedResult!.blocks.length,
                          separatorBuilder: (context, index) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final textBlock = _recognizedResult!.blocks[index];
                            final text = textBlock.text.trim();
                            if (text.isEmpty) return const SizedBox.shrink();
                            
                            return ListTile(
                              tileColor: Colors.white,
                              title: Text(
                                text,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: const Icon(Icons.check_circle_outline, color: Colors.blue),
                              onTap: () {
                                Navigator.of(context).pop(text);
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
