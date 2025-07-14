#!/bin/bash

# Set the base directory (use current directory)
BASE_DIR=$(pwd)

# Set the file name
FILE_NAME="pdb.yaml"

# Loop through all directories
find "$BASE_DIR" -type d | while read -r dir; do
  # Define content dynamically inside the loop to use $dir for each directory
  CONTENT="apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: $(basename $dir)
  labels:
    app: $(basename $dir)
spec:
  minAvailable: 1
  selector:
    matchLabels:
      app: $(basename $dir)"

  # Create the file with the content in each directory
  echo "$CONTENT" > "$dir/$FILE_NAME"
  echo "Created $FILE_NAME in $dir"
done
