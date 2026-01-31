/// 製造指示書のデータモデル
/// 
/// 工場での製造作業に必要な情報を保持します。
class ManufacturingOrder {
  /// 指示書ID
  final String orderId;
  
  /// 製品名
  final String productName;
  
  /// 必要な材料のバーコードリスト
  final List<String> requiredMaterialBarcodes;
  
  /// 作成日時
  final DateTime createdAt;

  const ManufacturingOrder({
    required this.orderId,
    required this.productName,
    required this.requiredMaterialBarcodes,
    required this.createdAt,
  });

  /// バーコードが必要材料リストに含まれているかチェック
  bool containsMaterial(String barcode) {
    return requiredMaterialBarcodes.contains(barcode);
  }

  /// コピーを作成
  ManufacturingOrder copyWith({
    String? orderId,
    String? productName,
    List<String>? requiredMaterialBarcodes,
    DateTime? createdAt,
  }) {
    return ManufacturingOrder(
      orderId: orderId ?? this.orderId,
      productName: productName ?? this.productName,
      requiredMaterialBarcodes: requiredMaterialBarcodes ?? this.requiredMaterialBarcodes,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
