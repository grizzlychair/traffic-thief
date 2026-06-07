# OpenTTD-USB

A Fish shell script for Arch-based Linux that installs a portable, self-contained [OpenTTD](https://www.openttd.org/) instance onto a USB drive. Saves, config, and NewGRFs stay on the drive and travel with you.

## Requirements

- Linux (tested on CachyOS / Arch-based)
- Fish shell
- `curl`, `tar`, and `jq` available on the host machine (the script will attempt to install `jq` via `pacman` if it's missing, Arch-based distros only)
- USB drive mounted at `/run/media/grizz/USB` (edit the `DRIVE` variable in the script if your mount path differs)

## What the script does

1. Checks for `jq` and installs it via `pacman` if not present
2. Queries the GitHub Releases API to determine the latest stable OpenTTD version automatically
3. Creates an `openttd/` directory at the root of the USB drive
4. Downloads the correct Linux generic binary for that version from `cdn.openttd.org`
5. Extracts and cleans up the archive
6. Creates the following directories inside `openttd/`:
   - `save/` - savegames (OpenTTD checks here first when it exists next to the binary)
   - `newgrf/` - NewGRF mods
   - `data/config/` - configuration file
7. Generates a `launch-OpenTTD.sh` wrapper script that points OpenTTD at the portable config on the drive

## Usage

### First-time setup

Make sure your USB drive is mounted, then run:

```fish
~/Desktop/OpenTTD-USB.fish
```

### Launching the game

```sh
/run/media/<user>/USB/openttd/launch-OpenTTD.sh
```

Or navigate to the `openttd/` folder on the drive and run:

```sh
./launch-OpenTTD.sh
```

## Updating OpenTTD

Just re-run the script. It queries the GitHub Releases API at runtime and always downloads the latest stable version, so no manual version editing is needed. Your `save/`, `newgrf/`, and `data/config/` directories will be left intact since `mkdir -p` won't clobber existing folders.

## Directory structure after install

```
USB/
└── openttd/
    ├── openttd          # game binary
    ├── launch-OpenTTD.sh  # portable launcher
    ├── save/            # savegames
    ├── newgrf/          # NewGRF mods
    └── data/
        └── config/      # openttd.cfg lives here
```

## Notes

- NewGRFs downloaded in-game via the content downloader will land in the correct location automatically.
- The script targets `x86_64` (64-bit) Linux only.
- If running on a machine with a significantly older glibc, the generic binary may fail to launch. In that case, install OpenTTD from that machine's package manager and copy your saves across manually.

---
Generated with the assistance of Anthropic's Claude Sonnet 4.6 (June 2026).
