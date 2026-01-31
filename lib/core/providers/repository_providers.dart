import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/mock_order_repository.dart';
import '../../data/repositories/scan_history_repository_impl.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/repositories/scan_history_repository.dart';
import '../../domain/repositories/product_repository.dart';
import '../database/app_database.dart';

/// モックデータリポジトリのプロバイダー
final mockOrderRepositoryProvider = Provider<MockOrderRepository>((ref) {
  return MockOrderRepository();
});

/// スキャン履歴リポジトリのプロバイダー
final scanHistoryRepositoryProvider = Provider<ScanHistoryRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ScanHistoryRepositoryImpl(db);
});

/// 製品マスタリポジトリのプロバイダー
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ProductRepositoryImpl(db);
});
