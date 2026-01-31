import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scan_settings_provider.freezed.dart';
part 'scan_settings_provider.g.dart';

/// バーコード読み取り種別のフィルタリング設定
enum BarcodeTypeFilter {
  /// 自動（1D/2D両方を読み取る）
  auto,
  /// 1次元コードのみ
  only1D,
  /// 2次元コードのみ
  only2D,
}

/// スキャンモード（読み取り範囲と個数の制御）
enum ScanRangeMode {
  /// 単一（中央の狭い範囲に限定して1つだけ読み取る）
  singleNarrow,
  /// 複数（画面全域で複数を一度に読み取る）
  multiFull,
}

/// スキャン動作の高度な設定
@freezed
abstract class ScanSettings with _$ScanSettings {
  const factory ScanSettings({
    /// バーコード種別のフィルタ
    @Default(BarcodeTypeFilter.auto) BarcodeTypeFilter typeFilter,

    /// 読み取り範囲モード
    @Default(ScanRangeMode.singleNarrow) ScanRangeMode rangeMode,

    /// 1Dバーコードのチェックデジット検証を有効にするか
    @Default(true) bool enableCheckDigit,

    /// 1Dバーコードのパリティチェックを有効にするか
    @Default(true) bool enableParityCheck,

    /// スタート/ストップキャラクタの検証を有効にするか
    @Default(true) bool enableStartStopCheck,

    /// 連続スキャンの重複除外時間をミリ秒で指定 (0で無効)
    @Default(1000) int duplicateTimeoutMs,
  }) = _ScanSettings;

  factory ScanSettings.fromJson(Map<String, dynamic> json) =>
      _$ScanSettingsFromJson(json);
}

@Riverpod(keepAlive: true)
class ScanSettingsNotifier extends _$ScanSettingsNotifier {
  @override
  ScanSettings build() {
    // 初期設定
    return const ScanSettings();
  }

  /// 読み取り種別フィルタの更新
  void updateTypeFilter(BarcodeTypeFilter filter) {
    state = state.copyWith(typeFilter: filter);
  }

  /// スキャン範囲モードの更新
  void updateRangeMode(ScanRangeMode mode) {
    state = state.copyWith(rangeMode: mode);
  }

  /// チェックデジット検証の切り替え
  void toggleCheckDigit(bool enabled) {
    state = state.copyWith(enableCheckDigit: enabled);
  }

  /// パリティチェックの切り替え
  void toggleParityCheck(bool enabled) {
    state = state.copyWith(enableParityCheck: enabled);
  }

  /// スタート/ストップキャラクタ検証の切り替え
  void toggleStartStopCheck(bool enabled) {
    state = state.copyWith(enableStartStopCheck: enabled);
  }

  /// 重複タイムアウトの更新
  void updateDuplicateTimeout(int ms) {
    state = state.copyWith(duplicateTimeoutMs: ms);
  }
}
