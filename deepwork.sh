# Script to Automate Your Deepwork (MacOS)
# Requirements:
  # Homebrew:
    # /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Cold Turkey (Free Version) 
    # https://getcoldturkey.com
  # Arttime CLI application:
    # brew install arttime

# Usage:
  # Open terminal and type nano ~/.zshrc
  # Setup different blocklists on Cold Turkey and set them to continous 
  # I currently have blocks for Google, Amazon, Stocks, and Messages

deepwork() {
  # Prompt the user for how long they want to block distractions
  read "hours? > how long? (in hours): "
  read "google_amazon? > block google/amazon? (y/n): "
  read "stocks? > block stocks? (y/n): "
  read "messages? > block messages? (y/n): "

  # Convert hours to minutes
  minutes=$((hours * 60))

  # Cold Turkey Free web blocker path
  blocker="/Applications/Cold Turkey Blocker.app/Contents/MacOS/Cold Turkey Blocker"

  # Initialize empty list for the websites to block
  to_block=()

  # Add the websites to block based on user input
  [[ "$stocks" == "y" ]] && to_block+=("finance")
  [[ "$google_amazon" == "y" ]] && to_block+=("google, amazon") 
  [[ "$messages" == "y" ]] && to_block+=("silence") 

  # Display the websites that are being blocked
  echo ""
  echo "Blocking the following for $hours hours: ${to_block[*]}"
  echo "Press any key to cancel..."

  # Countdown before starting
  for i in {10..1}; do
    echo -n "$i... "
    sleep 1
    read -t 1 -n 1 key && { echo "Cancelled."; return; }
  done

  echo ""
  
  # Block the selected websites using Cold Turkey Free
  for block in "${to_block[@]}"; do
    "$blocker" -start "$block" -lock "$minutes"
  done

  # Path for arttime from Homebrew
  /opt/homebrew/bin/arttime --nolearn -a butterfly -t "Deep work time – blocking distractions"
}
