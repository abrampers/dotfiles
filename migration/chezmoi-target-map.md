# Chezmoi target mapping contract

This report derives the approved Phase 2 import set from `~/.local/state/dotfiles-migration/rcm-managed-files.txt` after removing the explicit local-only denylist, intentional parity exceptions, and Phase 2 repo-only migration artifacts.

## Mapped targets

### Root dotfiles
- `/Users/abram.perdanaputra/.ideavimrc`
- `/Users/abram.perdanaputra/.rcrc`
- `/Users/abram.perdanaputra/.tigrc`
- `/Users/abram.perdanaputra/.tmux.conf`
- `/Users/abram.perdanaputra/.zshenv`
- `/Users/abram.perdanaputra/.zshrc`

### Tool directories
- `.emacs.d` (4 targets)
  - `/Users/abram.perdanaputra/.emacs.d/config.org`
  - `/Users/abram.perdanaputra/.emacs.d/init.el`
  - `/Users/abram.perdanaputra/.emacs.d/straight/versions/default.el`
  - `/Users/abram.perdanaputra/.emacs.d/themes/vivid-chalk-theme.el`
- `.scripts/yabai` (5 targets)
  - `/Users/abram.perdanaputra/.scripts/yabai/moveWindowLeftAndFollowFocus.sh`
  - `/Users/abram.perdanaputra/.scripts/yabai/moveWindowRightAndFollowFocus.sh`
  - `/Users/abram.perdanaputra/.scripts/yabai/switchAndFocusSIP.sh`
  - `/Users/abram.perdanaputra/.scripts/yabai/toggleStackLayout.sh`
  - `/Users/abram.perdanaputra/.scripts/yabai/windowFocusOnDestroy.sh`
- `.tmux` (5 targets)
  - `/Users/abram.perdanaputra/.tmux/nord-tmux/nord.tmux`
  - `/Users/abram.perdanaputra/.tmux/nord-tmux/src/nord-status-content-no-patched-font.conf`
  - `/Users/abram.perdanaputra/.tmux/nord-tmux/src/nord-status-content.conf`
  - `/Users/abram.perdanaputra/.tmux/nord-tmux/src/nord.conf`
  - `/Users/abram.perdanaputra/.tmux/tmux-prefix-highlight/prefix_highlight.tmux`
- `.vim` (98 targets)
  - `/Users/abram.perdanaputra/.vim/after/compiler/eslint.vim`
  - `/Users/abram.perdanaputra/.vim/after/compiler/jest.vim`
  - `/Users/abram.perdanaputra/.vim/after/compiler/tsc.vim`
  - `/Users/abram.perdanaputra/.vim/after/ftplugin/mail.vim`
  - `/Users/abram.perdanaputra/.vim/after/ftplugin/vim.vim`
  - `...` (93 more; see `migration/chezmoi-import-targets.txt`)
- `.zsh` (190 targets)
  - `/Users/abram.perdanaputra/.zsh/aliases.zsh`
  - `/Users/abram.perdanaputra/.zsh/bin/diff-highlight`
  - `/Users/abram.perdanaputra/.zsh/brew-zsh-plugin/LICENSE`
  - `/Users/abram.perdanaputra/.zsh/brew-zsh-plugin/brew.plugin.zsh`
  - `/Users/abram.perdanaputra/.zsh/colors.zsh`
  - `...` (185 more; see `migration/chezmoi-import-targets.txt`)

### XDG-managed paths
- `.config/alacritty` (1 targets)
  - `/Users/abram.perdanaputra/.config/alacritty/alacritty.toml`
- `.config/bat` (1 targets)
  - `/Users/abram.perdanaputra/.config/bat/config`
- `.config/coc` (19 targets)
  - `/Users/abram.perdanaputra/.config/coc/extensions/db.json`
  - `/Users/abram.perdanaputra/.config/coc/extensions/node_modules/coc-marketplace/LICENSE`
  - `/Users/abram.perdanaputra/.config/coc/extensions/node_modules/coc-marketplace/lib/index.js`
  - `/Users/abram.perdanaputra/.config/coc/extensions/node_modules/coc-marketplace/package.json`
  - `/Users/abram.perdanaputra/.config/coc/extensions/node_modules/coc-vimlsp/out/index.js`
  - `...` (14 more; see `migration/chezmoi-import-targets.txt`)
- `.config/karabiner` (1 targets)
  - `/Users/abram.perdanaputra/.config/karabiner/karabiner.json`
- `.config/limelight` (1 targets)
  - `/Users/abram.perdanaputra/.config/limelight/limelightrc`
- `.config/nvim` (1 targets)
  - `/Users/abram.perdanaputra/.config/nvim/init.vim`
- `.config/opencode` (3 targets)
  - `/Users/abram.perdanaputra/.config/opencode/opencode.jsonc`
  - `/Users/abram.perdanaputra/.config/opencode/package.json`
  - `/Users/abram.perdanaputra/.config/opencode/tui.json`
- `.config/skhd` (1 targets)
  - `/Users/abram.perdanaputra/.config/skhd/skhdrc`
- `.config/tridactyl` (1 targets)
  - `/Users/abram.perdanaputra/.config/tridactyl/tridactylrc`
- `.config/yabai` (1 targets)
  - `/Users/abram.perdanaputra/.config/yabai/yabairc`

## Exclusions carried from rcrc
- `*.md`
- `*.png`
- `*.jpg`
- `install.sh`
- `dotfiles.yml`
- `dotfiles.yaml`
- `tags*`
- `sample*`
- `ansible`
- `ansible/**`

## Local-only denylist
- `.zshrc.local`
- `.zsh/host/**`
- `.vim/vimrc.local`
- `.tmux-local.conf`
- `.emacs.d/private-init.el`
- `.vim/plugin/local-settings.vim`

## Intentional exceptions
- `.zsh/.zsh` — legacy rcm artifact if present in baseline
- `.emacs.d/sample.private-init.el` — sample template should stay repo-only if baseline captured it

## Phase-3 handoff notes
- Use `migration/chezmoi-import-targets.txt` as the exact import contract for later Phase 2 import tasks.
- Split root/tool imports from XDG imports by the groups above instead of rediscovering targets from the repo tree.
- Preserve the denylist and exception artifacts as review gates when preview and parity checks are wired later in Phase 2 and Phase 3.
