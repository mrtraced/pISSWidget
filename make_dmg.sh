#!/bin/bash
# Creates a styled DMG for pISSWidget using create-dmg.
# Requires: brew install create-dmg
#
# Usage:
#   ./make_dmg.sh [/path/to/pISSWidget.app]

set -eo pipefail

# ── Locate the .app ──
APP_PATH="${1:-}"
if [ -z "$APP_PATH" ]; then
    if [ -d "$HOME/Desktop/pISSWidget/pISSWidget.app" ]; then
        APP_PATH="$HOME/Desktop/pISSWidget/pISSWidget.app"
    elif [ -d "/Applications/pISSWidget.app" ]; then
        APP_PATH="/Applications/pISSWidget.app"
    else
        echo "Usage: ./make_dmg.sh /path/to/pISSWidget.app"
        exit 1
    fi
fi

if [ ! -d "$APP_PATH" ]; then
    echo "Error: $APP_PATH not found"
    exit 1
fi

# ── Locate background image ──
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$(dirname "$APP_PATH")"
BG_IMAGE=""
for dir in "$SOURCE_DIR" "$SCRIPT_DIR"; do
    for name in ".background/background.png" ".background/bg.png" "background.png" "background.jpeg" "background.jpg"; do
        if [ -f "$dir/$name" ]; then
            BG_IMAGE="$dir/$name"
            break 2
        fi
    done
done

# ── Locate readme ──
README_FILE=""
for dir in "$SCRIPT_DIR" "$SOURCE_DIR"; do
    for name in "How to Install.txt" "WTF is this?.rtf" "README.txt" "README.md"; do
        if [ -f "$dir/$name" ]; then
            README_FILE="$dir/$name"
            README_NAME="$name"
            break 2
        fi
    done
done

echo "📦 Building DMG"
echo "  App:        $APP_PATH"
echo "  Background: ${BG_IMAGE:-none}"
echo "  Readme:     ${README_FILE:-none}"

# ── Strip xattrs and ad-hoc sign ──
echo "  Stripping extended attributes and resource forks..."
xattr -cr "$APP_PATH"
find "$APP_PATH" -type f -exec xattr -c {} + 2>/dev/null
find "$APP_PATH" -name '._*' -delete 2>/dev/null
find "$APP_PATH" -name '.DS_Store' -delete 2>/dev/null

echo "  Signing app (ad-hoc with entitlements)..."
# Sign extension first with its entitlements, then the app
APPEX="$APP_PATH/Contents/PlugIns/pISSWidgetExtension.appex"
EXT_ENT="$SCRIPT_DIR/pISSWidgetExtension/pISSWidgetExtension.entitlements"
APP_ENT="$SCRIPT_DIR/pISSWidget/pISSWidget.entitlements"

if [ -d "$APPEX" ] && [ -f "$EXT_ENT" ]; then
    codesign --force --sign - --entitlements "$EXT_ENT" "$APPEX"
    echo "  Signed extension with entitlements"
fi
codesign --force --sign - --entitlements "$APP_ENT" "$APP_PATH"
echo "  Signed app with entitlements"

# ── Build create-dmg command ──
DMG_FINAL="pISSWidget.dmg"
rm -f "$DMG_FINAL"

CMD=(create-dmg
    --volname "pISSWidget"
    --window-size 800 532
    --icon-size 100
    --text-size 13
    --icon "pISSWidget.app" 280 200
    --app-drop-link 520 200
    --hide-extension "pISSWidget.app"
    --no-internet-enable
)

if [ -n "$BG_IMAGE" ]; then
    CMD+=(--background "$BG_IMAGE")
fi

if [ -n "$README_FILE" ]; then
    CMD+=(--add-file "$README_NAME" "$README_FILE" 400 400)
fi


CMD+=("$DMG_FINAL" "$APP_PATH")

echo "  Running create-dmg..."
"${CMD[@]}"

echo ""
echo "✅ Created: $DMG_FINAL"
echo "   $(du -h "$DMG_FINAL" | awk '{print $1}')"
echo ""
echo "Tell recipients to double-click 'Install pISS Widget.command' inside the DMG."
