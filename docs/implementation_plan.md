# 実装計画書 - Zaikaku Project [承認済]

## 目標
工場内材料照合アプリ「Zaikaku」のAndroid版（将来的にiPhone対応）を **Flutter** を用いて開発する。
バーコード読み取りによる材料照合、合否の音声通知、ログの記録・送信機能を実装する。

## User Review Required
特にありませんが、UIデザインの方向性（「グラフィカルで機敏」）について、初期プロトタイプ段階で確認いただきたいです。

## Proposed Changes

### 技術スタック
- **Framework**: Flutter
- **Language**: Dart
- **State Management**: flutter_riverpod (状態管理とDI)
- **Barcode Scanning**: mobile_scanner (高速で使いやすい)
- **Audio**: audioplayers (効果音再生)
- **Database**: drift (SQLiteのラッパー、安全なDB操作) または sqflite
- **Settings**: shared_preferences (メールアドレス等の設定)
- **Design System**: Material 3

### Core Implementation Steps (Phase 1 & 2)

#### [NEW] [Flutter Project Config](file:///C:/Users/d-2/OriginalCode/Zaikaku/pubspec.yaml)
- `flutter create` でプロジェクトを初期化
- 依存パッケージの追加: `flutter_riverpod`, `mobile_scanner`, `audioplayers`, `intl`, `path_provider`, `share_plus`

#### [NEW] [Main Screen Structure](file:///C:/Users/d-2/OriginalCode/Zaikaku/lib/main.dart)
- `MaterialApp` with Material 3 theme.
- Navigation setup using `go_router` or basic Navigator.

## Verification Plan

### Automated Tests
- `flutter test` を用いた単体テスト（ロジック部分）

### Manual Verification
1. **ビルド検証**: `flutter build apk` でAndroidアプリが正しくビルドされること。
2. **エミュレータ検証**: Android Studioのエミュレータでアプリが起動し、クラッシュしないこと。
3. **UI動作確認**: 画面遷移やアニメーションがスムーズであること。
4. **実機検証**: 実機にてカメラ権限の取得とバーコードスキャン動作を確認する。
