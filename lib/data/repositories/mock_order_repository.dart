import '../../domain/models/manufacturing_order.dart';
import '../../domain/models/material.dart';

/// モック製造指示書リポジトリ
/// 
/// テスト用のモックデータを提供します。
/// 実際の運用では、APIやデータベースから取得する実装に置き換えます。
class MockOrderRepository {
  /// 現在の製造指示書を取得
  ManufacturingOrder getCurrentOrder() {
    return ManufacturingOrder(
      orderId: 'TEST-ORDER-PH2',
      productName: '検証用製品（Phase 2）',
      requiredMaterialBarcodes: [
        '4901234567894', // JAN-13 正解コード (ケース4用)
        'A12345678B',    // スタート/ストップ付きコード (正常)
        'QR-SAMPLE-001', // 2Dコード1 (ケース1用)
        'QR-SAMPLE-002', // 2Dコード2 (ケース2用)
      ],
      createdAt: DateTime.now(),
    );
  }

  /// すべての材料マスタデータを取得
  List<Material> getAllMaterials() {
    return [
      const Material(barcode: '4901234567894', name: '検証用材料(1D)', category: 'テスト'),
      const Material(barcode: 'A12345678B', name: '検証用材料(1D-SS)', category: 'テスト'),
      const Material(barcode: 'QR-SAMPLE-001', name: '検証用材料(2D-1)', category: 'テスト'),
      const Material(barcode: 'QR-SAMPLE-002', name: '検証用材料(2D-2)', category: 'テスト'),
      // 以下、既存のデータ
      const Material(barcode: '1234567890123', name: '鋼材A', category: '金属'),
      const Material(
        barcode: '9876543210987',
        name: '樹脂B',
        category: 'プラスチック',
      ),
      const Material(
        barcode: '1111222233334',
        name: 'ボルトC',
        category: '部品',
      ),
      const Material(
        barcode: '5555666677778',
        name: '塗料D',
        category: '化学品',
      ),
      const Material(
        barcode: '9999888877776',
        name: 'ゴムE',
        category: 'ゴム',
      ),
    ];
  }

  /// バーコードから材料を検索
  Material? findMaterialByBarcode(String barcode) {
    try {
      return getAllMaterials().firstWhere(
        (material) => material.barcode == barcode,
      );
    } catch (e) {
      return null;
    }
  }
}
