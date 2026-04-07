# Chezmoi workstation stability checks

These checks define the minimum before/after workstation evidence for the first real `chezmoi apply`.

## shell and dotfiles

- `zsh -lc 'printf "%s\n" "$SHELL"; test -f "$HOME/.zshrc"; test -f "$HOME/.zshenv"; command -v chezmoi; chezmoi -S "$REPO_ROOT" source-path "$HOME/.zshrc"'`

## editors

- `vim --version`
- `nvim --version`
- `emacs --version`

## tmux

- `tmux -V`
- `test -f "$HOME/.tmux.conf"`

## window-manager tooling

- `yabai --version`
- `skhd --version`
- `jq --version`

## XDG app configs

- `test -f "$HOME/.config/alacritty/alacritty.toml"`
- `test -f "$HOME/.config/nvim/init.vim"`
- `test -f "$HOME/.config/yabai/yabairc"`
- `test -f "$HOME/.config/skhd/skhdrc"`

## language toolchains

- `python3 --version`
- `node --version`
- `go version`
- `ruby --version`
