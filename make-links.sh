#!/bin/bash

# Get into the directory where the script is being run
cd "$(dirname "$0")"

# Loop through all files and directories in the current directory
for file in *; do
    # Check if the filename contains underscores
    if [[ "$file" == *_* ]]; then
        # Replace all underscores with spaces
        new_name="${file//_/ }"
        # Rename the file
        mv -n "$file" "$new_name"
        echo "Renamed '$file' to '$new_name'"
    fi
done

echo "All applicable files have been renamed."
