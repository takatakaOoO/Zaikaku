import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/product_provider.dart';
import 'product_edit_screen.dart';

/// 製品一覧画面
class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productListAsync = ref.watch(productListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('製品マスタ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: '製品を追加',
            onPressed: () => _navigateToEdit(context, null),
          ),
        ],
      ),
      body: productListAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('製品が登録されていません', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text('右上の「+」ボタンから追加してください'),
                ],
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(productListProvider.notifier).refresh(),
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.inventory),
                    ),
                    title: Text(product.name),
                    subtitle: Text('型番: ${product.modelNumber} / 材料: ${product.materialBarcodes.length}件'),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          _navigateToEdit(context, product.id);
                        } else if (value == 'delete') {
                          _confirmDelete(context, ref, product.id, product.name);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'edit', child: Text('編集')),
                        const PopupMenuItem(value: 'delete', child: Text('削除')),
                      ],
                    ),
                    onTap: () => _navigateToEdit(context, product.id),
                  ),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('エラー: $e')),
      ),
    );
  }

  void _navigateToEdit(BuildContext context, int? productId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductEditScreen(productId: productId),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    int id,
    String name,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('製品を削除'),
        content: Text('「$name」を削除してもよろしいですか？\n関連する材料情報もすべて削除されます。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('削除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(productListProvider.notifier).deleteProduct(id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('「$name」を削除しました')),
        );
      }
    }
  }
}
