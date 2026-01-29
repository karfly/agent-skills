#!/usr/bin/env bash
# Play the bundled completion sound.

set -u

os="$(uname -s 2>/dev/null || echo '')"
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
sound_wav="${script_dir}/complete.wav"
sound_mp3="${script_dir}/complete.mp3"

if [[ -f "${sound_wav}" ]]; then
  sound_path="${sound_wav}"
else
  sound_path="${sound_mp3}"
fi

if [[ ! -f "${sound_path}" ]]; then
  printf '\a'
  exit 0
fi

if [[ "${os}" == "Darwin" ]] && command -v afplay >/dev/null 2>&1; then
  afplay "${sound_path}" && exit 0
fi

if command -v ffplay >/dev/null 2>&1; then
  ffplay -autoexit -nodisp -loglevel error "${sound_path}" >/dev/null 2>&1 && exit 0
fi

if command -v paplay >/dev/null 2>&1; then
  paplay "${sound_path}" && exit 0
fi

if command -v aplay >/dev/null 2>&1; then
  aplay "${sound_path}" && exit 0
fi

printf '\a'
exit 0
