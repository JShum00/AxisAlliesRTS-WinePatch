# Axis & Allies RTS — Linux Compatibility Patch
**By jShum00** | Tested on Ubuntu 24 with Wine 9.0

This unofficial patch makes Axis & Allies RTS (2004, TimeGate Studios) playable on Linux via Wine with no missing button text, no crashes, and a working HUD.

---

## What's Included

| File | Purpose |
|------|---------|
| `Data.rwd` | Patched game archive with font fix applied |
| `setup.sh` | Automated setup script |
| `README.md` | This file |

---

## Requirements

- A copy of **Axis & Allies RTS** (available on MyAbandonware and similar sites)
- **Wine 9.0+** (`sudo apt install wine`)
- **wine32** (`sudo apt install wine32`)
- Linux with a desktop environment (tested on Ubuntu 24 / XFCE)

---

## Installation

1. Extract your copy of Axis & Allies RTS to a folder, e.g. `~/Documents/AxisAlliesRTS`
2. Copy the contents of this patch zip into the same folder
3. Open a terminal in that folder and run:

```bash
chmod +x setup.sh
./setup.sh
```

4. Follow the prompts — the script will ask for your game folder path
5. Launch from your applications menu or run `launch.sh` directly

---

## What the Patch Does

### The Problem
Axis & Allies RTS uses a custom TrueType font called `A&A.TTF` packed inside `Data.rwd`. On Linux, Wine's font loader chokes on the ampersand (`&`) in the filename, causing all button labels and styled UI text to render as blank — even though the rest of the game works fine.

### The Fix
The patched `Data.rwd` replaces all internal references to `/fonts/truetype/A&A.TTF` with `Arial` (the system font name), matching exactly how other fonts in the game are referenced. This is a binary patch — the file size is identical to the original.

The setup script also:
- Creates a **32-bit Wine prefix** (required — the game crashes in a 64-bit prefix)
- Sets the Windows version to **XP** (the game's target OS)
- Sets a **VRAM override** of 2048MB so Wine correctly reports available video memory
- Launches the game at **800x600 windowed** to avoid adapter memory errors on startup
- Creates a `.desktop` shortcut so the game appears in your applications menu

---

## Known Issues

- The font substitute (Arial) differs slightly from the original `A&A.TTF` in style, but all text is readable and functional
- The game runs windowed at 800x600 by default — you can edit `launch.sh` to change resolution
- Multiplayer has not been tested and likely requires additional setup (GameSpy servers are offline)

---

## Restoring the Original

The setup script backs up your original `Data.rwd` as `Data.rwd.bak`. To restore:

```bash
cp ~/Documents/AxisAlliesRTS/Data.rwd.bak ~/Documents/AxisAlliesRTS/Data.rwd
```

---

## Credits

- **TimeGate Studios** — for making a great game
- **MyAbandonware** — for preserving it
- **Wine Project** — for making this possible
- **jShum00** — patch and setup script

---

*This patch is provided for preservation purposes only. Axis & Allies RTS is abandonware. No copyright infringement is intended.*
