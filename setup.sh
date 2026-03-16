#!/bin/bash
set -e

echo "🚀🚽 pISS Widget — Xcode Project Setup"
echo "========================================="

# Check for XcodeGen
if ! command -v xcodegen &> /dev/null; then
    echo ""
    echo "XcodeGen not found. Installing via Homebrew..."
    if ! command -v brew &> /dev/null; then
        echo "ERROR: Homebrew is required. Install it from https://brew.sh"
        exit 1
    fi
    brew install xcodegen
fi

echo ""
echo "Generating Xcode project from project.yml..."
xcodegen generate

echo ""
echo "✅ Done! Open pISSWidget.xcodeproj in Xcode."
echo ""
echo "To build and run:"
echo "  1. Open pISSWidget.xcodeproj"
echo "  2. Select the 'pISSWidget' scheme"
echo "  3. Set signing team (Signing & Capabilities for BOTH targets)"
echo "  4. Build & Run (⌘R)"
echo "  5. Right-click desktop → Edit Widgets → search 'pISS'"
echo ""
