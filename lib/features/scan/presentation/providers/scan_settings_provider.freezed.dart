// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scan_settings_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScanSettings {

/// バーコード種別のフィルタ
 BarcodeTypeFilter get typeFilter;/// 読み取り範囲モード
 ScanRangeMode get rangeMode;/// 1Dバーコードのチェックデジット検証を有効にするか
 bool get enableCheckDigit;/// 1Dバーコードのパリティチェックを有効にするか
 bool get enableParityCheck;/// スタート/ストップキャラクタの検証を有効にするか
 bool get enableStartStopCheck;/// 連続スキャンの重複除外時間をミリ秒で指定 (0で無効)
 int get duplicateTimeoutMs;
/// Create a copy of ScanSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScanSettingsCopyWith<ScanSettings> get copyWith => _$ScanSettingsCopyWithImpl<ScanSettings>(this as ScanSettings, _$identity);

  /// Serializes this ScanSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanSettings&&(identical(other.typeFilter, typeFilter) || other.typeFilter == typeFilter)&&(identical(other.rangeMode, rangeMode) || other.rangeMode == rangeMode)&&(identical(other.enableCheckDigit, enableCheckDigit) || other.enableCheckDigit == enableCheckDigit)&&(identical(other.enableParityCheck, enableParityCheck) || other.enableParityCheck == enableParityCheck)&&(identical(other.enableStartStopCheck, enableStartStopCheck) || other.enableStartStopCheck == enableStartStopCheck)&&(identical(other.duplicateTimeoutMs, duplicateTimeoutMs) || other.duplicateTimeoutMs == duplicateTimeoutMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,typeFilter,rangeMode,enableCheckDigit,enableParityCheck,enableStartStopCheck,duplicateTimeoutMs);

@override
String toString() {
  return 'ScanSettings(typeFilter: $typeFilter, rangeMode: $rangeMode, enableCheckDigit: $enableCheckDigit, enableParityCheck: $enableParityCheck, enableStartStopCheck: $enableStartStopCheck, duplicateTimeoutMs: $duplicateTimeoutMs)';
}


}

/// @nodoc
abstract mixin class $ScanSettingsCopyWith<$Res>  {
  factory $ScanSettingsCopyWith(ScanSettings value, $Res Function(ScanSettings) _then) = _$ScanSettingsCopyWithImpl;
@useResult
$Res call({
 BarcodeTypeFilter typeFilter, ScanRangeMode rangeMode, bool enableCheckDigit, bool enableParityCheck, bool enableStartStopCheck, int duplicateTimeoutMs
});




}
/// @nodoc
class _$ScanSettingsCopyWithImpl<$Res>
    implements $ScanSettingsCopyWith<$Res> {
  _$ScanSettingsCopyWithImpl(this._self, this._then);

  final ScanSettings _self;
  final $Res Function(ScanSettings) _then;

/// Create a copy of ScanSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? typeFilter = null,Object? rangeMode = null,Object? enableCheckDigit = null,Object? enableParityCheck = null,Object? enableStartStopCheck = null,Object? duplicateTimeoutMs = null,}) {
  return _then(_self.copyWith(
typeFilter: null == typeFilter ? _self.typeFilter : typeFilter // ignore: cast_nullable_to_non_nullable
as BarcodeTypeFilter,rangeMode: null == rangeMode ? _self.rangeMode : rangeMode // ignore: cast_nullable_to_non_nullable
as ScanRangeMode,enableCheckDigit: null == enableCheckDigit ? _self.enableCheckDigit : enableCheckDigit // ignore: cast_nullable_to_non_nullable
as bool,enableParityCheck: null == enableParityCheck ? _self.enableParityCheck : enableParityCheck // ignore: cast_nullable_to_non_nullable
as bool,enableStartStopCheck: null == enableStartStopCheck ? _self.enableStartStopCheck : enableStartStopCheck // ignore: cast_nullable_to_non_nullable
as bool,duplicateTimeoutMs: null == duplicateTimeoutMs ? _self.duplicateTimeoutMs : duplicateTimeoutMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ScanSettings].
extension ScanSettingsPatterns on ScanSettings {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScanSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScanSettings() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScanSettings value)  $default,){
final _that = this;
switch (_that) {
case _ScanSettings():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScanSettings value)?  $default,){
final _that = this;
switch (_that) {
case _ScanSettings() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BarcodeTypeFilter typeFilter,  ScanRangeMode rangeMode,  bool enableCheckDigit,  bool enableParityCheck,  bool enableStartStopCheck,  int duplicateTimeoutMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScanSettings() when $default != null:
return $default(_that.typeFilter,_that.rangeMode,_that.enableCheckDigit,_that.enableParityCheck,_that.enableStartStopCheck,_that.duplicateTimeoutMs);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BarcodeTypeFilter typeFilter,  ScanRangeMode rangeMode,  bool enableCheckDigit,  bool enableParityCheck,  bool enableStartStopCheck,  int duplicateTimeoutMs)  $default,) {final _that = this;
switch (_that) {
case _ScanSettings():
return $default(_that.typeFilter,_that.rangeMode,_that.enableCheckDigit,_that.enableParityCheck,_that.enableStartStopCheck,_that.duplicateTimeoutMs);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BarcodeTypeFilter typeFilter,  ScanRangeMode rangeMode,  bool enableCheckDigit,  bool enableParityCheck,  bool enableStartStopCheck,  int duplicateTimeoutMs)?  $default,) {final _that = this;
switch (_that) {
case _ScanSettings() when $default != null:
return $default(_that.typeFilter,_that.rangeMode,_that.enableCheckDigit,_that.enableParityCheck,_that.enableStartStopCheck,_that.duplicateTimeoutMs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScanSettings implements ScanSettings {
  const _ScanSettings({this.typeFilter = BarcodeTypeFilter.auto, this.rangeMode = ScanRangeMode.singleNarrow, this.enableCheckDigit = true, this.enableParityCheck = true, this.enableStartStopCheck = true, this.duplicateTimeoutMs = 1000});
  factory _ScanSettings.fromJson(Map<String, dynamic> json) => _$ScanSettingsFromJson(json);

/// バーコード種別のフィルタ
@override@JsonKey() final  BarcodeTypeFilter typeFilter;
/// 読み取り範囲モード
@override@JsonKey() final  ScanRangeMode rangeMode;
/// 1Dバーコードのチェックデジット検証を有効にするか
@override@JsonKey() final  bool enableCheckDigit;
/// 1Dバーコードのパリティチェックを有効にするか
@override@JsonKey() final  bool enableParityCheck;
/// スタート/ストップキャラクタの検証を有効にするか
@override@JsonKey() final  bool enableStartStopCheck;
/// 連続スキャンの重複除外時間をミリ秒で指定 (0で無効)
@override@JsonKey() final  int duplicateTimeoutMs;

/// Create a copy of ScanSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScanSettingsCopyWith<_ScanSettings> get copyWith => __$ScanSettingsCopyWithImpl<_ScanSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScanSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScanSettings&&(identical(other.typeFilter, typeFilter) || other.typeFilter == typeFilter)&&(identical(other.rangeMode, rangeMode) || other.rangeMode == rangeMode)&&(identical(other.enableCheckDigit, enableCheckDigit) || other.enableCheckDigit == enableCheckDigit)&&(identical(other.enableParityCheck, enableParityCheck) || other.enableParityCheck == enableParityCheck)&&(identical(other.enableStartStopCheck, enableStartStopCheck) || other.enableStartStopCheck == enableStartStopCheck)&&(identical(other.duplicateTimeoutMs, duplicateTimeoutMs) || other.duplicateTimeoutMs == duplicateTimeoutMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,typeFilter,rangeMode,enableCheckDigit,enableParityCheck,enableStartStopCheck,duplicateTimeoutMs);

@override
String toString() {
  return 'ScanSettings(typeFilter: $typeFilter, rangeMode: $rangeMode, enableCheckDigit: $enableCheckDigit, enableParityCheck: $enableParityCheck, enableStartStopCheck: $enableStartStopCheck, duplicateTimeoutMs: $duplicateTimeoutMs)';
}


}

/// @nodoc
abstract mixin class _$ScanSettingsCopyWith<$Res> implements $ScanSettingsCopyWith<$Res> {
  factory _$ScanSettingsCopyWith(_ScanSettings value, $Res Function(_ScanSettings) _then) = __$ScanSettingsCopyWithImpl;
@override @useResult
$Res call({
 BarcodeTypeFilter typeFilter, ScanRangeMode rangeMode, bool enableCheckDigit, bool enableParityCheck, bool enableStartStopCheck, int duplicateTimeoutMs
});




}
/// @nodoc
class __$ScanSettingsCopyWithImpl<$Res>
    implements _$ScanSettingsCopyWith<$Res> {
  __$ScanSettingsCopyWithImpl(this._self, this._then);

  final _ScanSettings _self;
  final $Res Function(_ScanSettings) _then;

/// Create a copy of ScanSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? typeFilter = null,Object? rangeMode = null,Object? enableCheckDigit = null,Object? enableParityCheck = null,Object? enableStartStopCheck = null,Object? duplicateTimeoutMs = null,}) {
  return _then(_ScanSettings(
typeFilter: null == typeFilter ? _self.typeFilter : typeFilter // ignore: cast_nullable_to_non_nullable
as BarcodeTypeFilter,rangeMode: null == rangeMode ? _self.rangeMode : rangeMode // ignore: cast_nullable_to_non_nullable
as ScanRangeMode,enableCheckDigit: null == enableCheckDigit ? _self.enableCheckDigit : enableCheckDigit // ignore: cast_nullable_to_non_nullable
as bool,enableParityCheck: null == enableParityCheck ? _self.enableParityCheck : enableParityCheck // ignore: cast_nullable_to_non_nullable
as bool,enableStartStopCheck: null == enableStartStopCheck ? _self.enableStartStopCheck : enableStartStopCheck // ignore: cast_nullable_to_non_nullable
as bool,duplicateTimeoutMs: null == duplicateTimeoutMs ? _self.duplicateTimeoutMs : duplicateTimeoutMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
