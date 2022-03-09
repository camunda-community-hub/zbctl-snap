#!/bin/bash
# usage: ./update.sh 1.3.5
set -euxo pipefail
wget "https://github.com/camunda-cloud/zeebe/releases/download/$1/camunda-cloud-zeebe-$1.tar.gz.sha1sum"
sed -i "s/^version: '[^']*'/version: '$1'/" snap/snapcraft.yaml
checksum=$(head -c 40 "camunda-cloud-zeebe-$1.tar.gz.sha1sum")
sed -i "s#    source-checksum: sha1/.*#    source-checksum: sha1/$checksum#" snap/snapcraft.yaml
rm "camunda-cloud-zeebe-$1.tar.gz.sha1sum"
git diff --color-words snap/snapcraft.yaml
git commit -m "Bump zbctl to $1" snap/snapcraft.yaml