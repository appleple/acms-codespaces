#!/usr/bin/env bash
# a-blog cms のファイル一式をワークスペースの ./web/（＝ドキュメントルート）に展開する（初回のみ）。
# これにより VS Code のエディタで a-blog cms のテーマ/プラグイン/コアを直接編集でき、
# 変更が即ブラウザに反映される。展開ファイルは .gitignore 済み（商用ソフトのため未コミット）。
set -euo pipefail

# リポジトリルートへ移動（postCreateCommand の cwd に依存しないように）
cd "$(dirname "$0")/.."

TAG="${ACMS_IMAGE_TAG:-3.2-php8.4}"
IMAGE="appleple/acms:${TAG}"

# index.php の有無で判定（空マウントで作られただけの ./web も「未展開」とみなして展開し直す）
if [ -f web/index.php ]; then
  echo "[setup] ./web は展開済み。スキップします。"
  exit 0
fi

echo "[setup] Docker の起動を待機..."
until docker info >/dev/null 2>&1; do sleep 1; done

echo "[setup] イメージ取得: ${IMAGE}"
docker pull "${IMAGE}"

echo "[setup] a-blog cms のファイルを ./web へ展開..."
mkdir -p web
cid="$(docker create "${IMAGE}")"
docker cp "${cid}:/var/www/html/." ./web/
docker rm "${cid}" >/dev/null

# root で動くコンテナ内で以下を実施（docker cp したファイルは root 所有になり、
# Codespaces ではホスト側の操作が効かない場合があるため確実性を優先）:
#   1) htaccess.txt を同じ場所の .htaccess にリネーム
#      （a-blog cms が要求。ルート = URL 書き換え、各サブディレクトリ = 直接アクセス防止）
#   2) 権限調整（エディタ=作成ユーザー と Apache=www-data の双方が読み書きできるように）
echo "[setup] htaccess.txt を .htaccess にリネーム & 権限調整..."
docker run --rm --entrypoint sh -v "$(pwd)/web:/data" "${IMAGE}" -c '
  find /data -name htaccess.txt -type f | while IFS= read -r f; do
    mv -f "$f" "${f%htaccess.txt}.htaccess"
  done
  chmod -R a+rwX /data
' || {
  # フォールバック（ホスト側で実施）
  find web -name htaccess.txt -type f 2>/dev/null | while IFS= read -r f; do
    mv -f "$f" "${f%htaccess.txt}.htaccess" 2>/dev/null || true
  done
  chmod -R a+rwX web 2>/dev/null || sudo chmod -R a+rwX web 2>/dev/null || true
}

echo "[setup] 完了。エディタの ./web 配下（＝ドキュメントルート）で a-blog cms を編集できます。"
