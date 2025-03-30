#!/bin/bash

# This script converts Obsidian-style wiki-links to standard Markdown links

# Get the directory containing this script


SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "Converting wiki-links in all Markdown files..."

# Process each Markdown file in the obsidian directory and write to the chapters directory
mkdir -p "$PROJECT_DIR/chapters"

for file in "$PROJECT_DIR/obsidian"/*.md; do
  if [ -f "$file" ]; then
    filename=$(basename "$file")
    dest_file="$PROJECT_DIR/chapters/$filename"
    
    echo "Processing $filename..."
    
    # Create a copy in the chapters directory
    cp "$file" "$dest_file"
    
    # Convert Obsidian wiki-links
    sed -i -E 's/\[\[([^|#]*)(\|([^#]*))?\]\]/[\3](#\1)/g' "$dest_file"
    
    # Convert Obsidian image links
    sed -i -E 's/!\[\[([^|]*)(\|([^#]*))?\]\]/![\3](\1)/g' "$dest_file"
    
    echo "Converted $filename -> chapters/$filename"
  fi
done

echo "Conversion complete!"
