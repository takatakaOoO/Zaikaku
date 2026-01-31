import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/providers/repository_providers.dart';
import 'providers/product_provider.dart';
import 'material_scan_screen.dart';
import 'ocr_scan_screen.dart';

/// 製品登録・編集画面
class ProductEditScreen extends ConsumerStatefulWidget {
  /// null の場合は新規作成、IDがある場合は編集
  final int? productId;

  const ProductEditScreen({super.key, this.productId});



  @override
  ConsumerState<ProductEditScreen> createState() => _ProductEditScreenState();
}



class _ProductEditScreenState extends ConsumerState<ProductEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _modelController = TextEditingController();
  final List<String> _materials = [];
  bool _isLoading = false;
  bool _isInitialized = false;

  bool get _isEditing => widget.productId != null;

  @override
  void dispose() {
    _nameController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 編集モードの場合、既存データを読み込む
    if (_isEditing && !_isInitialized) {
      final productAsync = ref.watch(productProvider(widget.productId!));
      return Scaffold(
        appBar: AppBar(title: const Text('製品編集')),
        body: productAsync.when(
          data: (product) {
            if (product == null) {
              return const Center(child: Text('製品が見つかりません'));
            }
            // 初回読み込み時のみデータをセット
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!_isInitialized) {
                _nameController.text = product.name;
                _modelController.text = product.modelNumber;
                _materials.clear();
                _materials.addAll(product.materialBarcodes);
                setState(() => _isInitialized = true);
              }
            });
            return const Center(child: CircularProgressIndicator());
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('エラー: $e')),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '製品編集' : '製品登録'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: '保存',
            onPressed: _isLoading ? null : _save,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // 製品名
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: '製品名 *',
                            border: OutlineInputBorder(),
                            hintText: '例: 製品A',
                          ),
                          validator: (v) =>
                              v == null || v.trim().isEmpty ? '製品名を入力してください' : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => _scanText(isJapanese: true, controller: _nameController),
                        icon: const Icon(Icons.document_scanner),
                        tooltip: '製品名OCR入力',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 型番
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _modelController,
                          decoration: const InputDecoration(
                            labelText: '型番 *',
                            border: OutlineInputBorder(),
                            hintText: '例: MODEL-001',
                          ),
                          validator: (v) =>
                              v == null || v.trim().isEmpty ? '型番を入力してください' : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () => _scanText(isJapanese: false, controller: _modelController),
                        icon: const Icon(Icons.document_scanner),
                        tooltip: '型番OCR入力',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 材料バーコードセクション
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '材料バーコード',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.add),
                            tooltip: '手入力で追加',
                            onPressed: _addMaterialManually,
                          ),
                          IconButton(
                            icon: const Icon(Icons.image_search),
                            tooltip: '画像から追加',
                            onPressed: _addMaterialByScan,
                          ),
                          IconButton(
                            icon: const Icon(Icons.camera_alt),
                            tooltip: 'カメラでスキャン',
                            onPressed: _addMaterialByCamera,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(),

                  if (_materials.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          '材料バーコードが登録されていません\n「+」ボタンから追加してください',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ..._materials.asMap().entries.map((entry) {
                      final index = entry.key;
                      final barcode = entry.value;
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(child: Text('${index + 1}')),
                          title: Text(barcode),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeMaterial(index),
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
    );
  }

  /// 手入力で材料を追加
  Future<void> _addMaterialManually() async {
    final controller = TextEditingController();
    final barcode = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('バーコードを入力'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'バーコード値',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('追加'),
          ),
        ],
      ),
    );

    if (barcode != null && barcode.isNotEmpty) {
      setState(() => _materials.add(barcode));
    }
  }

  /// 材料を削除
  void _removeMaterial(int index) {
    setState(() => _materials.removeAt(index));
  }

  /// 保存処理
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(productRepositoryProvider);
      final name = _nameController.text.trim();
      final modelNumber = _modelController.text.trim();

      if (_isEditing) {
        await repo.updateProduct(
          id: widget.productId!,
          name: name,
          modelNumber: modelNumber,
          materials: _materials,
        );
      } else {
        await repo.createProduct(
          name: name,
          modelNumber: modelNumber,
          materials: _materials,
        );
      }

      // リストを更新
      ref.invalidate(productListProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isEditing ? '製品を更新しました' : '製品を登録しました')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('エラー: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// カメラで材料をスキャン追加
  Future<void> _addMaterialByCamera() async {
    final List<String>? results = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MaterialScanScreen(),
      ),
    );

    if (results != null && results.isNotEmpty) {
      int addedCount = 0;
      for (final code in results) {
        if (!_materials.contains(code)) {
          setState(() => _materials.add(code));
          addedCount++;
        }
      }
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$addedCount件の材料を追加しました')),
        );
      }
    }
  }

  /// スキャンで材料を追加（画像選択から）
  Future<void> _addMaterialByScan() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image == null) return;

    // 画像からバーコードを解析
    try {
      final controller = MobileScannerController();
      final result = await controller.analyzeImage(image.path);
      await controller.dispose();

      if (result != null && result.barcodes.isNotEmpty) {
        int addedCount = 0;
        int duplicateCount = 0;

        for (final barcodeObj in result.barcodes) {
          final barcode = barcodeObj.rawValue;
          if (barcode != null && barcode.isNotEmpty) {
            if (_materials.contains(barcode)) {
              duplicateCount++;
            } else {
              setState(() => _materials.add(barcode));
              addedCount++;
            }
          }
        }

        if (mounted) {
          String message = '';
          if (addedCount > 0) message += '$addedCount件を追加しました。';
          if (duplicateCount > 0) message += '$duplicateCount件は登録済みでした。';
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('画像からバーコードが検出されませんでした')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('スキャンエラー: $e')),
        );
      }
    }
  }

  /// OCR画面を起動してテキストを入力
  Future<void> _scanText({required bool isJapanese, required TextEditingController controller}) async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => OCRScanScreen(isJapanese: isJapanese),
      ),
    );

    if (result != null && result.isNotEmpty) {
      // 改行を削除してセット
      controller.text = result.replaceAll('\n', ' ').trim();
    }
  }
}
