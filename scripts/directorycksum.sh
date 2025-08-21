#!/bin/bash

# Check if a directory path is provided as an argument.
if [ -z "$1" ]; then
  echo "  USAGE: $0 [ DIRECTORY PATH ]"
  exit 1
fi

DIRECTORY="$1"

# Check if the provided path is a valid directory.
if [ ! -d "$DIRECTORY" ]; then
  echo "  ERROR: '$DIRECTORY' is not a valid directory."
  exit 1
fi

echo ""
echo "  --------------------------------------------------"
echo "  Calculating cksum for all files in: $DIRECTORY"
echo "  --------------------------------------------------"
echo ""

# Find all files in the directory and its subdirectories, then execute cksum on each found file.
find "$DIRECTORY" -type f -exec cksum {} \;

echo ""
