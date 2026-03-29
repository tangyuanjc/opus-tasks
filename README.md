# Opus Tasks

AutoLoop-inspired task management for Claude Opus CLI collaboration.

## Core Principle

**"Most tasks don't need a human to remember — they need a loop"**

## How It Works

1. Create GitHub issue for each task
2. Attach `verify` code block for validation
3. Set verification timing
4. System auto-verifies and updates status
5. Failed tasks auto-retry with memory
6. After 3 failures, escalate to human

## Issue Template

```markdown
## Task Description
[What needs to be done]

## Implementation
[What was done]

## Verify
```bash
# Verification commands
```

## Verification Timing
[When to verify: immediate / 2 hours / 1 day / 1 week]

## Retry History
[Auto-populated on failures]
```

## Labels

- `type:architecture` - Architecture design tasks
- `type:implementation` - Code implementation
- `type:observation` - Long-term observation
- `type:bug` - Bug fixes
- `pending-verify` - Awaiting verification
- `verified` - Verification passed
- `needs-retry` - Verification failed, needs retry
- `needs-decision` - Max retries exceeded, human decision needed

## Status Flow

```
new issue → pending-verify → verified (close)
                ↓ (failed)
            needs-retry (retry_count++)
                ↓ (retry_count >= 3)
            needs-decision (notify human)
```
