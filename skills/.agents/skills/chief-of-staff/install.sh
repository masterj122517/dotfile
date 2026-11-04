#!/usr/bin/env bash
set -euo pipefail

# User-level installation. One canonical copy; compatibility paths are symlinks.
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CANONICAL="$HOME/.agents/skills/chief-of-staff"
mkdir -p "$HOME/.agents/skills"

if [[ "$SOURCE_DIR" != "$CANONICAL" ]]; then
  if [[ -e "$CANONICAL" || -L "$CANONICAL" ]]; then
    BACKUP="$CANONICAL.backup.$(date +%Y%m%d-%H%M%S)"
    mv "$CANONICAL" "$BACKUP"
    printf 'Backed up existing installation: %s\n' "$BACKUP"
  fi
  mkdir -p "$CANONICAL"
  cp "$SOURCE_DIR/SKILL.md" "$CANONICAL/SKILL.md"
  [[ ! -f "$SOURCE_DIR/README.md" ]] || cp "$SOURCE_DIR/README.md" "$CANONICAL/README.md"
  if [[ -d "$SOURCE_DIR/references" ]]; then cp -R "$SOURCE_DIR/references" "$CANONICAL/"; fi
  if [[ -d "$SOURCE_DIR/pi-prompts" ]]; then cp -R "$SOURCE_DIR/pi-prompts" "$CANONICAL/"; fi
fi

# These tools may already read ~/.agents/skills natively; explicit links help Claude and Copilot.
for path in "$HOME/.claude/skills/chief-of-staff" "$HOME/.copilot/skills/chief-of-staff"; do
  mkdir -p "$(dirname "$path")"
  if [[ -L "$path" ]]; then
    if [[ "$(readlink "$path")" == "$CANONICAL" ]]; then
      printf 'Already linked: %s\n' "$path"
      continue
    fi
    echo "Skipped existing symlink: $path"
  elif [[ -e "$path" ]]; then
    echo "Skipped existing directory: $path"
  else
    ln -s "$CANONICAL" "$path"
    printf 'Linked: %s\n' "$path"
  fi
done

# Pi prompt templates expose concise slash commands. Never overwrite user custom prompts.
PI_PROMPTS="$HOME/.pi/agent/prompts"
mkdir -p "$PI_PROMPTS"
if [[ -d "$SOURCE_DIR/pi-prompts" ]]; then
  for src in "$SOURCE_DIR"/pi-prompts/*.md; do
    [[ -f "$src" ]] || continue
    dst="$PI_PROMPTS/$(basename "$src")"
    if [[ -e "$dst" || -L "$dst" ]]; then
      if [[ -L "$dst" && "$(readlink "$dst")" == "$CANONICAL/pi-prompts/$(basename "$src")" ]]; then
        continue
      fi
      echo "Skipped existing Pi command: $dst"
    else
      ln -s "$CANONICAL/pi-prompts/$(basename "$src")" "$dst"
      printf 'Added Pi command: /%s\n' "$(basename "$src" .md)"
    fi
  done
fi

printf '\nInstalled: %s\n' "$CANONICAL"
printf 'Restart or refresh your agent sessions to discover the skill.\n'
printf 'Notion connectivity must be configured separately for each agent.\n'
