import '../models/product_with_materials.dart';

/// 製品マスタリポジトリのインターフェース
abstract class ProductRepository {
  /// 全製品リストを取得
  Future<List<ProductWithMaterials>> getAllProducts();

  /// IDから製品を取得（材料リスト込み）
  Future<ProductWithMaterials?> getProduct(int id);

  /// 製品を新規登録し、IDを返す
  Future<int> createProduct({
    required String name,
    required String modelNumber,
    required List<String> materials,
  });

  /// 製品を更新
  Future<void> updateProduct({
    required int id,
    required String name,
    required String modelNumber,
    required List<String> materials,
  });

  /// 製品を削除（関連材料も削除）
  Future<void> deleteProduct(int id);

  /// 製品の材料バーコードリストのみを取得
  Future<List<String>> getMaterialBarcodes(int productId);
}
