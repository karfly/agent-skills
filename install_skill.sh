#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <skill-name>" >&2
  exit 1
fi

skill_name="$1"
source_dir="$(cd "$(dirname "$0")" && pwd)/${skill_name}"

target_root="$HOME/.codex/skills"
target_dir="${target_root}/${skill_name}"

if [[ ! -d "${source_dir}" ]]; then
  echo "Error: skill directory not found: ${source_dir}" >&2
  exit 1
fi

mkdir -p "${target_root}"
rm -rf "${target_dir}"
cp -R "${source_dir}" "${target_dir}"

echo "Installed ${skill_name} to ${target_dir}"
