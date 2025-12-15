#!/bin/bash

# extract-history.sh
# Extracts user prompts from Claude Code conversation history
# Outputs clean text for AI analysis (no pattern matching here)

set -e

PROJECTS_DIR="${HOME}/.claude/projects"
DAYS="${1:-30}"  # Default to 30 days, or pass as argument

# Check if jq is available
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed" >&2
    exit 1
fi

# Check if projects directory exists
if [[ ! -d "$PROJECTS_DIR" ]]; then
    echo "Error: No conversation history found at $PROJECTS_DIR" >&2
    exit 1
fi

# Find session files from last N days and extract user prompts
# Use xargs to process files and aggregate output
find "$PROJECTS_DIR" -name "*.jsonl" -type f -mtime -"$DAYS" 2>/dev/null | \
    xargs -I {} sh -c 'jq -r "select(.type == \"user\") | .message.content | if type == \"string\" then . else empty end" "{}" 2>/dev/null' | \
    grep -v "^<" | \
    grep -v "<command-" | \
    grep -v "<local-command" | \
    grep -v "<system-reminder>" | \
    grep -v "^Warmup$" | \
    grep -v "^Caveat:" | \
    grep -v "^$"
