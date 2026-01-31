# 実装計画書 - Phase 6: リリース準備とAdMob実装

## 目標
アプリの正式リリースに向けた仕上げ（アイコン、ドキュメント、ビルド）に加え、収益化のための **Google AdMob広告** を実装します。その後、リリース用ビルド（APK/AAB）を生成し、実機での最終動作確認を行います。

## User Review Required
> [!IMPORTANT]
> **AdMob App IDについて**:
> 実装およびテスト段階では **Google提供のテスト用App ID** を使用します。
> リリース時にはご自身のAdMob App IDへの差し替えが必要となります。
> *   Test App ID (Android): `ca-app-pub-3940256099942544~3347511713`

> [!IMPORTANT]
> **アプリアイコンについて**:
> `flutter_launcher_icons` による自動生成を行います。`assets/icon/icon.png` (1024x1024) が必要です。

## Proposed Changes

### 1. Google AdMobの導入
`google_mobile_ads` パッケージを導入し、バナー広告を表示します。

#### [MODIFY] [pubspec.yaml](file:///c:/Users/d-2/OriginalCode/Zaikaku/pubspec.yaml)
- `dependencies` に `google_mobile_ads` を追加。

#### [MODIFY] [android/app/src/main/AndroidManifest.xml](file:///c:/Users/d-2/OriginalCode/Zaikaku/android/app/src/main/AndroidManifest.xml)
- `<meta-data>` タグで AdMob App ID (テスト用) を追加。

#### [NEW] `lib/core/ads/ad_helper.dart` (仮)
- 広告ID（バナー用テストID）を管理するヘルパークラス。

#### [NEW] `lib/core/ads/banner_ad_widget.dart`
- 汎用的なバナー広告ウィジェットを作成。

#### [MODIFY] `lib/features/scan/presentation/scan_screen.dart` / `lib/features/history/presentation/history_screen.dart`
- 画面下部などに `BannerAdWidget` を配置。
- **注意**: スキャン画面はカメラオーバーレイがあるため、UIの干渉を避ける配置（例: 材料リストの下、またはオーバーレイの一部として配置）を検討します。まずは履歴画面やホーム画面などで検証します。

### 2. アプリアイコンの設定
`flutter_launcher_icons` パッケージでアイコンを生成します。

#### [MODIFY] [pubspec.yaml](file:///c:/Users/d-2/OriginalCode/Zaikaku/pubspec.yaml)
- `dev_dependencies` に `flutter_launcher_icons` を追加。
- 設定セクションを追加。

### 3. ドキュメント整備とリリースビルド

#### [MODIFY] [README.md](file:///c:/Users/d-2/OriginalCode/Zaikaku/README.md)
- 機能一覧更新（AdMob追加）。
- スクリーンショット更新。

#### [MODIFY] [android/app/build.gradle.kts](file:///c:/Users/d-2/OriginalCode/Zaikaku/android/app/build.gradle.kts)
- バージョンコード更新。

## Verification Plan

### Automated Tests
- `flutter test`: 既存テストの通過確認。

### Manual Verification
1. **広告表示確認**:
    - アプリ起動後、指定した画面（履歴画面等）の下部に「Test Ad」と書かれたバナーが表示されることを確認。
    - コンソールログに `ad_loaded` 等の成功ログが出ることを確認。
2. **スキャン画面UI確認**:
    - 広告表示がスキャン操作やボタン（シャッター等）と被らないことを確認。
3. **アイコン・リリース確認**:
    - 前回の計画通り、アイコン変更とリリースビルドのインストール確認。
