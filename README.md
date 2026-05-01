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

Before you do anything, you'll likely see this when you try to run the game initially with wine:

![Initial Error Screenshot.](/assets/initial-error.png)

When launching AA.exe without proper execution context, Wine may start the game without the correct working directory. This causes the game to fail initialization with the error:

![Allow to Execute Screenshot.](/assets/allow-execute.png)

This occurs because the game relies on relative paths for required data directories. Ensuring the executable is launched with correct permissions and from the proper directory resolves this issue. Now when you run the game, you won't get that initial error, but now you'll see the game behaves as-so, where there is no text on any buttons:

![No Button Text Screenshot.](/assets/AA-notext.png)

As you can see, no text are on the buttons, that's where this patch comes into hand:

1. Extract your copy of Axis & Allies RTS to a folder, e.g. `~/Documents/AxisAlliesRTS` (I assume you have already done this)
2. Copy the `setup.sh` of this patch zip into the same folder
3. Open a terminal in that folder and run:

```bash
chmod +x setup.sh
./setup.sh
```

4. Or you can do the same steps I mentioned earlier on the bash script, and click allow to execute as program checkbox, then double click the bash script, and select Run in Terminal
5. Follow the prompts — the script will ask for your game folder path (i.e. `~/Documents/AxisAlliesRTS`) -- Make sure there is no Ampersand (&) symbol in the name!!!
6. Download the Data.rwd from the Releases on this github repo, over on the sidebar to the right.
7. Move the `Data.rwd` file into your game's directory (don't worry the bash script backed-up the original `Data.rwd` as `Data.rwd.bak` so yes, you can click the replace button when Linux tells you the file already exists in that directory.
7. Launch from your applications menu or run `launch.sh` directly

Now the game should work as so:

![Fixed Button Text Screenshot.](/assets/AA-fixtext.png)

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
