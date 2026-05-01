# Axis & Allies RTS — Linux Compatibility Patch
**By jShum00** | Tested on Ubuntu 24 with Wine 9.0

This unofficial patch makes Axis & Allies RTS (2004, TimeGate Studios) playable on Linux via Wine with no missing button text, no crashes, and a working HUD.

---

## What's Included

| File | Purpose |
|------|---------|
| `/assets/` | Shows screenshots of before/after (proof it works) |
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

This guide assumes you already have a working installation of Axis & Allies RTS (for example from a backup, disc rip, MyAbandonware, or similar source). The goal is to run the existing Windows installation under Wine on Linux.

### 1. First launch issue (working directory error)

When launching `AA.exe` through Wine, you may encounter this error:

![Initial Error Screenshot.](/assets/initial-error.png)

This occurs because the game expects to be launched from its current directory. But for some reason if the Linux doesn't mark the exe as executable, then it thinks it's in a different environment. So you get this message:

`Work depot not specified`

### 2. Launch context behavior

Depending on how the executable is started (terminal, file manager, or Wine integration), the working directory may differ.

If launched from a file manager, you may see an option like:

![Allow to Execute Screenshot.](/assets/allow-execute.png)

This affects how the executable is invoked and can influence whether the correct working directory is used.

### 3. Missing UI text issue (after successful launch)

If the game launches successfully, you may notice that all button text is missing:

![No Button Text Screenshot.](/assets/AA-notext.png)

This is caused by a font reference issue inside the game’s data files when running under Wine.

### 4. Applying the patch

To resolve these issues:

1. Locate your existing Axis & Allies RTS installation  
   Example: `~/Documents/AxisAlliesRTS`

2. Copy `setup.sh` from this repository into that folder

3. Open a terminal in that directory and run:

```bash
chmod +x setup.sh
./setup.sh
```
4. Alternatively:
   - Right-click setup.sh
   - Enable “Allow executing file as program”
   - Run it using “Run in Terminal”

5. Enter your game directory when prompted

> Important: Avoid using & in folder names, as it can interfere with command parsing.

6. Download Data.rwd from the Releases section of this repository
7. Place Data.rwd into the game directory
(The original file will already be backed up as Data.rwd.bak)

### 5. Successful result

After applying the patch, the game should launch with fully visible UI text:

![Fixed Button Text Screenshot](/assets/AA-fixtext.png)

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
