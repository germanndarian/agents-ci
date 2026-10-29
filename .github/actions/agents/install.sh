#!/bin/bash
# Copies the agents into ~/.claude/agents for Claude Code on a CI runner.
# GitHub downloads this whole repo to run this action, so agents/ sits three folders up.
#
# Left out on purpose:
# - legal.md: the legal agent only ever runs when I ask for it, never in CI.
# - github.md: the GitHub agent belongs to my Mac's approval gate.
# - the frontmatter hooks: they point at my Mac's gate and dashboard. In CI the workflow's
#   tool permissions are the guard instead (read tools only).
set -euo pipefail

agents="$(cd "$(dirname "$0")/../../../agents" && pwd)"
target="$HOME/.claude/agents"
mkdir -p "$target"

for file in "$agents"/*.md; do
  name="$(basename "$file")"
  case "$name" in legal.md|github.md) continue ;; esac
  # Drops the top-level `hooks:` block from the frontmatter, keeping everything else.
  awk '
    /^---$/ { fences++; skipping = 0; print; next }
    fences == 1 && /^hooks:/ { skipping = 1; next }
    fences == 1 && skipping && /^[^ ]/ { skipping = 0 }
    !skipping { print }
  ' "$file" >"$target/$name"
  echo "Installed $name"
done
