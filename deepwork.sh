#!/bin/bash

# Deepwork Automation Script

# TODO: Add the following features to this script:
#   - Desktop notifications (osascript -e 'display notification "..."')
#   - Pomodoro count in the menu bar
#   - Custom work/break durations

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

# Website input
echo "Enter websites to block (comma-separated)."
echo "Leave input empty to finish."
websites_to_block=()
while true; do
  echo "Websites (e.g. facebook.com, twitter.com):"
  read input
  if [[ -z "$input" ]]; then
    break
  fi
  IFS=',' read -ra sites <<< "$input"
  for site in "${sites[@]}"; do
    trimmed=$(echo "$site" | xargs)
    if [[ -n "$trimmed" ]]; then
      websites_to_block+=("$trimmed")
    fi
  done
done

# Enable Do Not Disturb
echo "Enabling Do Not Disturb..."
osascript ~/enable_dnd.scpt

# Modify /etc/hosts if needed
if [[ "${#websites_to_block[@]}" -gt 0 ]]; then
  echo "Blocking websites..."
  tempfile=$(mktemp)
  for website in "${websites_to_block[@]}"; do
    echo "127.0.0.1 $website" >> "$tempfile"
  done
  sudo tee -a /etc/hosts < "$tempfile" > /dev/null
  rm "$tempfile"
else
  echo "No websites entered. Skipping blocking."
fi

# Close distraction apps
echo "Closing known distraction apps..."
apps_to_close=("Safari" "Firefox" "Brave" "Slack" "Discord" "Zoom")
for app in "${apps_to_close[@]}"; do
  pkill "$app" 2>/dev/null
done

# Start soundtrack
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

# Countdown timer if no Pomodoro
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
echo "Session complete. Restoring system state..."

osascript ~/disable_dnd.scpt

# Clean up /etc/hosts
if [[ "${#websites_to_block[@]}" -gt 0 ]]; then
  sudo sed -i '' '/127.0.0.1/d' /etc/hosts
fi

# Stop soundtrack
if [[ "$play_soundtrack" == "y" ]]; then
  kill "$soundtrack_pid" 2>/dev/null
fi

echo "Deep work session completed."
