# acms-codespaces

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/appleple/acms-codespaces)

**a-blog cms をボタン 1 クリックで試せる [GitHub Codespaces](https://github.com/features/codespaces) 用テンプレート**です。

上の «Open in GitHub Codespaces» ボタンを押すと、クラウド上に開発環境が立ち上がり、[appleple/acms](https://hub.docker.com/r/appleple/acms) コンテナと MySQL が自動起動します。あとはブラウザで **a-blog cms のセットアップウィザード**を進めるだけで、インストールを体験できます。

> 💳 **クレジットカード不要で試せます。** GitHub の個人アカウントには毎月の無料枠（Free プランで 120 core-hours ≒ 2コアで約60時間 / 15GB ストレージ）があり、支払い方法を登録しなくても利用できます。無料枠を使い切っても、カード未登録なら課金されずに停止するだけです（既定の spending limit は $0）。

> ⚠️ **開発・評価用途限定です。** このイメージ（`appleple/acms`）はローカル開発・自動テスト・評価向けで、本番運用向けにハードニング／サポートされていません。a-blog cms は appleple Inc. の商用ソフトウェアです。試用の範囲を超える場合はライセンスが必要になることがあります。詳細は [a-blog cms 公式サイト](https://www.a-blogcms.jp/) を参照してください。

---

## 使い方（GitHub Codespaces で試す）

1. 上部の **[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/appleple/acms-codespaces)** ボタンを押す（GitHub アカウントが必要です）。
2. Codespace が起動すると、自動的に `appleple/acms` と MySQL が `docker compose` で立ち上がります（初回はイメージ取得のため数分かかることがあります）。
3. 起動が終わると **8080 番が外部ブラウザの新しいタブで自動的に開きます**（開かない場合は下部の **PORTS（ポート）** タブで 8080 の 🌐「ブラウザーで開く」をクリック）。
   > ⚠️ VS Code 内蔵の «シンプル ブラウザー»（エディタ内プレビュー）は private ポートの GitHub 認証を通せず表示できません。必ず**外部ブラウザ**で開いてください。
4. a-blog cms の**セットアップウィザード**が表示されます。以下の順で進めます。
   1. **利用規約に同意**
   2. **データベース情報を入力**（下表の値）
   3. **テーマ（ルール）を選択**
   4. **管理者アカウントを作成**
   5. **インストール** を実行

### ウィザードに入力する DB 接続情報

| 項目 | 値 |
| --- | --- |
| データベースの種類 | MySQL |
| **ホスト名** | `db` |
| ポート | `3306` |
| **データベース名** | `acms` |
| **ユーザー名** | `root` |
| **パスワード** | `root` |

> 💡 **ホスト名は必ず `db`** を入力してください。`localhost` や `127.0.0.1` では DB コンテナに接続できません（Docker Compose のサービス名で名前解決されます）。

初期データやサンプルコンテンツの自動投入は行いません。まっさらな状態からインストールを体験できます。

### 起動した画面を他の人にも見せたい場合

Codespaces のポートは既定で **本人のみ（Private）** です。URL を知っている人なら誰でもアクセスできる状態にするには、**PORTS タブで 8080 を右クリック → Port Visibility → Public** に変更してください（`gh codespace ports visibility 8080:public -c <codespace-name>` でも可）。

> 組織（appleple）のポリシーでポートの Public 化が制限されている場合があります。その場合は本人プレビューのみ利用できます。

### a-blog cms のファイルを編集する（テーマ・プラグイン・コア）

Codespace の作成時に、a-blog cms 本体一式が**ワークスペースの `web/` フォルダ（＝ドキュメントルート）に自動展開**されます。エディタで `web/` 配下（`web/themes/` のテーマ、`web/extension/plugins/` のプラグイン、コアの PHP など）を編集すると、**そのままブラウザの表示に反映**されます。

- 例: `web/themes/` に自分のテーマを追加してウィザードで選択、`web/extension/plugins/` に独自プラグインを配置、など。
- 展開時に a-blog cms 標準の `htaccess.txt` は自動で `.htaccess` にリネーム済みです（ルートの URL 書き換え、各サブディレクトリの直接アクセス防止）。
- `web/` は使い捨て・**Git 管理外**（`.gitignore` 済み。a-blog cms は商用ソフトのため本体はコミットしません）。Codespace を削除すると消えます。残したい成果物は別途エクスポート／コミットしてください。

---

## ローカル（自分の PC）で試す

Docker / Docker Compose があれば、Codespaces を使わずにローカルでも同じ環境を起動できます（GitHub アカウント不要・完全無料）。

```bash
git clone https://github.com/appleple/acms-codespaces.git
cd acms-codespaces
bash .devcontainer/setup.sh   # a-blog cms 本体を ./web へ展開（初回のみ・要 Docker 起動）
docker compose up
# ブラウザで開く:
open http://localhost:8080   # 上記と同じセットアップウィザードが表示される
```

停止・破棄:

```bash
docker compose down      # 停止
docker compose down -v   # DB データも含めて破棄
```

使用する a-blog cms のバージョンを変えたい場合は `ACMS_IMAGE_TAG` で上書きできます（既定は `3.2-php8.4`）。

```bash
ACMS_IMAGE_TAG=3.2-php8.5 docker compose up
```

利用可能なタグは [Docker Hub の appleple/acms](https://hub.docker.com/r/appleple/acms/tags) を参照してください。

---

## 構成

| ファイル | 役割 |
| --- | --- |
| `compose.yaml` | `appleple/acms`（Apache + PHP 同梱）と `mysql:8.0` を定義。acms はホスト側 `8080` に公開し、`web/` を docroot にマウント。 |
| `.devcontainer/devcontainer.json` | Codespaces の環境定義。base イメージ + docker-in-docker feature。`postCreateCommand` で本体展開、`postStartCommand` で `docker compose up -d`。 |
| `.devcontainer/setup.sh` | 初回に a-blog cms 本体をイメージから `web/` へ展開し、`htaccess.txt` を `.htaccess` にリネームする。 |
| `web/` | 展開された a-blog cms 本体（＝ドキュメントルート・編集対象）。`.gitignore` 済み・使い捨て。 |
| `codespaces-fix.php` / `codespaces-php.ini` | Codespaces 配下で a-blog cms に正しい公開ホスト/HTTPS を強制する補正（`auto_prepend_file`）。ローカルでは無効。 |

---

## 参考リンク

- a-blog cms 公式: https://www.a-blogcms.jp/
- Docker イメージ: https://hub.docker.com/r/appleple/acms
- GitHub Codespaces: https://github.com/features/codespaces
