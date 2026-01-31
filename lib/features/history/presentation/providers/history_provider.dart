import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../domain/models/scan_history_entry.dart';
import '../../../../core/providers/repository_providers.dart';

part 'history_provider.g.dart';

/// スキャン履歴の状態を管理するNotifier (Riverpod 3.x StreamNotifier)
@riverpod
class History extends _$History {
  @override
  Stream<List<ScanHistoryEntry>> build() {
    final repository = ref.watch(scanHistoryRepositoryProvider);
    return repository.watchAllHistory();
  }

  /// 履歴を読み直す (Streamなので通常不要だが互換性のため残す)
  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  /// すべての履歴を消去
  Future<void> clearAll() async {
    await ref.read(scanHistoryRepositoryProvider).clearHistory();
    // Stream が自動的に空リストを流すはず
  }
}
