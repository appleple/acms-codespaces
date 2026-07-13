# acms-ona

[![Build with Ona](https://ona.com/build-with-ona.svg)](https://app.ona.com/#https://github.com/appleple/acms-ona)

**a-blog cms をボタン 1 クリックで試せる [Ona](https://ona.com/)（旧 Gitpod）用テンプレート**です。

上の «Build with Ona» ボタンを押すと、クラウド上に開発環境が立ち上がり、[appleple/acms](https://hub.docker.com/r/appleple/acms) コンテナと MySQL が自動起動します。あとはブラウザで **a-blog cms のセットアップウィザード**を進めるだけで、インストールを体験できます。

> ⚠️ **開発・評価用途限定です。** このイメージ（`appleple/acms`）はローカル開発・自動テスト・評価向けで、本番運用向けにハードニング／サポートされていません。a-blog cms は appleple Inc. の商用ソフトウェアです。試用の範囲を超える場合はライセンスが必要になることがあります。詳細は [a-blog cms 公式サイト](https://www.a-blogcms.jp/) を参照してください。

---

## 使い方（Ona 上で試す）

1. 上部の **[![Build with Ona](https://ona.com/build-with-ona.svg)](https://app.ona.com/#https://github.com/appleple/acms-ona)** ボタンを押す。
2. 環境が起動すると、自動的に `appleple/acms` と MySQL が `docker compose` で立ち上がります（初回はイメージ取得のため数分かかることがあります）。
3. Ona の **Ports** パネル、またはプレビューから **8080** 番ポートを開く。
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

---

## ローカル（自分の PC）で試す

Docker / Docker Compose があれば、Ona を使わずにローカルでも同じ環境を起動できます。

```bash
docker compose up
# 別ターミナルで、または起動後にブラウザで:
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
| `compose.yaml` | `appleple/acms`（Apache + PHP 同梱）と `mysql:8.0` を定義。acms はホスト側 `8080` に公開。 |
| `.devcontainer/devcontainer.json` | Ona の環境（Dev Container）定義。汎用イメージ + docker-in-docker feature。 |
| `.ona/automations.yaml` | 環境起動時に `docker compose up` するサービスと、8080 番ポートを公開するタスク。 |

### ポートの公開範囲について

`.ona/automations.yaml` の `open-ports` タスクは、既定で 8080 番ポートを **`everyone`（未認証で誰でもアクセス可）** として公開します。起動したインスタンスの URL を知っていれば誰でもインストーラーにアクセスできる状態になります。公開範囲を変えたい場合は、同ファイル内の `--admission` を次のいずれかに変更してください。

- `creator_only` … 環境を起動した本人のみ
- `organization` … 組織メンバーのみ
- `everyone` … 未認証で誰でも（既定）

> 組織のポリシーによっては、指定できる最大の公開範囲が制限される場合があります（その場合はダッシュボード上で調整してください）。

---

## 参考リンク

- a-blog cms 公式: https://www.a-blogcms.jp/
- Docker イメージ: https://hub.docker.com/r/appleple/acms
- Ona ドキュメント: https://ona.com/docs/
