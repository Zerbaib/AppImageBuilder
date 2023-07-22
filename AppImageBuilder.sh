#!/bin/bash

if [ $# -ne 1 ]; then
  echo "Usage: $0 <appimage file path>"
  exit 1
fi

appimage_file="$1"
app_name=$(basename "$appimage_file")
desktop_file="$(xdg-user-dir DESKTOP)/$app_name.desktop"

# Check if the AppImage file exists
if [ ! -f "$appimage_file" ]; then
  echo "The file $appimage_file does not exist."
  exit 1
fi

# Update GTK (commands may vary based on the distribution)
if command -v apt-get &>/dev/null; then
  sudo apt-get update
  sudo apt-get install --reinstall libgtk-3-0
elif command -v dnf &>/dev/null; then
  sudo dnf upgrade gtk3
elif command -v yum &>/dev/null; then
  sudo yum upgrade gtk3
elif command -v pacman &>/dev/null; then
  sudo pacman -Syu gtk3
fi

# Make the AppImage file executable
chmod +x "$appimage_file"

# Create the .desktop shortcut file on the desktop
echo "[Desktop Entry]
Version=1.0
Type=Application
Name=${app_name%.*}
Exec=\"$appimage_file\"
Icon=
Terminal=false
Categories=Utility;" > "$desktop_file"

# Give execute permission to the .desktop shortcut file
chmod +x "$desktop_file"

# Execute the application
"$appimage_file"
