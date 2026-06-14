#!/bin/sh
#
# front_app.sh — AeroSpace version
# Displays current app icon (via sketchybar-app-font) and name

if [ "$SENDER" = "front_app_switched" ]; then
  APP_NAME="$INFO"

  # Fix abbreviated app names from AeroSpace
  [ "$APP_NAME" = "System" ] && APP_NAME="System Settings"
  [ "$APP_NAME" = "Code" ] && APP_NAME="Visual Studio Code"

  # Check if we have a valid app name
  if [ -z "$APP_NAME" ] || [ "$APP_NAME" = "" ]; then
    sketchybar --animate tanh 10 --set "$NAME" label="Finder" icon=":finder:"
  else
    sketchybar --animate tanh 10 --set "$NAME" label="$APP_NAME" icon="$($CONFIG_DIR/plugins/icon_map.sh "$APP_NAME")"
  fi
fi
