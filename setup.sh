#!/bin/bash

# Axis & Allies RTS - Linux Compatibility Patch
# Setup Script
# By jShum00 | github.com/JShum00

WINEPREFIX_NAME="AxisAlliesRTS"
WINEPREFIX_PATH="$HOME/.local/share/wineprefixes/$WINEPREFIX_NAME"

echo "============================================"
echo " Axis & Allies RTS - Linux Compatibility Patch"
echo " Setup Script by jShum00"
echo "============================================"
echo ""

# --- Dependency Checks ---
MISSING_DEPS=0

if ! command -v wine &>/dev/null; then
    echo "[WARNING] Wine is not installed or not in PATH."
    echo "          Install it with: sudo apt install wine"
    MISSING_DEPS=1
fi

if ! dpkg -l | grep -q "wine32"; then
    echo "[WARNING] wine32 does not appear to be installed."
    echo "          Install it with: sudo apt install wine32"
    MISSING_DEPS=1
fi

if [ $MISSING_DEPS -eq 1 ]; then
    echo ""
    echo "[WARNING] One or more dependencies are missing. The setup will continue"
    echo "          but the game may not work correctly without them."
    echo ""
    read -p "Press Enter to continue anyway, or Ctrl+C to abort..."
    echo ""
fi

# --- Game Folder ---
echo "Please enter the full path to your Axis & Allies RTS game folder."
echo "(This is the folder containing AA.exe)"
echo ""
read -p "Game folder path: " GAME_PATH

# Expand tilde if used
GAME_PATH="${GAME_PATH/#\~/$HOME}"

if [ ! -f "$GAME_PATH/AA.exe" ]; then
    echo ""
    echo "[ERROR] Could not find AA.exe in: $GAME_PATH"
    echo "        Please check the path and try again."
    exit 1
fi

echo ""
echo "[OK] Found AA.exe in: $GAME_PATH"
echo ""

# --- Backup original Data.rwd ---
if [ -f "$GAME_PATH/Data.rwd" ]; then
    if [ ! -f "$GAME_PATH/Data.rwd.bak" ]; then
        echo "[*] Backing up original Data.rwd to Data.rwd.bak..."
        cp "$GAME_PATH/Data.rwd" "$GAME_PATH/Data.rwd.bak"
        echo "[OK] Backup created."
    else
        echo "[OK] Backup already exists, skipping."
    fi
fi

# --- Copy patched Data.rwd ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! -f "$SCRIPT_DIR/Data.rwd" ]; then
    echo "[ERROR] Patched Data.rwd not found in the patch folder."
    echo "        Make sure Data.rwd is in the same folder as this script."
    exit 1
fi

echo "[*] Copying patched Data.rwd..."
cp "$SCRIPT_DIR/Data.rwd" "$GAME_PATH/Data.rwd"
echo "[OK] Patched Data.rwd installed."

# --- Create font directory and drop Arial substitute ---
echo "[*] Setting up font substitution..."
mkdir -p "$GAME_PATH/data/fonts/truetype"
cp /usr/share/fonts/truetype/liberation/LiberationSans-Regular.ttf \
   "$GAME_PATH/data/fonts/truetype/cor.ttf" 2>/dev/null || \
cp /usr/share/fonts/truetype/dejavu/DejaVuSans.ttf \
   "$GAME_PATH/data/fonts/truetype/cor.ttf" 2>/dev/null || \
find /usr/share/fonts -name "*.ttf" | head -1 | \
   xargs -I{} cp {} "$GAME_PATH/data/fonts/truetype/cor.ttf"
echo "[OK] Font substitution ready."

# --- Create Wine prefix ---
echo "[*] Creating 32-bit Wine prefix at $WINEPREFIX_PATH..."
WINEARCH=win32 WINEPREFIX="$WINEPREFIX_PATH" wineboot --init 2>/dev/null
echo "[OK] Wine prefix created."

# --- Set Windows XP ---
echo "[*] Setting Windows version to XP..."
WINEPREFIX="$WINEPREFIX_PATH" winecfg -v winxp 2>/dev/null || \
WINEPREFIX="$WINEPREFIX_PATH" wine reg add \
  "HKCU\\Software\\Wine" /v Version /t REG_SZ /d winxp /f 2>/dev/null
echo "[OK] Windows version set."

# --- Set VideoMemorySize ---
echo "[*] Setting VRAM override to 2048MB..."
WINEPREFIX="$WINEPREFIX_PATH" wine reg add \
  "HKCU\\Software\\Wine\\Direct3D" \
  /v VideoMemorySize /t REG_SZ /d 2048 /f 2>/dev/null
echo "[OK] VRAM override set."

# --- Create launch.sh ---
echo "[*] Creating launch script..."
cat > "$GAME_PATH/launch.sh" << EOF
#!/bin/bash
cd "$GAME_PATH"
WINEPREFIX="$WINEPREFIX_PATH" wine AA.exe ResolutionX=800 ResolutionY=600 ResolutionWindowed=1
EOF
chmod +x "$GAME_PATH/launch.sh"
echo "[OK] launch.sh created."

# --- Create .desktop shortcut ---
echo "[*] Creating desktop shortcut..."

ICON_PATH=""
if [ -f "$GAME_PATH/AA.ico" ]; then
    ICON_PATH="$GAME_PATH/AA.ico"
fi

cat > "$HOME/.local/share/applications/AxisAlliesRTS.desktop" << EOF
[Desktop Entry]
Name=Axis & Allies RTS
Comment=Axis & Allies RTS (Linux Compatibility Patch by jShum00)
Exec=$GAME_PATH/launch.sh
Icon=$ICON_PATH
Terminal=false
Type=Application
Categories=Game;
EOF

chmod +x "$HOME/.local/share/applications/AxisAlliesRTS.desktop"
echo "[OK] Desktop shortcut created."

# --- Done ---
echo ""
echo "============================================"
echo " Setup complete!"
echo "============================================"
echo ""
echo " You can now launch the game by:"
echo "   - Running: $GAME_PATH/launch.sh"
echo "   - Or from your applications menu: Axis & Allies RTS"
echo ""
echo " Enjoy the game!"
echo ""
