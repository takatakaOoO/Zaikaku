import 'dart:math';
import 'package:flutter/material.dart';

/// デモ用に擬似的なバーコードを描画するPainter
class MockBarcodePainter extends CustomPainter {
  final String data;
  final bool is1D;

  MockBarcodePainter({required this.data, required this.is1D});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    if (is1D) {
      _paint1D(canvas, size, paint);
    } else {
      _paint2D(canvas, size, paint);
    }
  }

  void _paint1D(Canvas canvas, Size size, Paint paint) {
    // 擬似的な1Dバーコード（縦棒）を描画
    // データ文字列をシードにしてランダムな幅の線を引く
    final random = Random(data.hashCode);
    double currentX = 0;
    
    while (currentX < size.width) {
      final barWidth = random.nextDouble() * 4 + 2;
      final isSpace = random.nextBool();
      
      if (!isSpace) {
        canvas.drawRect(
          Rect.fromLTWH(currentX, 0, barWidth, size.height),
          paint,
        );
      }
      currentX += barWidth + (random.nextDouble() * 2);
    }
  }

  void _paint2D(Canvas canvas, Size size, Paint paint) {
    // 擬似的なQRコードを描画
    final random = Random(data.hashCode);
    const int gridSize = 21; // 最小のQRサイズ
    final cellSize = size.width / gridSize;

    // 四隅の切り出しシンボル（風）
    _drawFinderPattern(canvas, 0, 0, cellSize, paint);
    _drawFinderPattern(canvas, (gridSize - 7) * cellSize, 0, cellSize, paint);
    _drawFinderPattern(canvas, 0, (gridSize - 7) * cellSize, cellSize, paint);

    // ランダムなドット
    for (int y = 0; y < gridSize; y++) {
      for (int x = 0; x < gridSize; x++) {
        // 切り出しシンボルの範囲外のみランダムに描く
        if ((x < 8 && y < 8) || (x > gridSize - 9 && y < 8) || (x < 8 && y > gridSize - 9)) {
          continue;
        }
        if (random.nextBool()) {
          canvas.drawRect(
            Rect.fromLTWH(x * cellSize, y * cellSize, cellSize, cellSize),
            paint,
          );
        }
      }
    }
  }

  void _drawFinderPattern(Canvas canvas, double x, double y, double cellSize, Paint paint) {
    // 外枠 (7x7)
    canvas.drawRect(Rect.fromLTWH(x, y, 7 * cellSize, 7 * cellSize), paint);
    // 内側を白く塗る (5x5)
    canvas.drawRect(
      Rect.fromLTWH(x + cellSize, y + cellSize, 5 * cellSize, 5 * cellSize),
      Paint()..color = Colors.white,
    );
    // 中心 (3x3)
    canvas.drawRect(Rect.fromLTWH(x + 2 * cellSize, y + 2 * cellSize, 3 * cellSize, 3 * cellSize), paint);
  }

  @override
  bool shouldRepaint(covariant MockBarcodePainter oldDelegate) => oldDelegate.data != data;
}
