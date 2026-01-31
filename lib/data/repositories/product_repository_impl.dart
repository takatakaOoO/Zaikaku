import 'package:drift/drift.dart';
import '../../core/database/app_database.dart';
import '../../domain/models/product_with_materials.dart';
import '../../domain/repositories/product_repository.dart';

/// 製品リポジトリの実装
class ProductRepositoryImpl implements ProductRepository {
  final AppDatabase _db;

  ProductRepositoryImpl(this._db);

  @override
  Future<List<ProductWithMaterials>> getAllProducts() async {
    final productRows = await _db.select(_db.products).get();
    final results = <ProductWithMaterials>[];

    for (final row in productRows) {
      final materials = await _getMaterialsForProduct(row.id);
      results.add(_toProductWithMaterials(row, materials));
    }

    return results;
  }

  @override
  Future<ProductWithMaterials?> getProduct(int id) async {
    final query = _db.select(_db.products)..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();

    if (row == null) return null;

    final materials = await _getMaterialsForProduct(id);
    return _toProductWithMaterials(row, materials);
  }

  @override
  Future<int> createProduct({
    required String name,
    required String modelNumber,
    required List<String> materials,
  }) async {
    final now = DateTime.now();

    // トランザクション内で製品・材料を登録
    return await _db.transaction(() async {
      final productId = await _db.into(_db.products).insert(
        ProductsCompanion.insert(
          name: name,
          modelNumber: modelNumber,
          createdAt: Value(now),
          updatedAt: Value(now),
        ),
      );

      for (final barcode in materials) {
        await _db.into(_db.productMaterials).insert(
          ProductMaterialsCompanion.insert(
            productId: productId,
            barcode: barcode,
            createdAt: Value(now),
          ),
        );
      }

      return productId;
    });
  }

  @override
  Future<void> updateProduct({
    required int id,
    required String name,
    required String modelNumber,
    required List<String> materials,
  }) async {
    final now = DateTime.now();

    await _db.transaction(() async {
      // 製品情報を更新
      await (_db.update(_db.products)..where((t) => t.id.equals(id))).write(
        ProductsCompanion(
          name: Value(name),
          modelNumber: Value(modelNumber),
          updatedAt: Value(now),
        ),
      );

      // 既存の材料を削除
      await (_db.delete(_db.productMaterials)
            ..where((t) => t.productId.equals(id)))
          .go();

      // 新しい材料を追加
      for (final barcode in materials) {
        await _db.into(_db.productMaterials).insert(
          ProductMaterialsCompanion.insert(
            productId: id,
            barcode: barcode,
            createdAt: Value(now),
          ),
        );
      }
    });
  }

  @override
  Future<void> deleteProduct(int id) async {
    await _db.transaction(() async {
      // 材料を先に削除
      await (_db.delete(_db.productMaterials)
            ..where((t) => t.productId.equals(id)))
          .go();
      // 製品を削除
      await (_db.delete(_db.products)..where((t) => t.id.equals(id))).go();
    });
  }

  @override
  Future<List<String>> getMaterialBarcodes(int productId) async {
    return _getMaterialsForProduct(productId);
  }

  /// 製品IDから材料バーコードリストを取得
  Future<List<String>> _getMaterialsForProduct(int productId) async {
    final query = _db.select(_db.productMaterials)
      ..where((t) => t.productId.equals(productId));
    final rows = await query.get();
    return rows.map((r) => r.barcode).toList();
  }

  /// DBの行データをドメインモデルに変換
  ProductWithMaterials _toProductWithMaterials(
    Product row,
    List<String> materials,
  ) {
    return ProductWithMaterials(
      id: row.id,
      name: row.name,
      modelNumber: row.modelNumber,
      materialBarcodes: materials,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
