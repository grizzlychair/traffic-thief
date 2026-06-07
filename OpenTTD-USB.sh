#!/bin/sh
if [ ! -t 0 ]; then
    for term in konsole gnome-terminal xfce4-terminal mate-terminal lxterminal alacritty kitty xterm; do
        if command -v $term > /dev/null 2>&1; then
            $term -e sh "$0"
            exit
        fi
    done
    echo "No supported terminal emulator found. Please run this script from a terminal."
    exit 1
fi
if ! command -v jq > /dev/null 2>&1; then
    echo "jq not found, installing..."
    sudo pacman -S --noconfirm jq
fi
printf "Enter USB drive label (default: USB): "
read LABEL
if [ -z "$LABEL" ]; then
    LABEL="USB"
fi
DRIVE="/run/media/$(whoami)/$LABEL"
if [ ! -d "$DRIVE" ]; then
    echo "Drive not found at $DRIVE. Make sure it is mounted and the label is correct."
    exit 1
fi
VERSION=$(curl -s "https://api.github.com/repos/OpenTTD/OpenTTD/releases/latest" | jq -r .tag_name)
echo "Latest OpenTTD version: $VERSION"
mkdir -p "$DRIVE/openttd"
cd "$DRIVE/openttd"
curl -LO "https://cdn.openttd.org/openttd-releases/$VERSION/openttd-$VERSION-linux-generic-amd64.tar.xz"
tar -xf "openttd-$VERSION-linux-generic-amd64.tar.xz" --strip-components=1
rm "openttd-$VERSION-linux-generic-amd64.tar.xz"
mkdir -p save newgrf data/config
printf "#!/bin/sh
DIR=\$(cd \$(dirname \$0) && pwd)
\$DIR/openttd -c \$DIR/data/config/openttd.cfg
" > launch-OpenTTD.sh
chmod +x launch-OpenTTD.sh
echo "Done. OpenTTD $VERSION installed to $DRIVE/openttd"
