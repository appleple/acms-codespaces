#!/usr/bin/env bash
# a-blog cms のファイル一式をワークスペースの ./acms/ に展開する（初回のみ）。
# これにより VS Code のエディタで a-blog cms のテーマ/プラグイン/コアを直接編集でき、
# 変更が即ブラウザに反映される。展開ファイルは .gitignore 済み（商用ソフトのため未コミット）。
set -euo pipefail

# リポジトリルートへ移動（postCreateCommand の cwd に依存しないように）
cd "$(dirname "$0")/.."

TAG="${ACMS_IMAGE_TAG:-3.2-php8.4}"
IMAGE="appleple/acms:${TAG}"
MARKER="acms/.acms-seeded"

if [ -f "${MARKER}" ]; then
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

echo "[setup] 権限を調整（エディタと Apache の双方が読み書きできるように）..."
# 体験用途のため広めに許可（./acms は .gitignore 済み・使い捨て環境）
chmod -R a+rwX acms 2>/dev/null || sudo chmod -R a+rwX acms 2>/dev/null || true

touch "${MARKER}"
echo "[setup] 完了。エディタの ./acms 配下で a-blog cms を編集できます。"
