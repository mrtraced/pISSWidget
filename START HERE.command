#!/bin/bash
# Installs pISS Widget and registers it with the widget system.

APP_NAME="pISSWidget.app"
DEST="/Applications/$APP_NAME"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE="$SCRIPT_DIR/$APP_NAME"

if [ ! -d "$SOURCE" ]; then
    echo "Can't find $APP_NAME next to this script."
    echo "Make sure you're running this from inside the DMG."
    exit 1
fi

echo "Installing pISS Widget to /Applications..."
cp -R "$SOURCE" /Applications/

# Extract entitlements from the already-signed binaries and re-sign
# (copying can invalidate signatures)
echo "Re-signing with entitlements..."
APPEX="$DEST/Contents/PlugIns/pISSWidgetExtension.appex"
if [ -d "$APPEX" ]; then
    EXT_ENT=$(mktemp)
    APP_ENT=$(mktemp)
    codesign -d --entitlements - "$SOURCE/Contents/PlugIns/pISSWidgetExtension.appex" > "$EXT_ENT" 2>/dev/null
    codesign -d --entitlements - "$SOURCE" > "$APP_ENT" 2>/dev/null
    codesign --force --sign - --entitlements "$EXT_ENT" "$APPEX" 2>/dev/null
    codesign --force --sign - --entitlements "$APP_ENT" "$DEST" 2>/dev/null
    rm -f "$EXT_ENT" "$APP_ENT"
fi

# Clear quarantine AFTER re-signing (codesign can re-trigger Gatekeeper)
echo "Clearing quarantine and whitelisting..."
xattr -cr "$DEST"
# Add to Gatekeeper whitelist so macOS stops showing "not verified" popups
spctl --add --label "pISSWidget" "$DEST" 2>/dev/null

echo "Opening Privacy & Security settings (click 'Open Anyway' if prompted)..."
open "x-apple.systempreferences:com.apple.preference.security?General"

echo "Launching app to register widgets..."
open "$DEST"

# Give the app a moment to register its extension with the system
sleep 3

echo "Refreshing widget system..."
killall NotificationCenter 2>/dev/null

echo ""
echo "Done! The widget should now be available."
echo "  Right-click your desktop > Edit Widgets > search 'pISS'"
echo ""
echo "If you don't see it, try logging out and back in."

# Auto-close the Terminal window
osascript -e 'tell application "Terminal" to close front window' &
