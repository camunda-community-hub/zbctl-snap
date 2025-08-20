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
# Update version in snapcraft.yaml (no checksum needed when building from source)
sed -i "s/^version: '[^']*'/version: '${VERSION#v}'/" snap/snapcraft.yaml
git diff --color-words snap/snapcraft.yaml
git commit -m "Bump zbctl to ${VERSION#v}" snap/snapcraft.yaml
