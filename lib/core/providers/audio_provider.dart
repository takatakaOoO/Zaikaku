import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/audio_service.dart';

/// 音声サービスのProvider
/// 
/// アプリ全体で単一のAudioServiceインスタンスを提供します。
final audioServiceProvider = Provider<AudioService>((ref) {
  final audioService = AudioService();
  
  // プロバイダーが破棄される時にリソースを解放
  ref.onDispose(() {
    audioService.dispose();
  });
  
  return audioService;
});

/// 現在の音声テーマのProvider
final currentAudioThemeProvider = Provider<AudioTheme>((ref) {
  final audioService = ref.watch(audioServiceProvider);
  return audioService.currentTheme;
});
