#!/bin/bash

# CONFIG
DEEPWORK_DIR="$HOME/.deepwork"
WALLPAPER_BACKUP="$DEEPWORK_DIR/original_wallpaper.jpg"
BLOCKLIST="/etc/hosts"
BACKUP_HOSTS="$DEEPWORK_DIR/hosts.backup"
DND_ON="$DEEPWORK_DIR/enable_dnd.sh"
DND_OFF="$DEEPWORK_DIR/disable_dnd.sh"

# FUNCTIONS

function notify() {
  osascript -e "display notification \"$1\" with title \"DeepWork\""
}

function get_wallpaper() {
  osascript -e 'tell application "System Events" to get picture of current desktop'
}

function set_wallpaper() {
  osascript -e "tell application \"System Events\" to set picture of every desktop to \"$1\""
}

function backup_wallpaper() {
  local current
  current="$(get_wallpaper)"
  cp "$current" "$WALLPAPER_BACKUP" 2>/dev/null
}

function start_dnd() {
  bash "$DND_ON"
}

function stop_dnd() {
  bash "$DND_OFF"
}

function block_websites() {
  sudo cp "$BLOCKLIST" "$BACKUP_HOSTS"
  IFS=',' read -ra SITES <<< "$1"
  for site in "${SITES[@]}"; do
    clean=$(echo "$site" | sed 's|https\?://||g' | sed 's|/.*||g')
    echo "127.0.0.1 $clean" | sudo tee -a "$BLOCKLIST" > /dev/null
  done
  dscacheutil -flushcache
}

function restore_websites() {
  if [ -f "$BACKUP_HOSTS" ]; then
    sudo cp "$BACKUP_HOSTS" "$BLOCKLIST"
    dscacheutil -flushcache
  fi
}

function wait_for_app() {
  app="$1"
  echo "Waiting for $app to open..."
  while true; do
    if pgrep -x "$app" > /dev/null; then
      break
    fi
    sleep 2
  done
}

function countdown() {
  secs="$1"
  echo "Blocking for $(bc <<< "$secs/3600") hour(s)."
  echo "Press any key to cancel..."
  read -t 10 -n 1 && { echo "Cancelled."; cleanup; exit; }

  for i in $(seq 10 -1 1); do
    echo -n "$i... "
    sleep 1
  done
  echo
}

function cleanup() {
  echo -e "\n🧹 Cleaning up…"
  restore_websites
  stop_dnd
  [ -f "$WALLPAPER_BACKUP" ] && set_wallpaper "$WALLPAPER_BACKUP"
  killall afplay 2>/dev/null
  notify "Session ended."
}

# MAIN

read -p "How long (hours, e.g. 1.5): " hours
duration=$(echo "$hours * 3600" | bc)
read -p "Play soundtrack? (y/n): " play
if [[ "$play" == "y" ]]; then
  echo "Provide path to mp3 file (e.g., ~/Downloads/track.mp3):"
  read -r music_path
  afplay "$music_path" &
fi

read -p "Websites to block (comma-separated): " sites
read -p "Enable Pomodoro? (y/n): " pomo
read -p "Wait for app to launch before starting? (leave blank to skip): " waitapp

[ -n "$waitapp" ] && wait_for_app "$waitapp"

notify "Session started"
backup_wallpaper
set_wallpaper "/System/Library/Desktop Pictures/Solid Colors/Solid Black.png"
start_dnd
block_websites "$sites"

countdown "$duration"

if [[ "$pomo" == "y" ]]; then
  work=1500  # 25 mins
  break=300  # 5 mins
  while true; do
    echo "Pomodoro: Work for $(($work / 60)) min"
    notify "Pomodoro: Work session started"
    sleep "$work"
    echo "Pomodoro: Break for $(($break / 60)) min"
    notify "Pomodoro: Break time"
    sleep "$break"
  done
else
  sleep "$duration"
fi

cleanup
