#!/bin/bash
#
# space_windows.sh — AeroSpace version
# If workspace has apps → show app icon (sketchybar-app-font).
# If empty → show workspace number (JetBrainsMono).
# Clears label — icon-only mode.

AEROSPACE_PATH=$(command -v aerospace)
if [ -z "$AEROSPACE_PATH" ]; then
  [ -f "/opt/homebrew/bin/aerospace" ] && AEROSPACE_PATH="/opt/homebrew/bin/aerospace"
  [ -f "/usr/local/bin/aerospace" ] && AEROSPACE_PATH="/usr/local/bin/aerospace"
fi

ICON_MAP_PATH="$HOME/.config/sketchybar/plugins/icon_map.sh"
[ ! -f "$ICON_MAP_PATH" ] && ICON_MAP_PATH="$CONFIG_DIR/plugins/icon_map.sh"

for sid in 1 2 3 4 5; do
  app=$($AEROSPACE_PATH list-windows --workspace "$sid" --format "%{app-name}" 2>/dev/null | head -1)
  if [ -n "$app" ]; then
    icon=$($ICON_MAP_PATH "$app")
    sketchybar --set space.$sid \
      icon="$icon" \
      icon.font="sketchybar-app-font:Regular:24.0" \
      label="" \
      label.drawing=off
  else
    sketchybar --set space.$sid \
      icon="$sid" \
      icon.font="JetBrainsMono Nerd Font:Bold:17.0" \
      label="" \
      label.drawing=off
  fi
done
