# acms-codespaces

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/appleple/acms-codespaces)
[![Use this template](https://img.shields.io/badge/Use%20this%20template-2ea44f?style=flat&logo=github&logoColor=white)](https://github.com/appleple/acms-codespaces/generate)

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
| **データベース名** | `acms` |
| **ユーザー名** | `root` |
| **パスワード** | `root` |

> ポートは既定の `3306` のままで問題ないため、入力は不要です。

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

## 自分のリポジトリとして使う（設定変更を残したい場合）

このリポジトリは **テンプレート** です。設定（`compose.yaml` / `.devcontainer` / `README` など）を自分用に変更して残したい場合は、上部の **«Use this template»** ボタンから**自分のアカウントにコピー**を作成し、そこで Codespace を開いてください。以降の commit は自分のリポジトリに保存されます。

- 単にお試しするだけなら «Open in GitHub Codespaces» でOK（使い捨ての Codespace が立ち上がります）。書き込み権限が無いリポジトリで push しようとすると、GitHub が自動で自分のアカウントへの Fork 作成を促します。
- ⚠️ 注意: `web/`（a-blog cms 本体）は `.gitignore` 済みのため、コピー後も commit されません。テーマ/プラグインなど**自作分を版管理したい**場合は、`.gitignore` の除外設定が別途必要です。

---

## 勉強会・ペア作業で 1 つの環境を共同編集する（Live Share）

お客さんとの勉強会などで、**1 つの Codespace を複数人でリアルタイム共同編集**できます（この repo には Live Share 拡張を同梱済み）。

1. ホスト（あなた）が Codespace を起動する。
2. 左下のアカウント表示、またはコマンドパレットから **「Live Share」** を開始し、**共有リンク**を取得する。
3. お客さんにリンクを渡す → **ブラウザから参加**できます（GitHub / Microsoft アカウント、または匿名ゲストで参加可）。同じファイル・ターミナル・実行中の 8080 サイトを一緒に編集／閲覧できます。必要なら **読み取り専用**でも共有できます。

- 💰 課金されるのは **ホストの Codespace だけ**（あなたの無料枠）。お客さんは自分の Codespace を作らないので **無料・カード不要**です。
- ⚠️ 自動停止（アイドルタイムアウト）は **ホストのみ**を見ます。ホストが無操作だとゲストが作業中でも停止することがあるので、ホストは操作を続けてください。
- 画面（サイト）を**見せるだけ**なら、8080 ポートを **Public / Organization** にして URL を共有する方法でも OK です（この場合コード編集はできません）。

> ※ 1 つの Codespace に複数人が「ログイン」して共有することはできません（1 アカウント 1 Codespace）。共同編集は上記の Live Share で行います。

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
