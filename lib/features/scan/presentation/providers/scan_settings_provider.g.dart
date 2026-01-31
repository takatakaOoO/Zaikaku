// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_settings_provider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScanSettings _$ScanSettingsFromJson(Map<String, dynamic> json) =>
    _ScanSettings(
      typeFilter:
          $enumDecodeNullable(_$BarcodeTypeFilterEnumMap, json['typeFilter']) ??
          BarcodeTypeFilter.auto,
      rangeMode:
          $enumDecodeNullable(_$ScanRangeModeEnumMap, json['rangeMode']) ??
          ScanRangeMode.singleNarrow,
      enableCheckDigit: json['enableCheckDigit'] as bool? ?? true,
      enableParityCheck: json['enableParityCheck'] as bool? ?? true,
      enableStartStopCheck: json['enableStartStopCheck'] as bool? ?? true,
      duplicateTimeoutMs: (json['duplicateTimeoutMs'] as num?)?.toInt() ?? 1000,
      exportEmail: json['exportEmail'] as String? ?? '',
    );

Map<String, dynamic> _$ScanSettingsToJson(_ScanSettings instance) =>
    <String, dynamic>{
      'typeFilter': _$BarcodeTypeFilterEnumMap[instance.typeFilter]!,
      'rangeMode': _$ScanRangeModeEnumMap[instance.rangeMode]!,
      'enableCheckDigit': instance.enableCheckDigit,
      'enableParityCheck': instance.enableParityCheck,
      'enableStartStopCheck': instance.enableStartStopCheck,
      'duplicateTimeoutMs': instance.duplicateTimeoutMs,
      'exportEmail': instance.exportEmail,
    };

const _$BarcodeTypeFilterEnumMap = {
  BarcodeTypeFilter.auto: 'auto',
  BarcodeTypeFilter.only1D: 'only1D',
  BarcodeTypeFilter.only2D: 'only2D',
};

const _$ScanRangeModeEnumMap = {
  ScanRangeMode.singleNarrow: 'singleNarrow',
  ScanRangeMode.multiFull: 'multiFull',
};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ScanSettingsNotifier)
const scanSettingsProvider = ScanSettingsNotifierProvider._();

final class ScanSettingsNotifierProvider
    extends $NotifierProvider<ScanSettingsNotifier, ScanSettings> {
  const ScanSettingsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'scanSettingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$scanSettingsNotifierHash();

  @$internal
  @override
  ScanSettingsNotifier create() => ScanSettingsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScanSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScanSettings>(value),
    );
  }
}

String _$scanSettingsNotifierHash() =>
    r'82493beadb5ccde731daef7309250efa0645c490';

abstract class _$ScanSettingsNotifier extends $Notifier<ScanSettings> {
  ScanSettings build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ScanSettings, ScanSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ScanSettings, ScanSettings>,
              ScanSettings,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
