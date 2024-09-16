#!/bin/bash
# usage: ./update.sh [--alpha]
set -euxo pipefail
if [ $# -eq 0 ]; then
  # get latest stable release
  VERSION=$(gh release list --repo camunda/camunda --order desc --exclude-pre-releases --exclude-drafts --json tagName --jq '[.[] | select(.tagName | test("^8.\\d+.\\d+$"))][0].tagName')
elif [ "$1" = --alpha ]; then
  # get latest alpha release
  VERSION=$(gh release list --repo camunda/camunda --order desc --exclude-drafts --json tagName --jq '[.[] | select(.tagName | test("^8.\\d+.\\d+-alpha\\d+$"))][0].tagName')
fi
wget "https://github.com/camunda/camunda/releases/download/$VERSION/camunda-zeebe-$VERSION.tar.gz.sha1sum"
sed -i "s/^version: '[^']*'/version: '$VERSION'/" snap/snapcraft.yaml
checksum=$(head -c 40 "camunda-zeebe-$VERSION.tar.gz.sha1sum")
sed -i "s#    source-checksum: sha1/.*#    source-checksum: sha1/$checksum#" snap/snapcraft.yaml
rm "camunda-zeebe-$VERSION.tar.gz.sha1sum"
git diff --color-words snap/snapcraft.yaml
git commit -m "Bump zbctl to $VERSION" snap/snapcraft.yaml
