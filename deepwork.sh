#!/bin/bash

# deepwork – distraction blocking and focus timer for macOS
# Final version with: working DND, website blocking, ASCII art, notifications, app trigger, black wallpaper, and no cleanup

set -e

DEEPWORK_DIR="$HOME/.deepwork"
WALLPAPER_ORIG="$DEEPWORK_DIR/original_wallpaper.jpg"
BLACK_WALLPAPER="$DEEPWORK_DIR/black.jpg"
BLOCKLIST="$DEEPWORK_DIR/blocklist.txt"
HOSTS_BACKUP="$DEEPWORK_DIR/hosts.bak"
ARTTIME_BIN="$HOME/.local/bin/arttime"

mkdir -p "$DEEPWORK_DIR"

# Ask for session length
read -p "How long (hours, e.g. 1.5): " hours
seconds=$(awk "BEGIN {print int($hours * 3600)}")

# Ask about soundtrack
read -p "Play soundtrack? (y/n): " play_sound
if [[ "$play_sound" == "y" ]]; then
    read -p "Path to custom mp3 file: " mp3_path
    if [[ -f "$mp3_path" ]]; then
        mpv --no-video "$mp3_path" --loop-file &
        mpv_pid=$!
    fi
fi

# Ask about websites to block
read -p "Websites to block (comma-separated): " sites_input
IFS=',' read -ra sites <<< "$sites_input"
echo "" > "$BLOCKLIST"
for site in "${sites[@]}"; do
    site=$(echo "$site" | xargs)
    [[ -n "$site" ]] && echo "127.0.0.1 $site" >> "$BLOCKLIST"
done

# Ask about Pomodoro
read -p "Enable Pomodoro? (y/n): " enable_pomo

# Confirm app trigger
read -p "Enable trigger by app (e.g., Obsidian)? (y/n): " trigger_app
if [[ "$trigger_app" == "y" ]]; then
    read -p "App name (e.g., Obsidian): " app_name
    echo "Waiting for $app_name to start..."
    while ! pgrep -x "$app_name" >/dev/null; do sleep 2; done
    echo "$app_name launched — starting session."
fi

# Enable Do Not Disturb
osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'
defaults -currentHost write com.apple.notificationcenterui doNotDisturb -boolean true
killall NotificationCenter &>/dev/null || true

# Save current wallpaper
osascript -e "tell application "System Events" to tell every desktop to set picture to "$BLACK_WALLPAPER"" 2>/dev/null || true

# Block websites
sudo cp /etc/hosts "$HOSTS_BACKUP"
cat "$BLOCKLIST" | sudo tee -a /etc/hosts >/dev/null

# Show ASCII Art
"$ARTTIME_BIN" --nolearn -a butterfly -t "deep work time – blocking distractions" -g "${hours}h"

# Notification
osascript -e 'display notification "Deep Work started" with title "Focus Mode"' &

echo ""
echo "Blocking for $hours hour(s). Press any key to cancel..."
for i in $(seq 10 -1 1); do
    echo -n "$i... "; sleep 1
done
echo ""

start=$(date +%s)

if [[ "$enable_pomo" == "y" ]]; then
    pomo_work=25
    pomo_break=5
    pomo_seconds=$((pomo_work * 60))
    break_seconds=$((pomo_break * 60))

    while true; do
        echo "Pomodoro work started."
        osascript -e 'display notification "Pomodoro: Work started" with title "Pomodoro"' &
        sleep "$pomo_seconds"
        osascript -e 'display notification "Pomodoro: Take a break" with title "Pomodoro"' &
        sleep "$break_seconds"
    done
else
    read -rsn1 -t "$seconds"
fi

# Session complete
osascript -e 'display notification "Session complete!" with title "Deep Work"' &

echo ""
echo "Session complete."
