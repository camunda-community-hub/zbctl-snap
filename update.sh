#!/bin/bash
# usage: ./update.sh [--alpha]
set -euxo pipefail
if [ $# -eq 0 ]; then
  # get latest stable release
  VERSION=$(gh release list --repo camunda-community-hub/zeebe-client-go --order desc --exclude-pre-releases --exclude-drafts --json tagName --jq '[.[] | select(.tagName | test("^v8.\\d+.\\d+$"))][0].tagName')
elif [ "$1" = --alpha ]; then
  # get latest alpha release
  VERSION=$(gh release list --repo camunda-community-hub/zeebe-client-go --order desc --exclude-drafts --json tagName --jq '[.[] | select(.tagName | test("^v8.\\d+.\\d+-alpha\\d+$"))][0].tagName')
fi
# Download the zbctl binary to calculate checksum
wget "https://github.com/camunda-community-hub/zeebe-client-go/releases/download/$VERSION/zbctl" -O zbctl-temp
checksum=$(sha1sum zbctl-temp | cut -d' ' -f1)
rm zbctl-temp
sed -i "s/^version: '[^']*'/version: '${VERSION#v}'/" snap/snapcraft.yaml
sed -i "s#    source-checksum: sha1/.*#    source-checksum: sha1/$checksum#" snap/snapcraft.yaml
git diff --color-words snap/snapcraft.yaml
git commit -m "Bump zbctl to ${VERSION#v}" snap/snapcraft.yaml
