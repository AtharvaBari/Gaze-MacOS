#!/bin/bash

# Gaze Update Setup Script
# Helps manage Sparkle EdDSA keys and appcast generation.

set -e

SPARKLE_BIN="xcodegen/libs/Sparkle/bin" # Adjust if Sparkle binary is elsewhere
APPCAST_PATH="appcast.xml"

echo "🔐 Sparkle Update Management"
echo "----------------------------"

function generate_keys() {
    echo "Creating new EdDSA keys..."
    # Note: This assumes Sparkle's generate_keys tool is available or provides instructions
    echo "If you don't have keys yet, download Sparkle from https://sparkle-project.org/"
    echo "Then run: bin/generate_keys"
    echo "This will give you a Private Key (keep safe!) and a Public Key (put in Info.plist)."
}

function update_appcast() {
    echo "Updating $APPCAST_PATH..."
    # Logic to update appcast.xml with latest version, file size, and signature
    # In a real environment, you'd use Sparkle's generate_appcast tool
    echo "Run: bin/generate_appcast path/to/build/artifacts"
    echo "This will update your appcast.xml automatically."
}

echo "Select an option:"
echo "1) Generate Keys instructions"
echo "2) Update Appcast instructions"
read -p "Option: " opt

case $opt in
    1) generate_keys ;;
    2) update_appcast ;;
    *) echo "Invalid option" ;;
esac
