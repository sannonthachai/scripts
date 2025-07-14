#!/bin/bash

# Set the base directory (use current directory)
BASE_DIR=$(pwd)

# Set the specific file name to delete
FILE_NAME="pdb.yaml"

# Loop through all directories and find the file
find "$BASE_DIR" -type f -name "$FILE_NAME" | while read -r file; do
  # Delete the file
  rm "$file"
  echo "Deleted $file"
done
