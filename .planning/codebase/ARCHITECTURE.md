# Architecture

**Analysis Date:** 2026-03-25

## Pattern Overview

**Overall:** Tool-centric dotfiles repository managed by rcm (RC file management) with Ansible-based provisioning

**Key Characteristics:**
- Files are organized by tool (zsh, vim, tmux, emacs) at the top level
- XDG-compatible configs live under `config/` (maps to `~/.config/`)
- rcm handles symlinking from repo to home directory, prepending `.` to file/directory names
- Ansible playbook (`dotfiles.yml`) automates full workstation setup including Homebrew packages, shell configuration, and rcm deployment
- Modular zsh configuration with dedicated files for aliases, exports, path, colors, functions, and plugins
- Vim configuration uses a layered architecture: `vimrc` → `plugin/` → `after/plugin/` with autoload functions
- Neovim delegates entirely to the Vim configuration via `config/nvim/init.vim`

## Layers

**Provisioning Layer (Ansible):**
- Purpose: Automate full workstation setup from scratch
- Location: `dotfiles.yml`
- Contains: Homebrew package installation, shell setup, rcm deployment
- Depends on: Homebrew, Ansible
- Used by: Initial setup or full reprovisioning

**Symlink Management Layer (rcm):**
- Purpose: Map repository files to home directory locations as symlinks
- Location: `rcrc` (configuration for rcm)
- Contains: Exclusion patterns for non-deployable files
- Depends on: rcm (`rcup` command)
- Used by: All tools that read configs from home directory

**Shell Layer (zsh):**
- Purpose: Interactive shell configuration
- Location: `zshenv`, `zshrc`, `zsh/`
- Contains: Environment variables, PATH, aliases, functions, plugins, prompt, hooks
- Depends on: Homebrew, fzf, pyenv, rbenv, nvm, base16-shell
- Used by: All terminal sessions

**Editor Layer (Vim/Neovim):**
- Purpose: Text editor configuration
- Location: `vim/`, `config/nvim/`
- Contains: Plugin management (vim-plug), settings, mappings, filetype configs, autoload functions
- Depends on: vim-plug, CoC (Conquer of Completion), pyenv, rbenv
- Used by: Vim and Neovim (shared configuration)

**Editor Layer (Emacs):**
- Purpose: Emacs configuration using literate programming
- Location: `emacs.d/`
- Contains: Literate Org-mode config, straight.el package management, custom themes
- Depends on: straight.el, use-package
- Used by: Emacs

**Terminal Multiplexer Layer (tmux):**
- Purpose: Terminal multiplexer configuration and plugins
- Location: `tmux.conf`, `tmux/`
- Contains: Key bindings, appearance settings, plugin references
- Depends on: nord-tmux theme, tmux-prefix-highlight plugin
- Used by: tmux sessions

**Window Management Layer (yabai/skhd):**
- Purpose: Tiling window manager and hotkey daemon for macOS
- Location: `config/yabai/`, `config/skhd/`, `config/limelight/`, `scripts/yabai/`
- Contains: Layout rules, app exclusions, keyboard shortcuts, helper scripts
- Depends on: yabai, skhd, limelight, jq
- Used by: macOS desktop environment

**XDG Config Layer:**
- Purpose: Application configs that follow XDG Base Directory spec
- Location: `config/` (maps to `~/.config/`)
- Contains: alacritty, bat, coc, karabiner, nvim, opencode, skhd, tridactyl, yabai, limelight
- Depends on: Individual applications
- Used by: rcm (deployed to `~/.config/`)

## Data Flow

**Shell Initialization Flow (zsh):**

1. Login shell starts → `~/.zshenv` sourced (always, for all shell types)
2. `zshenv` sources `~/.zsh/exports.zsh` (EDITOR, PYENV_ROOT, FZF opts, etc.)
3. `zshenv` sources `~/.zsh/path.zsh` (rebuilds PATH from scratch)
4. Interactive shell starts → `~/.zshrc` sourced
5. `zshrc` sets up global variables (`__ABRAMPERS` hash table)
6. macOS-specific hacks (suppress Homebrew zsh completions, key repeat rate)
7. Homebrew shell environment initialized (`brew shellenv`)
8. Completion system initialized (`compinit`)
9. Prompt configured (vcs_info for git/hg, PS1/RPROMPT)
10. History settings applied (100K history, shared across shells)
11. Shell options set (AUTO_CD, SHARE_HISTORY, MENU_COMPLETE, etc.)
12. Plugins sourced: zsh-autosuggestions → zsh-syntax-highlighting → zsh-history-substring-search → plugin-osx → brew plugin → git-aliases
13. Key bindings set (emacs mode, history search, fzf)
14. Hooks registered (window title, command timing, auto-ls, vcs_info refresh)
15. Custom aliases, colors, functions sourced from `~/.zsh/`
16. Local overrides: `~/.zshrc.local` and `~/.zsh/host/$(hostname -s)` sourced if they exist
17. Third-party tool initialization: JDK, nvm, rbenv, fzf, pyenv, gvm

**Vim/Neovim Initialization Flow:**

1. Neovim starts → loads `~/.config/nvim/init.vim`
2. `init.vim` prepends `~/.vim` to runtimepath and sources `~/.vim/vimrc`
3. `vimrc` sets leader keys (Space / Comma)
4. `vimrc` configures Neovim-specific host programs (python3, ruby)
5. `vimrc` sets plugin variables (NERDTree, markdown, Loupe)
6. `vimrc` sources `~/.vim/vimrc.local` if it exists
7. vim-plug loads all plugins from `~/.vim/plugged/`
8. `vim/plugin/*.vim` files auto-sourced (settings, mappings, fzf, airline, git, etc.)
9. `vim/plugin/mappings/*.vim` files auto-sourced (leader, normal, visual, coc, command, omnifunc)
10. Plugin code evaluated
11. `vim/after/plugin/*.vim` files sourced (color scheme, plugin overrides)
12. Color scheme loaded based on `~/.vim/.base16` config file (synced with shell base16)

**Emacs Initialization Flow:**

1. Emacs starts → loads `~/.emacs.d/init.el`
2. `init.el` sets `vc-follow-symlinks` to handle rcm symlinks
3. `init.el` calls `org-babel-load-file` on `config.org`
4. Org-mode tangles `config.org` into elisp and evaluates it
5. straight.el bootstrapped for package management
6. use-package configured with straight.el integration
7. Private variables loaded from `~/.emacs.d/private-init.el` if it exists
8. Full configuration applied (2168 lines of literate config)

**Color Scheme Synchronization:**

1. `color` shell function (in `zsh/colors.zsh`) sets base16 color scheme
2. Writes scheme name + dark/light to `~/.vim/.base16`
3. Shell runs base16-shell script to apply terminal colors
4. Vim's `after/plugin/color.vim` reads `~/.vim/.base16` on FocusGained
5. Vim applies matching colorscheme (base16-*, nord, or gruvbox)
6. tmux colors updated if inside tmux session

**State Management:**
- Color scheme state: `~/.vim/.base16` file (shared between zsh and vim)
- Shell history: `~/.history` (shared across shells via SHARE_HISTORY)
- Vim undo history: `~/.vim/tmp/undo/`
- Vim swap files: `~/.vim/tmp/swap/`
- Vim backups: `~/.vim/tmp/backup/`
- Emacs state: `~/.emacs.d/straight/` (packages), `~/.emacs.d/var/` (runtime state)

## Key Abstractions

**rcm Symlink Mapping:**
- Purpose: Maps repo files to home directory with `.` prefix
- Pattern: `{repo}/foo` → `~/.foo`, `{repo}/config/bar/baz` → `~/.config/bar/baz`
- Examples: `rcrc` → `~/.rcrc`, `zshrc` → `~/.zshrc`, `vim/` → `~/.vim/`
- Exclusions defined in `rcrc`: `*.md *.png *.jpg install.sh dotfiles.yml dotfiles.yaml tags* sample*`

**Zsh Module System:**
- Purpose: Split shell configuration into focused, single-responsibility files
- Examples: `zsh/aliases.zsh`, `zsh/exports.zsh`, `zsh/path.zsh`, `zsh/colors.zsh`, `zsh/functions.zsh`
- Pattern: Each file sourced explicitly from `zshenv` or `zshrc`

**Vim Plugin Architecture:**
- Purpose: Separate Vim configuration by concern using Vim's native directory structure
- Examples: `vim/plugin/settings.vim`, `vim/plugin/mappings/leader.vim`, `vim/after/plugin/color.vim`
- Pattern: `plugin/` for pre-plugin config, `after/plugin/` for post-plugin overrides

**Vim Autoload Namespace:**
- Purpose: Lazy-loaded utility functions under `wincent#` namespace
- Examples: `vim/autoload/wincent/settings.vim`, `vim/autoload/wincent/autocmds.vim`, `vim/autoload/wincent/mappings/`
- Pattern: Functions called as `wincent#module#function()`, only loaded when first invoked

**Zsh Plugin Bundling:**
- Purpose: Third-party zsh plugins included as subdirectories (git submodules or vendored)
- Examples: `zsh/zsh-autosuggestions/`, `zsh/zsh-history-substring-search/`, `zsh/git-aliases/`
- Pattern: Sourced directly from `zshrc` via `source $HOME/.zsh/{plugin}/{main-file}.zsh`

## Entry Points

**Shell Session:**
- Location: `zshenv` → `zshrc`
- Triggers: Opening a terminal, SSH session, tmux pane
- Responsibilities: Set up complete shell environment with PATH, aliases, functions, plugins, prompt

**Vim/Neovim:**
- Location: `config/nvim/init.vim` → `vim/vimrc`
- Triggers: Running `nvim` or `vim`
- Responsibilities: Load all editor configuration, plugins, mappings, and appearance

**Emacs:**
- Location: `emacs.d/init.el` → `emacs.d/config.org`
- Triggers: Running `emacs`
- Responsibilities: Bootstrap straight.el, tangle org config, load full configuration

**tmux:**
- Location: `tmux.conf`
- Triggers: Starting tmux
- Responsibilities: Set prefix, bindings, appearance, plugins; source `~/.tmux-local.conf` for overrides

**Window Manager:**
- Location: `config/yabai/yabairc`
- Triggers: yabai service start
- Responsibilities: Configure tiling layout, app rules, limelight integration

**Hotkey Daemon:**
- Location: `config/skhd/skhdrc`
- Triggers: skhd service start
- Responsibilities: Map keyboard shortcuts to yabai commands and app launchers

**Provisioning:**
- Location: `dotfiles.yml`
- Triggers: Manual run via `ansible-playbook dotfiles.yml`
- Responsibilities: Install all tools, set default shell, deploy dotfiles via rcm

## Error Handling

**Strategy:** Graceful degradation with existence checks

**Patterns:**
- Shell: `test -f $FILE && source $FILE` for optional local overrides (`~/.zshrc.local`, `~/.zsh/host/$(hostname -s)`)
- Shell: `command -v tool &> /dev/null` before using optional tools (`dry`, `pyenv`, etc.)
- Vim: `if filereadable(s:vimrc_local)` before sourcing local vim config
- Vim: `if has('feature')` / `if exists('option')` guards for feature-dependent settings
- Vim: `if v:progname == 'vi'` disables plugins when invoked as plain `vi`
- tmux: `source-file -q ~/.tmux-local.conf` (quiet flag suppresses error if missing)
- Emacs: `(when (file-exists-p private-init-file) (load-file private-init-file))`
- Emacs: `vc-follow-symlinks` set to handle rcm symlinks transparently

## Cross-Cutting Concerns

**Color Scheme Management:**
- Base16 color scheme system shared between terminal (zsh), editor (vim), and multiplexer (tmux)
- `zsh/colors.zsh` provides the `color` function to switch schemes
- State persisted in `~/.vim/.base16`, read by both zsh and vim
- Supports dark/light detection via luma calculation
- base16-shell scripts in `zsh/base16-shell/` apply terminal escape sequences

**Local/Host Overrides:**
- zsh: `~/.zshrc.local` for machine-specific shell config
- zsh: `~/.zsh/host/$(hostname -s)` for host-specific config
- vim: `~/.vim/vimrc.local` for machine-specific vim config (gitignored)
- vim: `vim/plugin/local-settings.vim` for checked-in but environment-specific settings (gitignored by `vim/.gitignore`)
- tmux: `~/.tmux-local.conf` for machine-specific tmux config
- emacs: `~/.emacs.d/private-init.el` for private variables (sample provided)

**macOS-Specific Design:**
- Entire repo assumes macOS (Homebrew, `defaults write`, Karabiner, yabai/skhd)
- Ansible playbook handles Intel vs Apple Silicon architecture differences
- Helper scripts in `scripts/` for macOS Automator apps (VPN, TOTP)
- Karabiner config maps function keys to custom scripts

**Font Configuration:**
- Source Code Pro for Powerline configured in Alacritty (`config/alacritty/alacritty.toml`)
- Powerline symbols enabled in vim-airline (`vim/plugin/airline.vim`)
- Fonts installed via Homebrew casks in Ansible playbook

---

*Architecture analysis: 2026-03-25*
