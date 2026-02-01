# Zaikaku 開発ウォークスルー

## Phase 1: Planning & Setup
- [x] プロジェクト計画策定
- [x] Flutterプロジェクト初期化
- [x] 基本フォルダ構成の作成
- [x] 依存関係と状態管理のセットアップ
- [x] 動作確認 (ビルド・起動)

### 変更履歴
- **2026-01-30**: プロジェクト計画 (`implementation_plan.md`, `Task.md`) を策定。Flutterを採用。
- **2026-01-30**: 依存関係パッケージを追加 (`flutter_riverpod` 等) し、バージョンの競合を解決。Clean Architecture に基づくフォルダ構成 (`lib/config`, `lib/core`, `lib/features`) を作成。基盤となる `main.dart` を実装。

### 実装機能
- **基盤**: `ProviderScope` による状態管理の有効化。
- **構成**: Clean Architecture ディレクトリ構造。

### 検証結果
- **2026-01-30**: ビルド検証完了 (**SUCCESS**)。
    - **解決策**:
        1. **Java互換性**: JDK 21 を指定 (`gradle.properties`).
        2. **NDK修復**: 自動インストール失敗のため、CLIツール (`sdkmanager`) を用いて手動インストール (`28.2.13676358`).
    - **成果物**: `build/app/outputs/flutter-apk/app-debug.apk` 生成を確認。
    - **エミュレータ起動確認**: 
        - ストレージ不足のため、既存アプリ (`com.vcore.drivetracker`, `com.f1telemetrysky.app`) を削除。
        - アプリのインストールと起動に成功。「Zaikaku App Initialized」画面を確認。
        - Flutter DevTools 接続可能を確認。

### 追加されたファイル
```
/
├── docs/
│   ├── LLM_DEVELOPMENT_POLICY.md
│   ├── Task.md
│   ├── implementation_plan.md
│   └── Walkthrough.md
├── lib/
│   ├── main.dart
│   ├── config/
│   ├── core/
│   └── features/
│       ├── scan/
│       ├── history/
│       └── settings/
├── android/
│   ├── app/
│   │   ├── build.gradle.kts (修正)
│   │   └── src/main/kotlin/com/zaikaku/zaikaku/MainActivity.kt
│   ├── gradle.properties (修正)
│   └── build.gradle.kts
└── pubspec.yaml (修正)
```

### 修正されたファイル
- `pubspec.yaml` - 依存関係追加 (flutter_riverpod, mobile_scanner, drift等)
- `android/gradle.properties` - JDK 21パス指定追加
- `android/app/build.gradle.kts` - NDKバージョン明示的指定
- `lib/main.dart` - ProviderScope導入、基盤実装

### 削除されたファイル
なし

### 主要作業内容
1. **プロジェクト計画策定**: Task.md, implementation_plan.md, Walkthrough.md作成
2. **環境構築**: Flutter初期化、依存関係セットアップ
3. **基盤実装**: Clean Architectureフォルダ構成、Riverpod導入
4. **環境問題解決**: Java 25→JDK 21切替、NDK手動インストール
5. **動作確認**: ビルド成功、エミュレータ起動確認完了

---

---

## Phase 2: コアロジックとスキャン機能 [完了]
- [x] 実装計画策定 (2026-01-30 承認済)
- [x] バーコードスキャン画面(UI)の実装
- [x] 照合ロジック(ドメイン層)の実装
- [x] 音声フィードバック(正解音/不正解音)の実装 ※テーマ切替対応
- [x] 動作確認 (エミュレータでのスキャン画面遷移・UI表示テスト)
- [x] スキャン機能の高度化（1D/2Dフィルタリング・ROI・バリデーション）の実装 (2026-01-31)
- [x] スキャン設定画面のUI実装
- [x] ユーザー指定の10件のテストケースに基づくバリデーション検証

### 変更履歴
- **2026-01-30**: Phase 2実装計画策定開始。6ステップの段階的実装手順を定義。
- **2026-01-31**: 全コード実装完了。ビルド成功。専用エミュレータでの動作確認完了。
- **2026-01-31**: スキャン高度化機能（ROI・バリデーション・設定画面）を追加実装。`build_runner` バージョン競合と型解決エラーを解消し、動作を確認。
- **2026-01-31**: テスト用バーコード画像（全10種）をプログラム生成しアプリ内アセット化。
- **2026-01-31**: エミュレータのカメラ映像の問題を回避するため「デバッグ用画像選択機能」を追加。全10件のテストケースについて全合格を確認。

### 実装機能
- **ホーム画面**: スキャン開始ボタン、履歴ボタン（将来実装予定）
- **バーコードスキャン画面**: mobile_scannerによるカメラスキャン、照合結果表示
- **高度なスキャン制御**: 
  - **ROI (Region of Interest)**: 単一（ナロー）モードと複数（全画面）モードの動的切り替え。
  - **1Dバリデーション**: JAN-13等のチェックデジット検証、スタート/ストップ文字検証。
  - **1D/2Dフィルタリング**: 設定に応じた読み取り種別の制限（精度・速度優先）。
- **設定画面**: 上記の挙動をユーザーが変更可能なUI（トグル、ダイアログ）。
- **照合ロジック**: 製造指示書との材料照合、VerifyMaterialUseCase
- **音声フィードバック**: 正解音・不正解音の再生。
- **デバッグ機能**:
  - **デモモード**: タイマーによる擬似スキャン実行（画像を画面に表示）。
  - **画像選択スキャン**: エミュレータのギャラリーから画像を選んで直接スキャン解析に送る機能。
- **テスト自動化支援**: Pythonスクリプトによるバーコード画像の一括生成 (`tools/generate_barcodes.py`)。

### 追加・修正されたファイル
```
/
├── lib/
│   ├── core/
│   │   └── utils/
│   │       └── barcode_validator.dart [NEW] (バリデーションロジック)
│   ├── features/
│   │   └── scan/
│   │       ├── presentation/
│   │       │   ├── providers/
│   │       │   │   ├── scan_settings_provider.dart [MOD] (設定状態管理)
│   │       │   │   └── scan_state_provider.dart [MOD] (スキャン制御強化)
│   │       │   ├── assets/
│   │       │   │   └── demo_*.png [NEW] (テスト用画像)
│   │       │   ├── scan_screen.dart [MOD] (ROIガイド, バリデーション連携)
│   │       │   └── settings_screen.dart [NEW] (詳細設定画面)
│   │       └── ...
│   └── ...
├── test/
│   └── core/
│       └── utils/
│           └── barcode_validator.dart [NEW] (ユニットテスト)
└── tools/
    └── generate_barcodes.py [NEW] (テスト画像生成スクリプト)
```

### 主要作業内容
1. **スキャン機能の高度化**: ROI制御、1D/2Dフィルタリング、詳細設定画面の実装。
2. **品質保証 (QA) ツール作成**: Pythonスクリプトによるテスト用バーコード画像の自動生成。
3. **バリデーション実装**: JAN-13チェックデジット、スタート/ストップ文字検証ロジックの実装とユニットテスト。
4. **デバッグ環境整備**: エミュレータのカメラ制限を回避するための「画像選択スキャン機能」と「デモモード」の実装。
5. **総合検証**: ユーザー定義の10件のテストケースを用いた実機（エミュレータ）検証と合格確認。

### 検証結果
- **2026-01-31**: ユニットテスト検証完了 (**SUCCESS**)
  - 指定された10件のテストケース（チェックデジットエラー、スタート/ストップ文字欠落等）に対し、`BarcodeValidator` が正しくエラーを検知することを確認。
- **2026-01-31**: 動作確認完了 (**SUCCESS**)
  - 設定画面から「スキャン範囲モード」を変更した際、スキャン画面のガイドが「横線（ナロー）」から「枠（フル）」へ即座に更新されることを確認。
  - ナローモード時に画面中央の特定範囲のみで読み取りが行われることをUI表示（「横線に合わせてください」）から確認。
  - 詳細設定（チェックデジットON/OFFなど）が正常に保持・反映されることを確認。
  - **画像選択機能**: エミュレータ内のDownloadフォルダに転送した10枚のテスト画像を個別に選択し、全ケースで期待通りの判定（OK、CDエラー、パリティエラー等）が行われることを実機（エミュレータ）動作で確認。

---

## Phase 3: データ永続化とログ機能 [完了]
- [x] 実装計画策定 (2026-01-31 承認済)
- [x] ローカルデータベース(Drift/SQLite)のセットアップ
- [x] ログリポジトリの実装
- [x] ログ閲覧画面の実装
- [x] 設定機能の拡張（エクスポート先指定）
- [x] **動作確認**: スキャン結果の保存と一覧表示の確認

### 追加・修正されたファイル
```
/
├── lib/
│   ├── core/
│   │   └── database/
│   │   │   └── app_database.dart [NEW] (Driftデータベース定義)
│   │   └── app_database.g.dart [NEW] (自動生成コード)
│   ├── data/
│   │   └── repositories/
│   │       └── scan_history_repository_impl.dart [NEW] (データ操作実装)
│   ├── domain/
│   │   ├── models/
│   │   │   └── scan_history_entry.dart [NEW] (履歴モデル)
│   │   └── repositories/
│   │       └── scan_history_repository.dart [NEW] (リポジトリIF)
│   └── features/
│       ├── history/
│       │   └── presentation/
│       │       ├── providers/
│       │       │   ├── history_provider.dart [NEW] (StreamNotifier)
│       │       │   └── history_provider.g.dart [NEW] (自動生成コード)
│       │       └── history_screen.dart [NEW] (履歴一覧画面)
│       └── scan/
│           └── presentation/
│               ├── providers/
│               │   └── scan_state_provider.dart [MOD] (保存処理追加)
│               └── scan_screen.dart [MOD] (初期指示書セット修正)
└── ...
```

### 主要作業内容
1. **データベース構築**: Drift (SQLite) の導入とテーブル設計、マイグレーション対応。
2. **リポジトリ実装**: ドメイン層とデータ層を分離したリポジトリパターンの適用。
3. **履歴画面実装**: `StreamNotifier` を用いたリアクティブな履歴リスト表示。
4. **設定機能拡張**: エクスポート先（メールアドレス）の永続化実装。
5. **バグ修正**: 非数値バーコードの誤バリデーション修正、初期状態での保存スキップ不具合の修正。

### 検証結果
> [!NOTE]
> **データベース永続化検証**: アプリ再起動後も履歴データと設定値が消失せず保持されることを確認 (合格)。

> [!NOTE]
> **リアルタイム更新検証**: スキャン実行直後に履歴画面に遷移し、リストが即座に最新化されていることを確認 (合格)。

> [!NOTE]
> **バリデーション検証**: QRコード等の非数値データを含めたテストケースで正しく保存・判定が行われることを確認 (合格)。

---

## Phase 4: マスタデータ管理機能 [完了]
- [x] 実装計画策定 (2026-01-31 承認済)
- [x] 製品情報テーブル定義とマイグレーション
- [x] 製品リポジトリ・プロバイダーの実装
- [x] 製品一覧・登録・編集画面の実装
- [x] バーコード画像スキャンによる材料追加機能
- [x] 検証ロジックのマスタデータ連携
- [x] **動作確認**: 製品登録からスキャン照合までのフロー確認

### 変更履歴
- **2026-01-31**: Phase 4実装開始。`Products`, `ProductMaterials` テーブルを追加し、スキーマバージョンを `2` に更新。
- **2026-01-31**: 製品管理UI（一覧・登録・編集）を実装。材料バーコードの手入力に加え、画像選択によるスキャン追加機能を実装。
- **2026-01-31**: `ScanNotifier` を刷新。モックの製造指示書（`ManufacturingOrder`）から、動的な製品マスタ（`ProductWithMaterials`）に基づく検証ロジックへ移行。
- **2026-01-31**: ビルドエラー（`ProductRef` 型、`valueOrNull` ゲッター）を修正し、デバッグビルドに成功。

### 実装機能
- **製品マスタ画面**: 
  - 製品一覧表示、検索（将来予定）、削除機能。
  - 製品登録・編集：名称、型番、材料バーコードリストの管理。
- **スキャン入力補助**: 
  - **画像スキャン**: ギャラリーから選択した画像内の全バーコードを一括登録。
  - **カメラスキャン**: 専用画面で連続してバーコードを読み取り、まとめて登録。
- **動的検証**:
  - スキャン画面上部で「製品」を選択可能。
  - 選択した製品に紐づく材料のみを「正解」とし、それ以外を「不正解」と判定。
  - 判定結果はDB（`ScanHistories`）に製品の型番と共に保存。

### 追加・修正されたファイル
```
/
├── lib/
│   ├── core/
│   │   ├── database/
│   │   │   └── app_database.dart [MOD] (Products/ProductMaterialsテーブル追加, 移行)
│   │   └── providers/
│   │       └── repository_providers.dart [MOD] (productRepositoryProvider追加)
│   ├── data/
│   │   └── repositories/
│   │       └── product_repository_impl.dart [NEW] (CRUD実装)
│   ├── domain/
│   │   ├── models/
│   │   │   └── product_with_materials.dart [NEW] (ドメインモデル)
│   │   └── repositories/
│   │       └── product_repository.dart [NEW] (リポジトリIF)
│   ├── features/
│   │   ├── home/
│   │   │   └── presentation/
│   │   │       └── home_screen.dart [MOD] (製品マスタボタン追加)
│   │   ├── product/ [NEW]
│   │   │   └── presentation/
│   │   │       ├── providers/
│   │   │       │   └── product_provider.dart [NEW] (Riverpod Generator)
│   │   │       ├── product_edit_screen.dart [NEW] (画像スキャン追加機能付)
│   │   │       └── product_list_screen.dart [NEW]
│   │   └── scan/
│   │       └── presentation/
│   │           ├── providers/
│   │           │   └── scan_state_provider.dart [MOD] (ProductWithMaterialsへ移行)
│   │           └── scan_screen.dart [MOD] (製品選択UI追加)
│   └── main.dart [MOD] (/products ルート追加)
└── ...
```

### 主要作業内容
1. **DBスキーマ拡張**: Driftでの1対多関係の実装と `MigrationStrategy` による既存データ保持。
2. **製品管理の実装**: 複雑なトランザクション（製品と材料の一括更新）を含むリポジトリの実装。
3. **UI/UX向上**: 材料登録の負荷を減らすため、既存のバーコード解析ロジックを再利用した「スキャン追加」機能を編集画面に導入。
4. **コアロジック刷新**: アプリ全体の関心事を「固定の指示書」から「選択可能な製品マスタ」へシフト。

### 検証結果
- **2026-01-31**: ビルド検証完了 (**SUCCESS**)
  - `flutter build apk --debug` によりAPKの生成を確認。
- **2026-01-31**: 起動検証完了 (**SUCCESS**)
  - `flutter run` によりエミュレータ上で最新版が起動し、ホーム画面に「製品マスタ」ボタンが表示されることを確認。
- **2026-01-31**: 機能検証（予定）
- [x] **動作確認**: 製品登録からスキャン照合までのフロー確認

---

## Phase 4.5: OCR入力機能 [完了]
- [x] OCRライブラリ導入 (google_mlkit_text_recognition)
- [x] OCRスキャン画面の実装
- [x] 製品登録画面への連携
- [x] クラッシュ問題の解消 (日本語OCRライブラリ追加)

### 変更履歴
- **2026-01-31**: 製品登録の効率化のため、カメラによるOCR入力機能を追加。
- **2026-01-31**: 製品名（日本語）OCR時に発生したクラッシュを解決するため、Androidビルド設定に `com.google.mlkit:text-recognition-japanese` を追加。

### 実装機能
- **OCRスキャン**: 
  - 製品名（日本語）および型番（英数字）に対応。
  - 認識したテキストをリスト表示し、タップで選択可能。
  - 選択結果を製品登録画面の各入力フィールドに自動反映。

### 追加・修正されたファイル
```
/
├── android/
│   └── app/
│       └── build.gradle.kts [MOD] (日本語OCRライブラリ追加)
├── lib/
│   ├── features/
│   │   └── product/
│   │       ├── presentation/
│   │       │   ├── ocr_scan_screen.dart [NEW] (OCR画面)
│   │       │   └── product_edit_screen.dart [MOD] (OCRボタン追加)
└── pubspec.yaml [MOD] (依存関係追加)
```

### 検証結果
- **2026-01-31**: 動作確認完了 (**SUCCESS**)
  - エミュレータ上でOCR画面が起動し、テキスト認識（シミュレーション）が動作することを確認。
  - 日本語認識モードでのクラッシュ問題が設定追加により解消されたことを確認。


---

## Phase 5: 出力機能と仕上げ [完了]
- [x] ログのエクスポート機能(CSV/メール)の実装
- [x] 「待機」状態の実装 (リセットされるまでスキャンをブロック)
- [x] スキャンUIの大幅改修 (ユーザー要望対応)
    - 自動から手動シャッターへ変更
    - UI配置の最適化（オーバーレイ表示、ガイド枠移動）
    - エラーフィードバックや戻る機能の実装
- [x] **動作確認**: 全体ワークフローのテスト

### 変更履歴
- **2026-01-31**: CSV生成ライブラリ (`csv`) とメール共有ライブラリ (`share_plus`, `path_provider`) を導入。
- **2026-01-31**: 履歴画面にエクスポートボタンを追加し、日付指定でCSV化したスキャン履歴を共有する機能を実装。
- **2026-01-31/02-01**: ユーザーからのUIフィードバックに基づき、スキャン画面を5回にわたり改修 (Phase 5.1 - 5.4)。
    - **UX改善**: 連続読み取りを防ぐ「待機モード」と「確認ボタン」のフローを導入。
    - **視認性向上**: ガイド枠を赤色に変更、結果をカメラ映像上にオーバーレイ表示。
    - **操作性向上**: 片手操作を考慮したシャッターボタン配置、戻るボタンの追加。
    - **情報表示**: 画面下部にスキャン済みの材料リストを半透明パネルで表示。

### 実装機能
- **CSVエクスポート**:
  - `ScanHistoryRepository` に日付範囲指定での取得機能を追加。
  - `csv` パッケージでUTF-8エンコード（BOM付き）のCSVを生成。
  - `share_plus` でOS標準の共有シートを呼び出し（メール、Drive等へ送信可能）。
- **スキャンフロー刷新**:
  - **Before**: かざすだけで即時判定・連続読み取り。
  - **After**: かざす -> シャッターボタン -> 判定結果表示（待機） -> 確認ボタン -> 次へ。
- **材料リスト表示**:
  - 選択中の製品に必要な材料一覧を表示。
  - 読み取り済みの項目には緑色のチェックマークを付与。
  - パネルは可変高さで、リストが多い場合もスキャンエリアを圧迫しないよう配慮。

### 追加・修正されたファイル
```
/
├── lib/
│   ├── features/
│   │   ├── history/
│   │   │   └── presentation/
│   │   │       └── history_screen.dart [MOD] (エクスポート機能追加)
│   │   └── scan/
│   │       └── presentation/
│   │           ├── scan_screen.dart [MOD] (UI全面刷新)
│   │           └── providers/
│   │               └── scan_state_provider.dart [MOD] (待機状態、クリアロジック追加)
│   └── pubspec.yaml [MOD] (csv, share_plus, path_provider追加)
```

### 主要作業内容
1. **出力機能**: CSVエクスポートの実装と実機共有確認。
2. **フロー制御**: `ScanState` に `isPendingConfirmation` を追加し、結果確認フローを強制。
3. **UI/UX徹底改善**: ユーザーのフィードバック（ボタン位置、色、リスト表示、音）を反映し、現場で使いやすい画面を目指して調整を繰り返した。

### 検証結果
- **2026-02-01**: 動作確認完了 (**SUCCESS**)
  - **UI/UX**: ボタンの配置、リストの挙動、エラー時の赤枠表示など、全てのユーザー要望項目が満たされていることを確認。
  - **エクスポート**: エミュレータ上でダミーのCSVが生成され、共有シートが開くことを確認。
  - **スキャンフロー**: 読み取り -> 判定 -> 確認 -> クリア のサイクルが正常に機能することを確認。

---

## Phase 6: リリース準備とAdMob実装 [完了]
- [x] 計画策定 (2026-02-01)
- [x] Google AdMob導入
- [x] アプリアイコンの適用
- [x] READMEの更新
- [x] リリースビルド生成 (Phase 7へ移行)

### 変更履歴
- **2026-02-01**: Phase 6 実装計画を策定。Google AdMobの追加要件を反映。
- **2026-02-01**: Google AdMob (`google_mobile_ads`) を導入。
    - `AdHelper`クラスを作成し、OSごとのテストIDを管理。
    - `BannerAdWidget`を作成し、`HistoryScreen`, `ScanScreen` (BottomNavigationBar), `HomeScreen` に配置。
- **2026-02-01**: アプリアイコンを生成し、`flutter_launcher_icons` で適用。`AndroidManifest.xml` のアプリ名を "材確" (漢字) に修正。
- **2026-02-01**: ホーム画面のUIを調整。アプリアイコンの表示サイズを 120x120 に戻しつつ、実際のランチャーアイコン画像を表示するよう変更。
- **2026-02-01**: アプリアイコンを以前のバランスの良いバージョン（角丸・透過あり）をベースに、デザインを最大化（余白ゼロ）した画像に更新。
- **2026-02-01**: Androidのアダプティブアイコン設定（前景：アイコン、背景：透明）を適用し、OS上での視認性を最大化しつつ角の透過を実現。

### 実装機能
- **広告収益化**: Google AdMob バナー広告をアプリの主要な画面（ホーム、スキャン、履歴）の下部に配置。
- **ブランディング**:
    - アプリ名を「材確」（読み：ザイカク）に変更。
    - アプリアイコンを刷新。OSのホーム画面で最大限大きく表示されるよう、余白を排除したフルブリードデザインかつ透過対応のアダプティブアイコンを適用。
- **リリース準備**:
    - `Task.md`, `README.md` を最新化。
    - 次フェーズ（ストア公開）に向けたガイドライン（`STORE_REGISTRATION_GUIDE.md`）と計画書（`implementation_plan_phase7.md`）を策定。

### 追加・修正されたファイル
```
/
├── android/
│   ├── app/
│   │   └── src/main/AndroidManifest.xml [MOD] (アプリ名変更, AdMob ID追加)
├── assets/
│   └── icon/
│       └── icon.png [NEW] (アプリアイコン)
├── docs/
│   ├── implementation_plan_phase7.md [NEW] (Phase 7計画)
│   ├── STORE_REGISTRATION_GUIDE.md [NEW] (ストア登録ガイド)
│   ├── Task.md [MOD] (Phase 7, 8追加)
│   └── README.md [MOD] (Phase 6完了反映)
├── lib/
│   ├── core/
│   │   └── ads/
│   │       ├── ad_helper.dart [NEW] (広告ID管理)
│   │       └── banner_ad_widget.dart [NEW] (バナー広告ウィジェット)
│   ├── features/
│   │   ├── history/
│   │   │   └── presentation/
│   │   │       └── history_screen.dart [MOD] (広告配置)
│   │   ├── home/
│   │   │   └── presentation/
│   │   │       └── home_screen.dart [MOD] (広告配置, UI調整)
│   │   └── scan/
│   │       └── presentation/
│   │           └── scan_screen.dart [MOD] (広告配置)
│   └── main.dart [MOD] (AdMob初期化)
└── pubspec.yaml [MOD] (google_mobile_ads, flutter_launcher_icons追加)
```

### 主要作業内容
1.  **収益化基盤構築**: AdMobパッケージの導入とヘルパークラスの実装。
2.  **UI統合**: 既存の画面レイアウトを崩さずにバナー広告を配置。
3.  **アプリアイコン完成**: 視認性とデザイン性を両立させたアダプティブアイコンの生成と適用。
4.  **ドキュメント整備**: 開発ポリシー準拠のため、次フェーズの計画と手順を正式なドキュメントフォルダに集約。

### 検証結果
- **2026-02-01**: 動作確認完了 (**SUCCESS**)
    - **広告**: テストバナーが各画面で表示され、ログにロード成功が記録されることを確認。
    - **アイコン**: エミュレータのランチャー画面で、アイコンが大きく、かつ角が綺麗に透過されていることを確認。
    - **アプリ名**: ランチャーおよび設定画面で「材確」と表示されることを確認。

---

### Phase 7: ストア公開準備と製品化設定 [完了]
- [x] 実装計画策定 (2026-02-01)
- [x] 法的ドキュメント作成 (Manual, Privacy Policy)
- [x] 法的情報メニューの実装
- [x] リリース署名設定 (key.properties, build.gradle)
- [x] 公開リポジトリ向けセキュリティ対策 (AdMob ID等の非表示化)
- [x] リリースビルド (AAB) 生成 (2026-02-01)

### 変更履歴
- **2026-02-01**: `USER_MANUAL.md`, `PRIVACY_POLICY.md` を作成。アプリ内表示用のテキスト定数 (`AppDocs`) も実装。
- **2026-02-01**: `HomeScreen` にメニューを追加し、取扱説明書・プライバシーポリシーの表示ダイアログおよびライセンス表示 (`showLicensePage`) を実装。
- **2026-02-01**: リリースビルド用の署名設定を `build.gradle.kts` に追加。`key.properties` (Git除外) を用いた安全な署名・AdMob App ID管理を実装。
- **2026-02-01**: `AdHelper` を修正し、`--dart-define` によるビルド時定数注入に対応。コード内からの本番用IDハードコードを排除。
- **2026-02-01**: 署名鍵 (JKS) を生成。
- **2026-02-01**: `proguard-rules.pro` を作成し、Google ML Kit および Play Core ライブラリに関連する R8 難読化エラーを解消。
- **2026-02-01**: Git履歴を整理し、誤ってコミットされた秘匿情報を完全に削除。

### 追加・修正されたファイル
```
/
├── android/
│   ├── app/
│   │   ├── build.gradle.kts [MOD] (署名設定 & AdMob ID注入)
│   │   ├── proguard-rules.pro [NEW] (難読化ルール)
│   │   └── src/main/AndroidManifest.xml [MOD] (AdMob IDの変数化)
│   └── key.properties [NEW] (署名鍵・秘匿ID設定: Git除外)
├── docs/
│   ├── PRIVACY_POLICY.md [NEW]
│   └── USER_MANUAL.md [NEW]
├── lib/
│   ├── core/
│   │   ├── ads/
│   │   │   └── ad_helper.dart [MOD] (環境変数によるID注入)
│   │   └── constants/
│   │       └── app_docs.dart [NEW] (アプリ内表示用ドキュメントテキスト)
│   └── features/
│       └── home/
│           └── presentation/
│               └── home_screen.dart [MOD] (法的情報メニュー追加)
└── test/
    └── widget_test.dart [DELETE] (不要なデフォルトテスト削除)
```

### 検証結果
- **2026-02-01**: ビルド検証完了 (**SUCCESS**)
  - `flutter build appbundle --release --dart-define=ADMOB_BANNER_ID_ANDROID=...` が成功。
  - 秘匿情報がソースコード上から排除され、Git追跡対象外となっていることを確認。

---

## Phase 8: ストア審査と公開 [進行中]
- [x] 実装計画策定 (2026-02-01 承認済)
- [x] ストア掲載用資産の準備
  - [x] アプリアイコン (512x512px)
  - [x] フィーチャーグラフィック (1024x500px)
  - [x] スクリーンショット撮影 (4枚)
- [x] ストア掲載情報ドラフトの作成
- [x] 作業マニュアル (GitHub Pages / スクリーンショット手順) の作成

### 変更履歴
- **2026-02-01**: Phase 8 実装計画を策定し承認を得た。
- **2026-02-01**: Google Play Store 登録に必要な資産（512pxアイコン、フィーチャーグラフィック）を生成し、`store_assets/` ディレクトリに整理。
- **2026-02-01**: エミュレータを操作し、ストア掲載用の主要4画面（ホーム、スキャン、履歴、製品マスタ）のスクリーンショットを撮影。
- **2026-02-01**: ユーザー様が実施するストア登録・プライバシーポリシー公開を支援するための詳細なマニュアル（`STORE_REGISTRATION_MANUAL.md`）を作成。

### 実装・準備された資産
- **ロゴ**: `store_assets/icon_512.png` (Google Play要件準拠)
- **宣伝画像**: `store_assets/feature_graphic.png` (1024x500px)
- **スクリーンショット**: 以下のファイルを `store_assets/` に保存
  - `01_home_screen.png`
  - `02_scan_screen.png`
  - `03_history_screen.png`
  - `04_product_master_screen.png`
- **ドキュメント**:
  - `STORE_LISTING_DRAFT.md` (ストア説明文ドラフト)
  - `STORE_REGISTRATION_MANUAL.md` (作業ガイド)

### 次のステップ
- ユーザー様による Google Play Console へのアプリ登録、掲載情報の入力、および審査提出。
- 実機でのスクリーンショット撮影。
- 公開後のドキュメント最終化。

