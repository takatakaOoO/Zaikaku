import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/providers/repository_providers.dart';
import '../../../../domain/models/product_with_materials.dart';

part 'product_provider.g.dart';

/// 製品リストの状態を管理するプロバイダー
@riverpod
class ProductList extends _$ProductList {
  @override
  Future<List<ProductWithMaterials>> build() async {
    final repo = ref.watch(productRepositoryProvider);
    return repo.getAllProducts();
  }

  /// リストを再読み込み
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(productRepositoryProvider);
      return repo.getAllProducts();
    });
  }

  /// 製品を削除
  Future<void> deleteProduct(int id) async {
    final repo = ref.read(productRepositoryProvider);
    await repo.deleteProduct(id);
    await refresh();
  }
}

/// 単一製品の取得（編集画面用）
@riverpod
Future<ProductWithMaterials?> product(Ref ref, int id) async {
  final repo = ref.watch(productRepositoryProvider);
  return repo.getProduct(id);
}
