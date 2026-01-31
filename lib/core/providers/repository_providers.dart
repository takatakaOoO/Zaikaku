import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/mock_order_repository.dart';

/// モックデータリポジトリのプロバイダー
final mockOrderRepositoryProvider = Provider<MockOrderRepository>((ref) {
  return MockOrderRepository();
});
