#!/bin/bash

set -euo pipefail

if [ "$#" -ne 2 ]; then
  printf 'usage: %s <before|after> <output_file>\n' "$0" >&2
  exit 64
fi

PHASE="$1"
OUTPUT_FILE="$2"
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname "$0")" && pwd)"
REPO_ROOT="$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)"

export REPO_ROOT

case "$PHASE" in
  before|after) ;;
  *)
    printf 'phase must be before or after\n' >&2
    exit 64
    ;;
esac

mkdir -p "$(dirname "$OUTPUT_FILE")"

FAILURES=0

write_heading() {
  printf '%s\n\n' "$1" >> "$OUTPUT_FILE"
}

run_check() {
  local LABEL="$1"
  local COMMAND="$2"

  printf '### %s\n\n' "$LABEL" >> "$OUTPUT_FILE"
  printf '```text\n$ %s\n' "$COMMAND" >> "$OUTPUT_FILE"

  if bash -lc "$COMMAND" >> "$OUTPUT_FILE" 2>&1; then
    printf '\n[exit 0]\n```\n\n' >> "$OUTPUT_FILE"
  else
    local STATUS=$?
    FAILURES=$((FAILURES + 1))
    printf '\n[exit %s]\n```\n\n' "$STATUS" >> "$OUTPUT_FILE"
  fi
}

printf '# Workstation smoke checks (%s)\n\n' "$PHASE" > "$OUTPUT_FILE"
printf -- '- Captured at: %s\n' "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" >> "$OUTPUT_FILE"
printf -- '- Host: %s\n\n' "$(hostname -s)" >> "$OUTPUT_FILE"

write_heading '## shell and dotfiles'
run_check 'login shell and chezmoi source path' 'zsh -lc '\''printf "%s\n" "$SHELL"; test -f "$HOME/.zshrc"; test -f "$HOME/.zshenv"; command -v chezmoi; chezmoi -S "$REPO_ROOT" source-path "$HOME/.zshrc"'\'''

write_heading '## editors'
run_check 'vim version' 'vim --version'
run_check 'nvim version' 'nvim --version'
run_check 'emacs version' 'emacs --version'

write_heading '## tmux'
run_check 'tmux version' 'tmux -V'
run_check 'tmux config present' 'test -f "$HOME/.tmux.conf" && printf "%s\n" "$HOME/.tmux.conf"'

write_heading '## window-manager tooling'
run_check 'yabai version' 'yabai --version'
run_check 'skhd version' 'skhd --version'
run_check 'jq version' 'jq --version'

write_heading '## XDG app configs'
run_check 'alacritty config present' 'test -f "$HOME/.config/alacritty/alacritty.toml" && printf "%s\n" "$HOME/.config/alacritty/alacritty.toml"'
run_check 'nvim config present' 'test -f "$HOME/.config/nvim/init.vim" && printf "%s\n" "$HOME/.config/nvim/init.vim"'
run_check 'yabai config present' 'test -f "$HOME/.config/yabai/yabairc" && printf "%s\n" "$HOME/.config/yabai/yabairc"'
run_check 'skhd config present' 'test -f "$HOME/.config/skhd/skhdrc" && printf "%s\n" "$HOME/.config/skhd/skhdrc"'

write_heading '## language toolchains'
run_check 'python version' 'python3 --version'
run_check 'node version' 'node --version'
run_check 'go version' 'go version'
run_check 'ruby version' 'ruby --version'

if [ "$FAILURES" -eq 0 ]; then
  printf -- '- Result: passed\n' >> "$OUTPUT_FILE"
else
  printf -- '- Result: failed (%s checks)\n' "$FAILURES" >> "$OUTPUT_FILE"
fi

exit "$FAILURES"
