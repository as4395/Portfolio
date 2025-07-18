#!/bin/bash

export TERM=xterm-256color

# -------- CONFIG --------
ARTTIME="$HOME/.local/bin/arttime"
HOSTS_BACKUP="/etc/hosts.backup"
SOUND_DIR="$HOME/Music"
LOFI_URL="https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"
WHITE_NOISE_URL="https://www.soundjay.com/misc/sounds/white-noise-01.mp3"
LOFI_PATH="$SOUND_DIR/lofi.mp3"
WHITE_NOISE_PATH="$SOUND_DIR/white_noise.mp3"

# -------- FUNCTIONS --------

convert_hours_to_arttime_goal() {
  # Calculate full future datetime string (YYYY-MM-DD HH:MM:SS)
  date -v+${1%.*}H -v+$(awk "BEGIN { printf \"%d\", ( $1 - int($1) ) * 60 }")M "+%Y-%m-%d %H:%M:%S"
}

enable_dnd() { defaults -currentHost write com.apple.notificationcenterui doNotDisturb -boolean true; killall NotificationCenter 2>/dev/null; }
disable_dnd() { defaults -currentHost write com.apple.notificationcenterui doNotDisturb -boolean false; killall NotificationCenter 2>/dev/null; }
notify() { osascript -e "display notification \"$1\" with title \"Deep Work\" sound name \"Submarine\""; }

block_websites() {
  [[ -z "$DISTRACTION_LIST" ]] && return
  IFS=',' read -ra to_block <<< "$DISTRACTION_LIST"
  echo; echo "Blocking ${to_block[*]} for $hours hours."; echo "Press any key to cancel..."
  for i in {10..1}; do
    echo -n "$i... "; read -t 1 -n 1 key && { echo "Cancelled."; return; }
  done
  echo; sudo cp /etc/hosts "$HOSTS_BACKUP"
  sudo bash -c "echo '127.0.0.1 localhost' > /etc/hosts"
  for site in "${to_block[@]}"; do
    sudo bash -c "echo '127.0.0.1 $site' >> /etc/hosts"
    sudo bash -c "echo '127.0.0.1 www.$site' >> /etc/hosts"
  done
  sudo dscacheutil -flushcache
}

restore_hosts() {
  [[ -f "$HOSTS_BACKUP" ]] && sudo cp "$HOSTS_BACKUP" /etc/hosts && sudo dscacheutil -flushcache
}

wait_for_app() {
  echo "Waiting for $1..."; while ! pgrep -x "$1" >/dev/null; do sleep 2; done
  echo "$1 detected—starting session."
}

download_soundtrack() {
  mkdir -p "$SOUND_DIR"
  
  # Check if the lo-fi soundtrack exists, otherwise download it
  if [[ "$sound_type" == "lofi" && ! -f "$LOFI_PATH" ]]; then
    echo "Downloading lo-fi music..."
    curl -fL -o "$LOFI_PATH" "$LOFI_URL" || { echo "Failed to download lo-fi music."; exit 1; }
  fi
  
  # Check if the white noise soundtrack exists, otherwise download it
  if [[ "$sound_type" == "white_noise" && ! -f "$WHITE_NOISE_PATH" ]]; then
    echo "Downloading white noise..."
    curl -fL -o "$WHITE_NOISE_PATH" "$WHITE_NOISE_URL" || { echo "Failed to download white noise."; exit 1; }
  fi
}

play_soundtrack() {
  case "$sound_type" in
    lofi) afplay "$LOFI_PATH" & ;;
    white_noise) afplay "$WHITE_NOISE_PATH" & ;;
    custom) afplay "$custom_path" & ;;
  esac
}

ascii_art_time() {
  [[ -x "$ARTTIME" ]] && "$ARTTIME" --nolearn -a butterfly -t "deep work time – blocking distractions" -g "$1" || echo "(arttime failed)"
}

# -- MAIN --

clear; echo "Deep Work Session Setup"
read -p "Duration (hours, e.g. 1.5): " hours
read -p "Soundtrack? (lofi / white_noise / none / custom): " sound_type

if [[ "$sound_type" == "custom" ]]; then
  read -p "Enter full path: " custom_path
  [[ ! -f "$custom_path" ]] && echo "Not found." && sound_type="none"
fi

read -p "Websites to block (comma-separated): " DISTRACTION_LIST
read -p "Trigger by app? (y/n): " trigger
[[ "$trigger" == "y" ]] && read -p "App name: " trigger_app && wait_for_app "$trigger_app"

notify "Started for $hours hours"; enable_dnd; block_websites
[[ "$sound_type" != "none" ]] && download_soundtrack && play_soundtrack

goal=$(convert_hours_to_arttime_goal "$hours")
ascii_art_time "$goal"

sleep "$(awk "BEGIN { print int($hours * 3600) }")"

notify "Session complete!"; disable_dnd; restore_hosts
echo "Focus session complete."
