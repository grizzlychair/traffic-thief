# OpenTTD-USB

A shell script for Arch-based Linux that installs a portable, self-contained [OpenTTD](https://www.openttd.org/) instance onto a USB drive. Saves, config, and NewGRFs stay on the drive and travel with you.

## Requirements

- Linux (tested on CachyOS / Arch-based)
- Any POSIX-compatible shell (bash, zsh, fish, etc.)
- `curl`, `tar`, and `jq` available on the host machine (the script will attempt to install `jq` via `pacman` if it's missing, Arch-based distros only)
- Konsole (for automatic terminal launch when run from a desktop environment; other terminal emulators will require running the script manually from a terminal)
- USB drive mounted and accessible under `/run/media/<username>/` (the script detects your username automatically and prompts for the drive label)

## What the script does

1. Checks for `jq` and installs it via `pacman` if not present
2. Detects the current username automatically
3. Prompts for the USB drive label (defaults to `USB` if left blank)
4. Verifies the drive is mounted before proceeding
5. Queries the GitHub Releases API to determine the latest stable OpenTTD version automatically
6. Creates an `openttd/` directory at the root of the USB drive
7. Downloads the correct Linux generic binary for that version from `cdn.openttd.org`
8. Extracts and cleans up the archive
9. Creates the following directories inside `openttd/`:
   - `save/` - savegames (OpenTTD checks here first when it exists next to the binary)
   - `newgrf/` - NewGRF mods
   - `data/config/` - configuration file
10. Generates a `launch-OpenTTD.sh` wrapper script that points OpenTTD at the portable config on the drive

## Usage

### First-time setup

Make sure your USB drive is mounted, then double-click `OpenTTD-USB.sh` from the desktop or run it from a terminal:

```sh
~/Desktop/OpenTTD-USB.sh
```

The script will open a Konsole window automatically if not already running in a terminal. It will prompt for your USB drive label (press Enter to accept the default `USB`), then proceed with the install.

### Launching the game

```sh
/run/media/<username>/<drive-label>/openttd/launch-OpenTTD.sh
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
