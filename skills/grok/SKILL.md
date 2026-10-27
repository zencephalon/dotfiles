---
name: grok
description: Delegate a coding task to the grok CLI (grok-4.5) as a headless sub-agent. Use when the user says /grok, "have grok do it", "delegate to grok", or wants to save Claude usage on a well-specified coding task.
---

# Grok as a coding sub-agent

Delegate the given task to the `grok` CLI running headless. You (Claude) remain the orchestrator: write a precise prompt, run grok, then review its output/diff.

## How to run

Basic delegation (grok edits files itself):

```bash
grok -p "<precise task description>" --always-approve --max-turns 30
```

Key flags:
- `--cwd <dir>` — target directory (defaults to current).
- `--check` — appends a self-verification loop; use for nontrivial tasks.
- `--worktree[=name]` — run in an isolated git worktree; use when the working tree is dirty or the task is risky. Merge/review afterwards via `grok worktree`.
- `--best-of-n N` — run N attempts in parallel, pick best (expensive; only if asked).
- `--output-format json` / `--json-schema '<schema>'` — structured output for answer-only (non-editing) queries.
- `--no-subagents`, `--disable-web-search` — trim capabilities when not needed.
- `-c` / `--resume` — continue grok's previous session for follow-up fixes instead of re-explaining.

For tasks likely to take >2 minutes, run via Bash with `run_in_background: true` and review when it finishes.

## Prompt-writing rules

Grok starts cold — it has none of your conversation context. Include in the prompt:
1. Concrete goal and acceptance criteria ("done when `pytest tests/x.py` passes").
2. Relevant file paths and constraints/conventions you already know.
3. What NOT to touch.
Keep scope to one coherent task per invocation.

## After grok finishes

1. Review the changes — you own the result, not grok. Check `git status` first: `git diff` for tracked files, but read new/untracked files directly (they don't show in `git diff`).
2. Run the relevant tests/build yourself and report verified results.
3. If the result is wrong, prefer `grok -c -p "<correction>"` over redoing it yourself, unless it's a one-line fix.

## Notes

- Auth: `grok models` verifies login (grok.com account). If logged out, tell the user to run `grok login`.
- Usage limits are unknown/free-tier: if grok errors with rate limits, report it and fall back to doing the task yourself after confirming with the user.
- Never pass secrets in the prompt; grok is a third-party service.
