# Technology Stack

**Analysis Date:** 2026-03-25

## Languages

**Primary:**
- Zsh - Main shell, interactive shell config (`zshrc`, `zshenv`, `zsh/*.zsh`)
- Emacs Lisp - Emacs configuration via Org Mode literate programming (`emacs.d/config.org`, `emacs.d/init.el`)
- VimScript - Vim/Neovim configuration (`vim/vimrc`, `vim/init.vim`, `vim/plugin/*.vim`)

**Secondary:**
- Bash/Shell - Utility scripts, yabai helper scripts (`scripts/yabai/*.sh`, `config/yabai/yabairc`)
- YAML - Ansible playbook (`dotfiles.yml`)
- TOML - Alacritty configuration (`config/alacritty/alacritty.toml`)
- JSON/JSONC - CoC, Karabiner, OpenCode configs (`config/karabiner/karabiner.json`, `config/opencode/opencode.jsonc`)

## Runtime

**Environment:**
- macOS (Darwin) - Primary and only supported OS
- Supports both Intel (`x86_64`) and Apple Silicon (`arm64`) architectures
- Homebrew installed at `/opt/homebrew` (Apple Silicon) or `/usr/local` (Intel)

**Shell:**
- Zsh - Default shell (enforced via `chsh -s /bin/zsh` in Ansible playbook)
- Emacs bindings mode (`bindkey -e` in `zshrc`)

## Configuration Management

**Primary Tool:** rcm (RCM - RC file management)
- Config: `rcrc`
- Excludes from symlinking: `*.md *.png *.jpg install.sh dotfiles.yml dotfiles.yaml tags* sample*`
- Installed via Homebrew, deployed via `rcup` command
- Symlinks dotfiles from this repo to `$HOME`

**Provisioning:** Ansible
- Playbook: `dotfiles.yml` (306 lines)
- Runs against `localhost`
- Uses `community.general.homebrew` and `community.general.homebrew_cask` modules
- Variables file: `vars/custom.yml` (gitignored — likely contains personal/secret values)
- Handles full workstation setup: Homebrew packages, shell config, language runtimes, GUI apps

## Version Control

**Git Submodules** (defined in `.gitmodules`):
- `zsh/zsh-history-substring-search` → `zsh-users/zsh-history-substring-search`
- `zsh/base16-shell` → `abrampers/base16-shell` (personal fork, SSH URL)
- `.vim/pack/bundle/opt/vim-go` → `fatih/vim-go` (legacy, likely unused)
- `.vim/pack/bundle/opt/ferret` → `wincent/ferret` (legacy, likely unused)
- `.vim/pack/bundle/opt/base16-vim` → `chriskempson/base16-vim` (legacy, likely unused)

**Note:** The `.vim/pack/bundle/opt/*` submodules appear to be legacy from before the switch to vim-plug. Active Vim plugins are managed via vim-plug.

## Package Managers

### Vim Plugin Manager: vim-plug
- Config: `vim/vimrc` lines 52-114 (also mirrored in `vim/init.vim`)
- Plugin directory: `~/.vim/plugged`
- 50+ plugins declared via `Plug` directives
- Auto-installed via curl in Ansible playbook for Neovim

### Emacs Package Manager: straight.el + use-package
- Config: `emacs.d/config.org` (bootstraps straight.el from GitHub)
- Version lockfile: `emacs.d/straight/versions/default.el`
- Uses `use-package` macro for declarative package configuration
- Default protocol: SSH (`straight-vc-git-default-protocol 'ssh`)
- 70+ packages declared via `use-package`

### Tmux Plugin Manager: Manual (no TPM)
- Tmux plugins are vendored directly into `tmux/` directory
- `tmux/nord-tmux/` - Nord color theme
- `tmux/tmux-prefix-highlight/` - Prefix highlight indicator
- Loaded via `run-shell` in `tmux.conf`

### Zsh Plugin Manager: Manual sourcing
- No formal plugin manager (no oh-my-zsh, no zinit, no antigen)
- Plugins live in `zsh/` directory and are sourced directly in `zshrc`:
  - `zsh/zsh-autosuggestions/` — autosuggestions
  - `zsh/zsh-syntax-highlighting/` — syntax highlighting
  - `zsh/zsh-history-substring-search/` — history search (git submodule)
  - `zsh/plugin-osx/` — macOS aliases and utilities
  - `zsh/brew-zsh-plugin/` — Homebrew helpers
  - `zsh/git-aliases/` — comprehensive git alias set
  - `zsh/base16-shell/` — terminal color scheme management (git submodule)

### System Package Manager: Homebrew
- All system dependencies installed via Homebrew (managed through Ansible)
- Homebrew taps:
  - `d12frosted/emacs-plus` — enhanced Emacs build
  - `clojure-lsp/brew` — Clojure LSP
  - `koekeishiya/formulae` — yabai tiling window manager

## Language Version Managers

**Python:** pyenv + pyenv-virtualenv
- `PYENV_ROOT="$HOME/.pyenv"` (`zsh/exports.zsh`)
- Target version: Python 3.12.7 (set via `pyenv global 3.12` in `dotfiles.yml`)
- Initialized in `zshrc` via `eval "$(pyenv init -)"` and `eval "$(pyenv virtualenv-init -)"`

**Ruby:** rbenv
- Initialized in `zshrc` via `eval "$(rbenv init - zsh)"`
- Path: `$HOME/.rbenv/bin` and `$HOME/.rbenv/shims`
- Ruby 2.7.1 referenced for neovim-ruby-host in `vim/vimrc`

**Node.js:** nvm (Node Version Manager)
- `NVM_DIR="$HOME/.nvm"` (`zsh/exports.zsh`)
- Loaded from Homebrew-installed nvm in `zshrc`

**Java:** Manual via `/usr/libexec/java_home`
- `jdk` function in `zsh/functions.zsh` for switching Java versions
- JDK 8 (Temurin) installed via Homebrew cask
- Default set to JDK 1.8 in `zshrc` (`jdk 1.8 true`)

**Go:** gvm (Go Version Manager)
- Sourced conditionally: `[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"` in `zshrc`
- Also installed directly via Homebrew

## Editors

**Primary: Emacs** (emacs-plus@30)
- Installed from `d12frosted/emacs-plus` tap with modern purple flat icon
- Literate configuration via Org Mode (`emacs.d/config.org` → 2168 lines)
- Evil mode (Vi emulation) enabled
- LSP support via `lsp-mode` v9.0.0
- GitHub Copilot integration via `copilot.el`
- Languages configured: Go, Ruby, Clojure, C/C++, Python, TypeScript, Lua, Erlang, Protobuf, Groovy, Jsonnet
- Theme: Nord

**Secondary: Neovim**
- Installed via Homebrew
- Config: `config/nvim/init.vim` (delegates to `vim/vimrc`)
- Plugin manager: vim-plug
- CoC (Conquer of Completion) for LSP: `neoclide/coc.nvim`
- CoC extensions: `coc-marketplace`, `coc-solargraph` (Ruby), `coc-vimlsp`
- ALE for linting: `dense-analysis/ale`
- Theme: Nord (via nord-vim) or Gruvbox

**Tertiary: IdeaVim** (JetBrains IDEs)
- Config: `ideavimrc`
- Plugins emulated: surround, commentary, argtextobj, textobj-entire

## Key Dependencies

**Critical CLI Tools (installed via Homebrew in Ansible):**
- `fzf` — fuzzy finder (integrated with both Zsh and Vim)
- `ripgrep` (`rg`) — fast search (used as FZF default command)
- `bat` — cat replacement with syntax highlighting (aliased as `cat` in `zsh/aliases.zsh`)
- `tmux` — terminal multiplexer
- `tig` — text-mode git interface
- `jq` — JSON processor (used heavily in yabai/skhd scripts)
- `grpcurl` — gRPC client
- `cmake` — build system
- `rcm` — dotfile management

**Window Management Stack (macOS):**
- `yabai` — tiling window manager (`config/yabai/yabairc`)
- `skhd` — simple hotkey daemon (`config/skhd/skhdrc`)
- `limelight` — window border highlighting (`config/limelight/limelightrc`)
- `karabiner-elements` — keyboard customizer (`config/karabiner/karabiner.json`)

**Terminal:**
- Alacritty — GPU-accelerated terminal (`config/alacritty/alacritty.toml`)
- Font: "Source Code Pro for Powerline" (Alacritty), "SauceCodePro Nerd Font Mono" (Emacs)

**Browser Extension:**
- Tridactyl — Vim-like Firefox extension (`config/tridactyl/tridactylrc`)

**AI Coding Tools:**
- OpenCode — AI coding CLI (`config/opencode/opencode.jsonc`)
  - Configured with Google provider (Gemini 3 Pro/Flash, Claude Sonnet 4.6, Claude Opus 4.5)
  - Theme: Nord
- GitHub Copilot — integrated in Emacs via `copilot.el`

## Configuration

**Environment Variables** (defined in `zsh/exports.zsh`):
- `EDITOR=nvim`
- `KUBE_EDITOR=nvim`
- `LANG=en_US.UTF-8`
- `FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"`
- `FZF_DEFAULT_OPTS="--layout=reverse --inline-info"`
- `GPG_TTY=$(tty)`
- `NVM_DIR="$HOME/.nvm"`
- `PYENV_ROOT="$HOME/.pyenv"`

**PATH Construction** (defined in `zsh/path.zsh`):
- `$HOME/bin` (highest priority)
- `$HOME/.zsh/bin`
- `$HOME/.vim/pack/bundle/opt/vcs-jump/bin`
- `$HOME/.fzf/bin`
- `/usr/local/bin`, `/usr/local/sbin`
- System PATH
- `$HOME/.local/bin`
- `$HOME/.rbenv/shims`
- `$PYENV_ROOT/shims`

**Build/Deploy:**
- No CI/CD pipeline — this is a personal dotfiles repo
- Deployment is manual: `ansible-playbook dotfiles.yml` then `rcup`

## Platform Requirements

**Development:**
- macOS (Darwin) required — many configs are macOS-specific
- Homebrew must be installed (or set `install_homebrew_if_missing: true` in Ansible vars)
- Xcode Command Line Tools (implicit dependency for Homebrew)

**Fonts Required:**
- Source Code Pro for Powerline (installed via Homebrew cask: `font-source-code-pro-for-powerline`)
- SauceCodePro Nerd Font Mono (installed via Homebrew cask: `font-sauce-code-pro-nerd-font`)
- Monego Nerd Font Fix (referenced in Emacs Org mode heading config)

---

*Stack analysis: 2026-03-25*
