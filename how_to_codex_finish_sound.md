How to enable the Codex finish sound

Add the following line to your `~/.codex/config.toml`:

```
notify = ["bash", "-lc", "afplay /System/Library/Sounds/Blow.aiff"]
```

Important: this line must appear above all `[ ... ]` sections, for example at the very top of the file.

One-line command to insert it at the top safely:

```
line='notify = ["bash", "-lc", "afplay /System/Library/Sounds/Blow.aiff"]'; ed -s ~/.codex/config.toml <<< $'0a\n'"$line"$'\n.\nwq'
```
