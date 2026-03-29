#!/bin/bash
# Quick helper to create task issues from CLI

TITLE="$1"
DESCRIPTION="$2"
VERIFY_CMD="$3"
TIMING="${4:-immediate}"

if [ -z "$TITLE" ]; then
  echo "Usage: ./create-task.sh 'title' 'description' 'verify command' [timing]"
  exit 1
fi

BODY="## Task Description
$DESCRIPTION

## Implementation
[To be filled by Opus/Codex]

## Verify
\`\`\`bash
$VERIFY_CMD
\`\`\`

## Verification Timing
$TIMING

## Context
Created: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
"

gh issue create --title "$TITLE" --body "$BODY" --label "pending-verify"
