#!/bin/bash

# Define the URL of the Ruby script
RUBY_SCRIPT_URL="https://raw.githubusercontent.com/Robobo2022/Cmdr/main/setup/create.rb"

# Define the temporary script file
TMP_SCRIPT_FILE="/tmp/create.rb"

# Define the folder name
FOLDER_NAME="CMDR"

# Define the folder path
FOLDER_PATH="$HOME/$FOLDER_NAME"

# Download the Ruby script from the URL
wget "$RUBY_SCRIPT_URL" -O "$TMP_SCRIPT_FILE"

if [ $? -eq 0 ]; then
  ruby "$TMP_SCRIPT_FILE"
  
  rm -f "$TMP_SCRIPT_FILE"
    git clone https://github.com/Robobo2022/Cmdr.git "$FOLDER_PATH"
    
    if [ $? -eq 0 ]; then
      echo "Repository cloned into $FOLDER_PATH."
    else
      echo "Failed to clone the repository."
      exit 1
    fi
  fi
