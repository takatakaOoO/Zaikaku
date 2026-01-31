/// 製品と材料リストを統合したドメインモデル
class ProductWithMaterials {
  final int id;
  final String name;
  final String modelNumber;
  final List<String> materialBarcodes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductWithMaterials({
    required this.id,
    required this.name,
    required this.modelNumber,
    required this.materialBarcodes,
    required this.createdAt,
    required this.updatedAt,
  });

  /// バーコードが材料リストに含まれているかチェック
  bool containsMaterial(String barcode) {
    return materialBarcodes.contains(barcode);
  }

  /// コピーを作成
  ProductWithMaterials copyWith({
    int? id,
    String? name,
    String? modelNumber,
    List<String>? materialBarcodes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductWithMaterials(
      id: id ?? this.id,
      name: name ?? this.name,
      modelNumber: modelNumber ?? this.modelNumber,
      materialBarcodes: materialBarcodes ?? this.materialBarcodes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
