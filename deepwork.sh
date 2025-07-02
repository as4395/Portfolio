#!/bin/bash

# Deepwork Automation Script

echo "Welcome to Deepwork automation."

# Duration input
read -p "How long do you want to block distractions? (hours, e.g. 1.5): " hours

# Soundtrack
read -p "Play soundtrack? (y/n): " play_soundtrack
if [[ "$play_soundtrack" == "y" ]]; then
  read -p "Enter full path to soundtrack mp3: " soundtrack_path
fi

# Website blocklist
declare -A categories
echo "Enter categories and websites to block."
echo "Leave category empty to finish."

while true; do
  read -p "Category name (or ENTER to finish): " category_name
  if [ -z "$category_name" ]; then
    break
  fi
  read -p "Websites (comma-separated): " websites
  categories["$category_name"]=$websites
done

# Enable Do Not Disturb
echo "Enabling Do Not Disturb..."
osascript ~/enable_dnd.scpt

# Block websites via /etc/hosts
echo "Modifying /etc/hosts to block websites..."
sudo bash -c 'echo "" >> /etc/hosts'  # just a newline
for category in "${!categories[@]}"; do
  for website in ${categories[$category]//,/ }; do
    echo "127.0.0.1 $website" | sudo tee -a /etc/hosts > /dev/null
  done
done

# Close distraction apps
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
read -p "Enable Pomodoro mode? (y/n): " pomodoro_mode
if [[ "$pomodoro_mode" == "y" ]]; then
  pomodoro_duration=25
  break_duration=5
  while true; do
    echo "Pomodoro: Work for $pomodoro_duration minutes!"
    sleep $((pomodoro_duration * 60))
    echo "Take a break for $break_duration minutes!"
    sleep $((break_duration * 60))
  done
fi

# Countdown timer
echo "Session started. Time remaining: $hours hours."
total_seconds=$(echo "$hours * 3600" | bc | cut -d'.' -f1)

progress_bar() {
  local total=$1
  local interval=60  # update every minute
  local elapsed=0
  while [ "$elapsed" -lt "$total" ]; do
    percent=$(( 100 * elapsed / total ))
    echo -ne "Progress: [$percent%] Elapsed: $((elapsed / 60)) min\r"
    sleep $interval
    elapsed=$((elapsed + interval))
  done
  echo -e "\nTime's up!"
}

progress_bar "$total_seconds"

# Restore system state
echo "Session complete!"
echo "Restoring system state..."

osascript ~/disable_dnd.scpt

# Clean up /etc/hosts
sudo sed -i '' '/127.0.0.1/d' /etc/hosts

# Stop soundtrack
if [[ "$play_soundtrack" == "y" ]]; then
  kill "$soundtrack_pid" 2>/dev/null
fi

echo "✅ Deep work session completed!"
