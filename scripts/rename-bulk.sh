#!/bin/bash
 
# Usage: ./rename-bulk.sh <directory> [--dry-run]
 
# Check if directory is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <directory> [--dry-run]"
  exit 1
fi
 
# Get directory path from the first argument
DIR="$1"
 
# Check if directory exists
if [ ! -d "$DIR" ]; then
  echo "Error: Directory '$DIR' does not exist."
  exit 1
fi
 
# Check for --dry-run flag
DRY_RUN=false
if [ "$2" == "--dry-run" ]; then
  DRY_RUN=true
fi
 
# Process files in the directory
find "$DIR" -type f | while read FILE; do
  # Extract filename and extension
  BASENAME=$(basename -- "$FILE")
  EXTENSION="${BASENAME##*.}"
  FILENAME="${BASENAME%.*}"
 
  # Perform transformations:
  # 1. Replace spaces, underscores, and '(' with hyphens, and remove ')'
  TRANSFORMED=$(echo "$FILENAME" | tr ' _(' '-')
  TRANSFORMED=$(echo "$TRANSFORMED" | tr -d ')')
 
  # 2. Handle camel case (split before capital letters)
  NEW_NAME=$(echo "$TRANSFORMED" | sed -E 's/([a-z])([A-Z])/\1-\L\2/g')
 
  # 3. Convert everything to lowercase
  NEW_NAME="${NEW_NAME,,}"
 
  # 4. Remove consecutive hyphens
  NEW_NAME=$(echo "$NEW_NAME" | sed 's/--*/-/g')
 
  # Combine with lowercase extension
  NEW_FILE="$NEW_NAME.$(echo "$EXTENSION" | tr '[:upper:]' '[:lower:]')"
 
  # Check if the new name is different
  if [[ "$BASENAME" != "$NEW_FILE" ]]; then
    if $DRY_RUN; then
      # Dry run: only display the changes
      echo "[DRY RUN] $BASENAME -> $NEW_FILE"
    else
      # Rename the file
      mv "$FILE" "$(dirname "$FILE")/$NEW_FILE"
      echo "Renamed: $BASENAME -> $NEW_FILE"
    fi
  fi
done