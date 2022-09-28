#!/bin/bash
# usage: ./update.sh 1.3.5
set -euxo pipefail
if [ "$1" = -a ]; then
  # get latest alpha release
  VERSION=$(gh release list --repo camunda/zeebe | grep Pre-release | head --lines=1 | awk -F'\t' '{print $3}')
else
  # get latest stable release
  VERSION=$(gh release view --repo camunda/zeebe --json tagName --jq .tagName)
fi
wget "https://github.com/camunda/zeebe/releases/download/$VERSION/camunda-zeebe-$VERSION.tar.gz.sha1sum"
sed -i "s/^version: '[^']*'/version: '$VERSION'/" snap/snapcraft.yaml
checksum=$(head -c 40 "camunda-zeebe-$VERSION.tar.gz.sha1sum")
sed -i "s#    source-checksum: sha1/.*#    source-checksum: sha1/$checksum#" snap/snapcraft.yaml
rm "camunda-zeebe-$VERSION.tar.gz.sha1sum"
git diff --color-words snap/snapcraft.yaml
git commit -m "Bump zbctl to $VERSION" snap/snapcraft.yaml