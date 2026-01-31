# 実装計画書 - Phase 7: ストア公開準備と製品化設定

本番リリースのために必要な法的対応、ドキュメント作成、および署名・ビルド設定を行います。

## Proposed Changes

### [Component] 法的・ドキュメント対応
- **[NEW] [USER_MANUAL.md](file:///c:/Users/d-2/OriginalCode/Zaikaku/docs/USER_MANUAL.md)**: 操作手順をまとめた取扱説明書
- **[NEW] [PRIVACY_POLICY.md](file:///c:/Users/d-2/OriginalCode/Zaikaku/docs/PRIVACY_POLICY.md)**: AdMob利用等を含むプライバシーポリシー
- **[MODIFY] [HomeScreen](file:///c:/Users/d-2/OriginalCode/Zaikaku/lib/features/home/presentation/home_screen.dart)**: 「法的情報」メニューを追加し、`showLicensePage` およびポリシー閲覧機能へ誘導

### [Component] ストア・ビルド設定
- **[NEW] [key.properties](file:///c:/Users/d-2/OriginalCode/Zaikaku/android/key.properties)**: 署名鍵情報の定義（パス、パスワードなど）
- **[MODIFY] [build.gradle.kts](file:///c:/Users/d-2/OriginalCode/Zaikaku/android/app/build.gradle.kts)**: `signingConfigs` および `buildTypes` のリリース設定追加
- **[MODIFY] [ad_helper.dart](file:///c:/Users/d-2/OriginalCode/Zaikaku/lib/core/ads/ad_helper.dart)**: 本番用広告ユニットIDの定義箇所を追加（現在はコメントアウト、または定数化）

## Verification Plan

### Automated Tests
- `flutter build appbundle --release`: リリース用バンドルが正常に生成されることの確認。

### Manual Verification
- アプリ内の追加メニューからライセンス情報が正しく表示されることを確認。
- プライバシーポリシーのテキストが正しく表示されることを確認。
- 本番用IDに切り替えた際、ビルドエラーが発生しないことを確認。
