#!/bin/bash

# Convert markdown to docx for easy Google Docs upload
# Usage: ./md2docs.sh <markdown-file>

if [ -z "$1" ]; then
    echo "Usage: ./md2docs.sh <markdown-file>"
    exit 1
fi

INPUT="$1"
FILENAME=$(basename "$INPUT" .md)
OUTPUT_DIR="$HOME/Desktop"
OUTPUT="$OUTPUT_DIR/${FILENAME}.docx"

if [ ! -f "$INPUT" ]; then
    echo "Error: File '$INPUT' not found"
    exit 1
fi

if ! command -v pandoc &> /dev/null; then
    echo "Pandoc not installed. Run: brew install pandoc"
    exit 1
fi

pandoc "$INPUT" -o "$OUTPUT"

if [ $? -eq 0 ]; then
    echo "✓ Created: $OUTPUT"
    open -R "$OUTPUT"  # Opens Finder with file selected
else
    echo "Error: Conversion failed"
    exit 1
fi
