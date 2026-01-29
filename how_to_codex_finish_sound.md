How to enable the Codex finish sound

Add the following line to your `~/.codex/config.toml`:

```
notify = ["bash", "-lc", "afplay /System/Library/Sounds/Blow.aiff"]
```

Important: this line must appear above all `[ ... ]` sections, for example at the very top of the file.
