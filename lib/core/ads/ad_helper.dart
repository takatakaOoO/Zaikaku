import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    // build-time configuration using --dart-define
    const androidId = String.fromEnvironment('ADMOB_BANNER_ID_ANDROID');
    const iosId = String.fromEnvironment('ADMOB_BANNER_ID_IOS');

    if (Platform.isAndroid) {
      if (androidId.isNotEmpty) return androidId;
      return 'ca-app-pub-3940256099942544/6300978111'; // Default Test ID
    } else if (Platform.isIOS) {
      if (iosId.isNotEmpty) return iosId;
      return 'ca-app-pub-3940256099942544/2934735716'; // Default Test ID
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
