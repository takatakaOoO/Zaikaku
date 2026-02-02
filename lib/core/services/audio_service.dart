import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

/// 音声テーマの定義
/// 
/// 複数のテーマを切り替えて使用可能
enum AudioTheme {
  /// デフォルトテーマ
  defaultTheme('default', 'デフォルト'),
  ;

  const AudioTheme(this.folderName, this.displayName);
  
  /// テーマのフォルダ名
  final String folderName;
  
  /// 表示名
  final String displayName;
}

/// 音声サービス
/// 
/// 正解音・不正解音の再生を管理します。
/// テーマ切り替え機能をサポートしています。
class AudioService {
  final AudioPlayer _correctPlayer = AudioPlayer();
  final AudioPlayer _incorrectPlayer = AudioPlayer();
  
  AudioTheme _currentTheme = AudioTheme.defaultTheme;
  
  /// 現在のテーマを取得
  AudioTheme get currentTheme => _currentTheme;
  
  /// テーマを変更
  void setTheme(AudioTheme theme) {
    _currentTheme = theme;
  }
  
  /// 正解音のアセットパスを取得
  String get _correctSoundPath => 
      'sounds/${_currentTheme.folderName}/correct.mp3';
  
  /// 不正解音のアセットパスを取得
  String get _incorrectSoundPath => 
      'sounds/${_currentTheme.folderName}/incorrect.mp3';
  
  /// 正解音を再生
  Future<void> playCorrectSound() async {
    try {
      await _correctPlayer.stop();
      await _correctPlayer.play(AssetSource(_correctSoundPath));
    } catch (e) {
      // 音声再生エラーは致命的ではないため、ログのみ
      debugPrint('正解音の再生に失敗: $e');
    }
  }
  
  /// 不正解音を再生
  Future<void> playIncorrectSound() async {
    try {
      await _incorrectPlayer.stop();
      await _incorrectPlayer.play(AssetSource(_incorrectSoundPath));
    } catch (e) {
      // 音声再生エラーは致命的ではないため、ログのみ
      debugPrint('不正解音の再生に失敗: $e');
    }
  }
  
  /// リソースを解放
  Future<void> dispose() async {
    await _correctPlayer.dispose();
    await _incorrectPlayer.dispose();
  }
}
