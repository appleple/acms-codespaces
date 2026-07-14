#!/usr/bin/env bash
# a-blog cms のファイル一式をワークスペースの ./acms/ に展開する（初回のみ）。
# これにより VS Code のエディタで a-blog cms のテーマ/プラグイン/コアを直接編集でき、
# 変更が即ブラウザに反映される。展開ファイルは .gitignore 済み（商用ソフトのため未コミット）。
set -euo pipefail

# リポジトリルートへ移動（postCreateCommand の cwd に依存しないように）
cd "$(dirname "$0")/.."

TAG="${ACMS_IMAGE_TAG:-3.2-php8.4}"
IMAGE="appleple/acms:${TAG}"

# index.php の有無で判定（空マウントで作られただけの ./acms も「未展開」とみなして展開する）
if [ -f acms/index.php ]; then
  echo "[setup] ./acms は展開済み。スキップします。"
  exit 0
fi

echo "[setup] Docker の起動を待機..."
until docker info >/dev/null 2>&1; do sleep 1; done

echo "[setup] イメージ取得: ${IMAGE}"
docker pull "${IMAGE}"

echo "[setup] a-blog cms のファイルを ./acms へ展開..."
mkdir -p acms
cid="$(docker create "${IMAGE}")"
docker cp "${cid}:/var/www/html/." ./acms/
docker rm "${cid}" >/dev/null

# 権限調整: docker cp したファイルは root 所有になることがあり、ホスト側 chmod が
# 効かない場合がある。root で動くコンテナ内から chmod して、エディタと Apache
# (www-data) の双方が読み書きできるようにする（体験用途のため広めに許可）。
echo "[setup] 権限を調整..."
docker run --rm --entrypoint sh -v "$(pwd)/acms:/data" "${IMAGE}" -c 'chmod -R a+rwX /data' \
  || chmod -R a+rwX acms 2>/dev/null \
  || sudo chmod -R a+rwX acms 2>/dev/null || true

echo "[setup] 完了。エディタの ./acms 配下で a-blog cms を編集できます。"
