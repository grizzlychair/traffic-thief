#!/usr/bin/env fish
if not command -q jq
    echo "jq not found, installing..."
    sudo pacman -S --noconfirm jq
end
set DRIVE /run/media/grizz/USB
set VERSION (curl -s "https://api.github.com/repos/OpenTTD/OpenTTD/releases/latest" | jq -r .tag_name)
echo "Latest OpenTTD version: $VERSION"
mkdir -p $DRIVE/openttd
cd $DRIVE/openttd
curl -LO "https://cdn.openttd.org/openttd-releases/$VERSION/openttd-$VERSION-linux-generic-amd64.tar.xz"
tar -xf "openttd-$VERSION-linux-generic-amd64.tar.xz" --strip-components=1
rm "openttd-$VERSION-linux-generic-amd64.tar.xz"
mkdir -p save newgrf data/config
printf '#!/bin/sh
DIR="$(cd "$(dirname "$0")" && pwd)"
"$DIR/openttd" -c "$DIR/data/config/openttd.cfg"
' > launch-OpenTTD.sh
chmod +x launch-OpenTTD.sh
echo "Done. OpenTTD $VERSION installed to $DRIVE/openttd"
