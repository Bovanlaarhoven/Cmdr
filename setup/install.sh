#!/bin/bash

RUBY_SCRIPT_URL="https://raw.githubusercontent.com/Robobo2022/Cmdr/main/setup/create.rb"

TMP_SCRIPT_FILE="/tmp/create.rb"

FOLDER_NAME="CMDR"

FOLDER_PATH="$HOME/$FOLDER_NAME"

wget "$RUBY_SCRIPT_URL" -O "$TMP_SCRIPT_FILE"

if [ $? -eq 0 ]; then
  ruby "$TMP_SCRIPT_FILE"
  
  rm -f "$TMP_SCRIPT_FILE"
  
  git clone https://github.com/Robobo2022/Cmdr.git "$FOLDER_PATH"
  
  if [ $? -eq 0 ]; then
    echo "Repository cloned into $FOLDER_PATH."
    
    mv "$FOLDER_PATH/Core/main.rb" "$FOLDER_PATH/CMDR"
    
    echo "Renamed 'main.rb' to 'CMDR' in $FOLDER_PATH."
    
    echo 'export PATH="$FOLDER_PATH:$PATH"' >> ~/.bashrc 
    source ~/.bashrc 
    echo "Added $FOLDER_PATH to PATH."
    
    echo "You can now use 'CMDR' in the terminal."
  else
    echo "Failed to clone the repository."
    exit 1
  fi
else
  echo "Failed to download the Ruby script."
  exit 1
fi
