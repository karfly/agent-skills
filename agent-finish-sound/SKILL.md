---
name: agent-finish-sound
description: Play an audible notification when Codex completes a task or sends the final response. Use when the user asks for sound alerts on completion or wants a finish chime.
---

# Agent Finish Sound

## Workflow

1. After completing all steps for the request and right before the chat response, run the script using an absolute path:
   - `$CODEX_HOME/skills/agent-finish-sound/scripts/play_sound.sh` (preferred if `CODEX_HOME` is set)
   - `~/.codex/skills/agent-finish-sound/scripts/play_sound.sh` (fallback)
2. The script plays the bundled `scripts/complete.wav` if present, otherwise `scripts/complete.mp3`.
