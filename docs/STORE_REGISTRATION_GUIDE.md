# Google Play Store 登録 & AdMob本番設定ガイド

## 1. Google AdMob 本番設定
1. [AdMob コンソール](https://apps.admob.com/)にログイン。
2. 「アプリを追加」から Android アプリを登録。
3. 「広告ユニット」から「バナー」を作成し、以下のIDを控える：
   - **App ID**: `ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX`
   - **広告ユニットID**: `ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX`
4. **AndroidManifest用設定**: `android/key.properties` に `admobAppId=あなたのAppID` を追記します（このファイルはGit管理外です）。
5. **コード用設定**: ビルド時に `--dart-define=ADMOB_BANNER_ID_ANDROID=あなたのユニットID` を付与してビルドします。
   - `lib/core/ads/ad_helper.dart` がこの環境変数を自動で読み込みます。


## 2. リリース用署名 (Keystore) の作成
1. ターミナルで署名鍵を生成：
   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
2. `android/key.properties` を作成（jksのパスやパスワードを記述）。
3. `android/app/build.gradle.kts` で上記ファイルを読み込み、`signingConfigs` に適用。

## 3. アプリバンドル (AAB) の生成
1. リリースビルドを実行：
   ```bash
   flutter build appbundle --release
   ```
2. `build/app/outputs/bundle/release/app-release.aab` が生成される。

## 4. Google Play Console へのアップロード
1. [Google Play Console](https://play.google.com/console/) へログイン。
2. 「アプリを作成」し、基本情報を入力。
3. 「タスク」に従い、プライバシーポリシー、コンテンツのレーティング等を設定。
4. 「製品」>「リリース」>「本番」から、生成した `.aab` ファイルをアップロード。
5. ストア掲載情報（説明文、アイコン、スクリーンショット）を登録し、審査へ提出。

## 5. 法的・義務対応（必須）
- **プライバシーポリシー**: AdMob（Personalized Ads）やFirebase（利用する場合）のデータ収集について明記し、URLをストアに登録。
- **ライセンス表示**: アプリ内の設定画面等から、Flutterの `showLicensePage` を呼び出せるように実装。
- **データセーフティ宣言**: ストア上で、取得するデータとその用途を正確に自己申告。
