#!/bin/bash

# Check if input file with filenames is provided
if [ -z "$1" ]; then
  echo "Usage: $0 file_with_list_of_files.txt"
  exit 1
fi

# Read the list of files line by line
while IFS= read -r file; do
  if [ -e "$file" ]; then
    echo "File: $file"
    ls -l "$file"
    read -p "Do you want to remove this file? (y/n): " confirm
    if [[ "$confirm" == "y" ]]; then
      rm "$file"
      echo "Removed: $file"
    else
      echo "Skipped: $file"
    fi
  else
    echo "File does not exist: $file"
  fi
done < "$1"
