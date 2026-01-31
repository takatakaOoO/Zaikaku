/// 材料のデータモデル
/// 
/// 工場で使用する材料の基本情報を保持します。
class Material {
  /// バーコード
  final String barcode;
  
  /// 材料名
  final String name;
  
  /// カテゴリ
  final String category;

  const Material({
    required this.barcode,
    required this.name,
    required this.category,
  });

  /// コピーを作成
  Material copyWith({
    String? barcode,
    String? name,
    String? category,
  }) {
    return Material(
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      category: category ?? this.category,
    );
  }
}
