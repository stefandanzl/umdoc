# Conversion Directory

This directory contains scripts for converting Obsidian's wiki-links to standard Markdown links that umdoc can understand.

## Scripts

- `convert-links.sh`: Converts wiki-links in files from the `../obsidian/` directory and places the converted files in the `../chapters/` directory

## Usage

From this directory, run:

```bash
./convert-links.sh
```

This will process all Markdown files in the `../obsidian/` directory, convert Obsidian-style links to standard Markdown links, and save the results in the `../chapters/` directory.
