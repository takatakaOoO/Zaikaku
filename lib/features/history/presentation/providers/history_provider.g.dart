// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// スキャン履歴の状態を管理するNotifier (Riverpod 3.x StreamNotifier)

@ProviderFor(History)
const historyProvider = HistoryProvider._();

/// スキャン履歴の状態を管理するNotifier (Riverpod 3.x StreamNotifier)
final class HistoryProvider
    extends $StreamNotifierProvider<History, List<ScanHistoryEntry>> {
  /// スキャン履歴の状態を管理するNotifier (Riverpod 3.x StreamNotifier)
  const HistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'historyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$historyHash();

  @$internal
  @override
  History create() => History();
}

String _$historyHash() => r'6d6c507da52a2c6d32c0f3406a1cb0debd6661fb';

/// スキャン履歴の状態を管理するNotifier (Riverpod 3.x StreamNotifier)

abstract class _$History extends $StreamNotifier<List<ScanHistoryEntry>> {
  Stream<List<ScanHistoryEntry>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<List<ScanHistoryEntry>>, List<ScanHistoryEntry>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ScanHistoryEntry>>,
                List<ScanHistoryEntry>
              >,
              AsyncValue<List<ScanHistoryEntry>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
