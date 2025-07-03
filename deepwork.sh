#!/bin/bash

# Deepwork Automation Script

echo "Welcome to Deepwork automation."

# Ask for sudo access upfront
echo "Requesting sudo access..."
sudo -v || { echo "Sudo failed. Exiting."; exit 1; }

# Duration input
echo "How long do you want to block distractions? (hours, e.g. 1.5):"
read hours
if [[ -z "$hours" ]]; then
  echo "No duration entered. Exiting."
  exit 1
fi

# Soundtrack
echo "Play soundtrack? (y/n):"
read play_soundtrack
if [[ "$play_soundtrack" == "y" ]]; then
  echo "Enter full path to soundtrack mp3:"
  read soundtrack_path
fi

# Website blocklist
declare -A categories
echo "Enter categories and websites to block."
echo "Leave category empty to finish."

while true; do
  echo "Category name (or ENTER to finish):"
  read category_name
  if [ -z "$category_name" ]; then
    break
  fi
  echo "Websites for $category_name (comma-separated):"
  read websites
  categories["$category_name"]=$websites
done

# Enable Do Not Disturb
echo "Enabling Do Not Disturb..."
osascript ~/enable_dnd.scpt

# Block websites via /etc/hosts
echo "Modifying /etc/hosts to block websites..."
tempfile=$(mktemp)
for category in "${!categories[@]}"; do
  for website in ${categories[$category]//,/ }; do
    echo "127.0.0.1 $website" >> "$tempfile"
  done
done
sudo tee -a /etc/hosts < "$tempfile" > /dev/null
rm "$tempfile"

# Close known distraction apps
echo "Closing known distraction apps..."
apps_to_close=("Safari" "Firefox" "Brave" "Slack" "Discord" "Zoom")
for app in "${apps_to_close[@]}"; do
  pkill "$app" 2>/dev/null
done

# Start soundtrack if needed
if [[ "$play_soundtrack" == "y" ]]; then
  afplay "$soundtrack_path" &
  soundtrack_pid=$!
fi

# Pomodoro mode
echo "Enable Pomodoro mode? (y/n):"
read pomodoro_mode
if [[ "$pomodoro_mode" == "y" ]]; then
  pomodoro_duration=25
  break_duration=5
  total_seconds=$(echo "$hours * 3600" | bc | cut -d'.' -f1)
  cycles=$(( total_seconds / ((pomodoro_duration + break_duration) * 60) ))

  for ((i=1; i<=cycles; i++)); do
    echo "Pomodoro $i: Work for $pomodoro_duration minutes."
    sleep $((pomodoro_duration * 60))
    echo "Break: $break_duration minutes."
    sleep $((break_duration * 60))
  done

  echo "Pomodoro session complete."
  goto_end=true
fi

# Countdown timer (if not using Pomodoro)
if [[ "$goto_end" != true ]]; then
  echo "Session started. Time remaining: $hours hours."
  total_seconds=$(echo "$hours * 3600" | bc | cut -d'.' -f1)

  progress_bar() {
    local total=$1
    local interval=60
    local elapsed=0
    while [ "$elapsed" -lt "$total" ]; do
      percent=$(( 100 * elapsed / total ))
      echo -ne "Progress: [$percent%] Elapsed: $((elapsed / 60)) min\r"
      sleep $interval
      elapsed=$((elapsed + interval))
    done
    echo -e "\nTime's up."
  }

  progress_bar "$total_seconds"
fi

# Restore system state
echo "Session complete."
echo "Restoring system state..."

osascript ~/disable_dnd.scpt

# Clean up /etc/hosts
sudo sed -i '' '/127.0.0.1/d' /etc/hosts

# Stop soundtrack
if [[ "$play_soundtrack" == "y" ]]; then
  kill "$soundtrack_pid" 2>/dev/null
fi

echo "Deep work session completed."
