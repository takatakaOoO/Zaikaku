# Google Play Store 登録作業マニュアル

**最終更新**: 2026-02-01  
**対象**: Phase 8 - ストア審査と公開

---

## 1. 準備した資産の一覧

Google Play Consoleで要求される以下のファイルを `store_assets/` ディレクトリにまとめました。

- **アプリアイコン**: `store_assets/icon_512.png` (512x512px)
- **フィーチャーグラフィック**: `store_assets/feature_graphic.png` (1024x500px)
- **リリースビルド (AAB)**: `build/app/outputs/bundle/release/app-release.aab`
- **ストア説明文ドラフト**: [`docs/STORE_LISTING_DRAFT.md`](file:///c:/Users/d-2/OriginalCode/Zaikaku/docs/STORE_LISTING_DRAFT.md)

---

## 2. プライバシーポリシーの公開手順 (GitHub Pages)

Google Play Consoleにはプライバシーポリシーの「URL」を登録する必要があります。リポジトリ内の `docs/PRIVACY_POLICY.md` を使って無料で公開する方法です。

1. **GitHubリポジトリの設定を開く**:
   - ブラウザで該当のリポジトリページへ移動
   - 「Settings」タブ > 左メニューの「Pages」を選択
2. **公開設定**:
   - Build and deployment > Source: 「Deploy from a branch」
   - Branch: 「main」 / 「/docs」 フォルダを選択して「Save」
3. **URLの確認**:
   - 数分後、ページ上部に `https://<user>.github.io/Zaikaku/` のようなURLが表示されます。
   - `docs/PRIVACY_POLICY.md` はブラウザから `.../PRIVACY_POLICY` などで確認できるようになります。
   - **このURLをGoogle Play Consoleの「プライバシーポリシー」欄に記入してください。**

---

## 3. スクリーンショットの撮影方法 (実機推奨)

エミュレータではビルド環境の影響により正常な撮影が困難なため、実際のAndroid端末での撮影を強く推奨します。

- **必要な数**: 最低2枚、推奨4-8枚
- **サイズ要件**: 長辺が 320px 以上 3840px 以下、アスペクト比 2:1 または 1:2
- **撮影手順**:
  1. 実機に開発中のアプリをインストール
  2. 以下の画面を表示して電源ボタン+音量ダウン等で保存
     - ホーム画面
     - スキャン画面 (カメラが映っている状態)
     - 判定結果画面 (正解/不正解)
     - 履歴一覧画面
  3. 撮影した `.png` または `.jpg` ファイルを Google Play Console にアップロード

---

## 4. 本番用リリースビルドの生成方法 (再確認)

AdMobの本番広告を表示させるためには、**本番用の広告ユニットID**を指定してビルドする必要があります。

1. `android/key.properties` に本番用のIDが記載されていることを確認してください。
2. 以下のコマンドを実行してAABを再生成します（※ターミナルで実行してください）。

```bash
flutter build appbundle --release --dart-define=ADMOB_BANNER_ID_ANDROID=ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY
```

※ `XXXXXXXXXXXXXXXX/YYYYYYYYYY` は実際のAdMob広告ユニットIDに置き換えてください。

---

## 5. Google Play Console での登録ステップ

詳細な説明ドラフト ([`STORE_LISTING_DRAFT.md`](file:///c:/Users/d-2/OriginalCode/Zaikaku/docs/STORE_LISTING_DRAFT.md)) を参考に、以下の順で設定を進めてください。

1. **アプリの作成**: 材確 (日本語/アプリ/無料)
2. **ストアの掲載情報**: アイコン、説明文、スクリーンショットを登録
3. **データの安全性**: 収集するデータ「なし」で申告
4. **対象ユーザー**: 業界特性に合わせて設定（3歳以上等）
5. **リリースのアップロード**: 製品版トラックへ AAB をアップロード
6. **審査へ送信**: 全ての設定が完了したら右上の「審査に送信」をクリック

---

**サポートが必要な場合**:
設定画面で不明な項目や、エラーメッセージが表示された場合は、その内容を教えていただければすぐに対応策を検討します。
