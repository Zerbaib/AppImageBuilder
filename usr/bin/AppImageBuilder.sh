#!/bin/bash

# Check if AppImageBuilder is up to date
check_update() {
  latest_version=$(curl -s https://api.github.com/repos/Zerbaib/AppImageBuilder/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
  current_version=$(grep '^VERSION=' $0 | cut -d '=' -f2)
  if [ "$latest_version" != "$current_version" ]; then
    echo "AppImageBuilder is not up to date. The latest version is $latest_version."
    echo "Your version is $current_version"
  fi
}

VERSION=v1.5
 # Update this version to the latest one when releasing a new version
check_update

if [ $# -ne 1 ]; then
  echo "Usage: $0 <appimage file>"
  exit 1
fi

appimage_file="$1"
app_name=$(basename "$appimage_file")
desktop_file="$(xdg-user-dir DESKTOP)/$app_name.desktop"
start_menu_file="$HOME/.local/share/applications/$app_name.desktop"

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
Version=1.5
Type=Application
Name=${app_name%.*}
Exec=\"$appimage_file\"
Icon=
Terminal=false
Categories=Utility;" > "$desktop_file"

# Give execute permission to the .desktop shortcut file
chmod +x "$desktop_file"

# Create the .desktop file for the Start Menu
echo "[Desktop Entry]
Version=1.5
Type=Application
Name=${app_name%.*}
Exec=\"$appimage_file\"
Icon=
Terminal=false
Categories=Utility;" > "$start_menu_file"

# Give execute permission to the .desktop file for the Start Menu
chmod +x "$start_menu_file"

# Execute the application
"$appimage_file"
