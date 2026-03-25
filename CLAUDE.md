<!-- GSD:project-start source:PROJECT.md -->
## Project

**Emacs Next.js/TypeScript LSP Setup**

Fix and configure Emacs for proper Next.js editing with working LSP support for .ts and .tsx files. The goal is to have the same code navigation experience (go-to-definition, find-references, etc.) that already works for Go, but for TypeScript/TSX — and to add format-on-save.

**Core Value:** LSP code navigation (gd, gi, gr, gy, ,r) works reliably in .ts and .tsx files inside a Next.js project, matching the Go editing experience.

### Constraints

- **Package manager**: Must use straight.el + use-package (existing system)
- **Config format**: Changes go into `emacs.d/config.org` (literate Org-mode)
- **Keybinding parity**: Must reuse existing `abram/evil-lsp-keybindings` — no separate TS keybindings
- **Minimal disruption**: Don't break existing Go, Clojure, or other language LSP setups
- **macOS**: Homebrew + nvm environment for installing system dependencies
<!-- GSD:project-end -->

<!-- GSD:stack-start source:codebase/STACK.md -->
## Technology Stack

## Languages
- Zsh - Main shell, interactive shell config (`zshrc`, `zshenv`, `zsh/*.zsh`)
- Emacs Lisp - Emacs configuration via Org Mode literate programming (`emacs.d/config.org`, `emacs.d/init.el`)
- VimScript - Vim/Neovim configuration (`vim/vimrc`, `vim/init.vim`, `vim/plugin/*.vim`)
- Bash/Shell - Utility scripts, yabai helper scripts (`scripts/yabai/*.sh`, `config/yabai/yabairc`)
- YAML - Ansible playbook (`dotfiles.yml`)
- TOML - Alacritty configuration (`config/alacritty/alacritty.toml`)
- JSON/JSONC - CoC, Karabiner, OpenCode configs (`config/karabiner/karabiner.json`, `config/opencode/opencode.jsonc`)
## Runtime
- macOS (Darwin) - Primary and only supported OS
- Supports both Intel (`x86_64`) and Apple Silicon (`arm64`) architectures
- Homebrew installed at `/opt/homebrew` (Apple Silicon) or `/usr/local` (Intel)
- Zsh - Default shell (enforced via `chsh -s /bin/zsh` in Ansible playbook)
- Emacs bindings mode (`bindkey -e` in `zshrc`)
## Configuration Management
- Config: `rcrc`
- Excludes from symlinking: `*.md *.png *.jpg install.sh dotfiles.yml dotfiles.yaml tags* sample*`
- Installed via Homebrew, deployed via `rcup` command
- Symlinks dotfiles from this repo to `$HOME`
- Playbook: `dotfiles.yml` (306 lines)
- Runs against `localhost`
- Uses `community.general.homebrew` and `community.general.homebrew_cask` modules
- Variables file: `vars/custom.yml` (gitignored — likely contains personal/secret values)
- Handles full workstation setup: Homebrew packages, shell config, language runtimes, GUI apps
## Version Control
- `zsh/zsh-history-substring-search` → `zsh-users/zsh-history-substring-search`
- `zsh/base16-shell` → `abrampers/base16-shell` (personal fork, SSH URL)
- `.vim/pack/bundle/opt/vim-go` → `fatih/vim-go` (legacy, likely unused)
- `.vim/pack/bundle/opt/ferret` → `wincent/ferret` (legacy, likely unused)
- `.vim/pack/bundle/opt/base16-vim` → `chriskempson/base16-vim` (legacy, likely unused)
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
### System Package Manager: Homebrew
- All system dependencies installed via Homebrew (managed through Ansible)
- Homebrew taps:
## Language Version Managers
- `PYENV_ROOT="$HOME/.pyenv"` (`zsh/exports.zsh`)
- Target version: Python 3.12.7 (set via `pyenv global 3.12` in `dotfiles.yml`)
- Initialized in `zshrc` via `eval "$(pyenv init -)"` and `eval "$(pyenv virtualenv-init -)"`
- Initialized in `zshrc` via `eval "$(rbenv init - zsh)"`
- Path: `$HOME/.rbenv/bin` and `$HOME/.rbenv/shims`
- Ruby 2.7.1 referenced for neovim-ruby-host in `vim/vimrc`
- `NVM_DIR="$HOME/.nvm"` (`zsh/exports.zsh`)
- Loaded from Homebrew-installed nvm in `zshrc`
- `jdk` function in `zsh/functions.zsh` for switching Java versions
- JDK 8 (Temurin) installed via Homebrew cask
- Default set to JDK 1.8 in `zshrc` (`jdk 1.8 true`)
- Sourced conditionally: `[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"` in `zshrc`
- Also installed directly via Homebrew
## Editors
- Installed from `d12frosted/emacs-plus` tap with modern purple flat icon
- Literate configuration via Org Mode (`emacs.d/config.org` → 2168 lines)
- Evil mode (Vi emulation) enabled
- LSP support via `lsp-mode` v9.0.0
- GitHub Copilot integration via `copilot.el`
- Languages configured: Go, Ruby, Clojure, C/C++, Python, TypeScript, Lua, Erlang, Protobuf, Groovy, Jsonnet
- Theme: Nord
- Installed via Homebrew
- Config: `config/nvim/init.vim` (delegates to `vim/vimrc`)
- Plugin manager: vim-plug
- CoC (Conquer of Completion) for LSP: `neoclide/coc.nvim`
- CoC extensions: `coc-marketplace`, `coc-solargraph` (Ruby), `coc-vimlsp`
- ALE for linting: `dense-analysis/ale`
- Theme: Nord (via nord-vim) or Gruvbox
- Config: `ideavimrc`
- Plugins emulated: surround, commentary, argtextobj, textobj-entire
## Key Dependencies
- `fzf` — fuzzy finder (integrated with both Zsh and Vim)
- `ripgrep` (`rg`) — fast search (used as FZF default command)
- `bat` — cat replacement with syntax highlighting (aliased as `cat` in `zsh/aliases.zsh`)
- `tmux` — terminal multiplexer
- `tig` — text-mode git interface
- `jq` — JSON processor (used heavily in yabai/skhd scripts)
- `grpcurl` — gRPC client
- `cmake` — build system
- `rcm` — dotfile management
- `yabai` — tiling window manager (`config/yabai/yabairc`)
- `skhd` — simple hotkey daemon (`config/skhd/skhdrc`)
- `limelight` — window border highlighting (`config/limelight/limelightrc`)
- `karabiner-elements` — keyboard customizer (`config/karabiner/karabiner.json`)
- Alacritty — GPU-accelerated terminal (`config/alacritty/alacritty.toml`)
- Font: "Source Code Pro for Powerline" (Alacritty), "SauceCodePro Nerd Font Mono" (Emacs)
- Tridactyl — Vim-like Firefox extension (`config/tridactyl/tridactylrc`)
- OpenCode — AI coding CLI (`config/opencode/opencode.jsonc`)
- GitHub Copilot — integrated in Emacs via `copilot.el`
## Configuration
- `EDITOR=nvim`
- `KUBE_EDITOR=nvim`
- `LANG=en_US.UTF-8`
- `FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"`
- `FZF_DEFAULT_OPTS="--layout=reverse --inline-info"`
- `GPG_TTY=$(tty)`
- `NVM_DIR="$HOME/.nvm"`
- `PYENV_ROOT="$HOME/.pyenv"`
- `$HOME/bin` (highest priority)
- `$HOME/.zsh/bin`
- `$HOME/.vim/pack/bundle/opt/vcs-jump/bin`
- `$HOME/.fzf/bin`
- `/usr/local/bin`, `/usr/local/sbin`
- System PATH
- `$HOME/.local/bin`
- `$HOME/.rbenv/shims`
- `$PYENV_ROOT/shims`
- No CI/CD pipeline — this is a personal dotfiles repo
- Deployment is manual: `ansible-playbook dotfiles.yml` then `rcup`
## Platform Requirements
- macOS (Darwin) required — many configs are macOS-specific
- Homebrew must be installed (or set `install_homebrew_if_missing: true` in Ansible vars)
- Xcode Command Line Tools (implicit dependency for Homebrew)
- Source Code Pro for Powerline (installed via Homebrew cask: `font-source-code-pro-for-powerline`)
- SauceCodePro Nerd Font Mono (installed via Homebrew cask: `font-sauce-code-pro-nerd-font`)
- Monego Nerd Font Fix (referenced in Emacs Org mode heading config)
<!-- GSD:stack-end -->

<!-- GSD:conventions-start source:CONVENTIONS.md -->
## Conventions

## Naming Patterns
- Zsh config files use lowercase with `.zsh` extension: `aliases.zsh`, `functions.zsh`, `exports.zsh`, `path.zsh`, `colors.zsh`
- Vim plugin config files use lowercase with `.vim` extension, named after the plugin they configure: `airline.vim`, `nerdtree.vim`, `fzf.vim`
- Vim mapping files are organized by mode: `normal.vim`, `visual.vim`, `leader.vim`, `command.vim`
- Shell scripts use camelCase for yabai helpers: `moveWindowLeftAndFollowFocus.sh`, `switchAndFocusSIP.sh`, `toggleStackLayout.sh`
- XDG config directories use lowercase tool names: `config/alacritty/`, `config/skhd/`, `config/yabai/`
- Private hook functions use hyphen-prefix naming: `-set-tab-and-window-title()`, `-update-window-title-precmd()`, `-record-start-time()`, `-report-start-time()`
- VCS info hook functions use `+vi-` prefix per zsh convention: `+vi-hg-bookmarks()`, `+vi-git-untracked()`
- Utility functions use lowercase with no prefix: `luma()`, `color()`, `jdk()`
- Anonymous functions use `function () { }` for scoping: see `zshrc` lines 173, 134 in `colors.zsh`
- Inner/nested functions use double-underscore prefix: `__color()` in `zsh/colors.zsh`
- All zsh hook functions use `emulate -L zsh` as the first line for local option scoping
- Autoload functions use namespace pattern: `wincent#commands#find()`, `wincent#autocmds#mkview()`
- Script-local functions use `s:` prefix: `s:CheckColorScheme()`, `s:Open()`, `s:get_spell_settings()`
- Filetype mapping functions use module pattern: `ftmappings#go#vim_go_maps()`, `mappings#coc#SetupMappings()`
- Global blacklist variables use `g:Wincent` prefix: `g:WincentColorColumnFileTypeBlacklist`, `g:WincentCursorlineBlacklist`
- Global state hash table: `__ABRAMPERS` (uppercase with double-underscore prefix)
- Environment variables: `UPPERCASE_WITH_UNDERSCORES` (standard convention)
- Local variables in functions: use `local` keyword with `UPPER_CASE` names for computed values: `local TMUXING`, `local LVL`, `local SUFFIX`
- Color function locals use `COLOR_` prefix: `COLOR_HEX`, `COLOR_HEX_RED`, `COLOR_DEC_RED`, `COLOR_LUMA`
- Plugin config uses `g:` scope with plugin-prefixed names: `g:go_fmt_command`, `g:NERDTreeWinSize`
- Script-local uses `s:` scope: `s:vimrc_local`, `s:config_file`
- Buffer-local uses `b:` scope for filetype-specific: `b:ale_linters`, `b:ale_fixers`
- Git aliases follow alphabetical organization sorted by git subcommand: `ga='git add'`, `gb='git branch'`, `gc='git commit -v'`
- Git compound aliases build from first letters: `gaa='git add --all'`, `gcmsg='git commit -m'`
- Unix aliases override defaults with preferred flags: `ls='ls -G'`, `grep='grep --color'`, `mkdir='mkdir -p'`
- Global aliases (pipe shortcuts) use uppercase single chars: `-g G='| grep'`, `-g M='| less'`, `-g ONE="| awk '{ print \$1}'"`
- Tool replacement aliases: `cat='bat'`, `vim="$(brew --prefix)/bin/vim"`
- Humorous aliases: `:w="echo this isn\'t vim"`, `:q='exit'`
- Custom variables use `abram/` prefix: `abram/blog-content-org-file`, `abram/org-directory`, `abram/org-roam-directory`
## Code Style
- No automated formatter (no `.prettierrc`, `.editorconfig`, or similar)
- Indentation: 2 spaces in Vim/Zsh config files
- Go files: tabs with width 4 (set in `vim/ftplugin/go.vim`)
- Ruby files: 2 spaces (set in `vim/ftplugin/ruby.vim`)
- Default Vim: 2-space soft tabs (`shiftwidth=2`, `tabstop=2`, `expandtab` in `vim/plugin/settings.vim`)
- ALE (Asynchronous Lint Engine) for Vim: `dense-analysis/ale` plugin in `vim/vimrc`
- Proto files use `buf-lint` via ALE: `vim/ftplugin/proto.vim`
- No global shell linter configured (no shellcheck integration)
## Comment Style
- Section headers use `#` with blank lines above and below:
- Inline comments explain "why" not "what": `# Suppress unwanted Homebrew-installed stuff.`
- URL references included for sources: `# See: https://github.com/mathiasbynens/dotfiles/issues/687`
- `[default]` annotation in setopt lines marks options that are default: `setopt AUTO_CD  # [default] .. is shortcut for cd ..`
- Block comments for multi-line explanations use `#` prefix on each line
- Use `"` for comments (Vim standard)
- Setting comments use inline explanation aligned with padding: `set autoindent  " maintain indent of current line`
- Unicode characters documented with name and code: `set listchars=nbsp:⦸  " CIRCLED REVERSE SOLIDUS (U+29B8, UTF-8: E2 A6 B8)`
- Mnemonic hints in parentheses: `" (mnemonic: path; useful when...)`
- TODO/FIXME markers present: `" TODO: make this async` in `vim/autoload/wincent/commands.vim`
- Comments explain key context: `# normally used for last-window`
- Section grouping with comment blocks
- Reference to documentation: `# Bindings: - to see current bindings: tmux list-keys`
- Sparse commenting, primarily for context: `# $1 is the first argument passed in (window id).`
- Operator explanations: `# (-n) >> != null`, `# -z >> true if it's null`
## Configuration Organization Patterns
- `zshenv` → sources `exports.zsh` and `path.zsh` (loaded for all shells)
- `zshrc` → main interactive config with sections: Global, Completion, Prompt, History, Options, Plugins, Bindings, Hooks, Source variables, Third-Party
- `zsh/exports.zsh` → environment variable exports
- `zsh/path.zsh` → PATH construction (unsets and rebuilds from scratch)
- `zsh/aliases.zsh` → command aliases
- `zsh/functions.zsh` → utility functions
- `zsh/colors.zsh` → color scheme management (base16)
- Local override: `~/.zshrc.local` and `~/.zsh/host/$(hostname -s)` are sourced if they exist
- `vim/vimrc` (and `vim/init.vim` for Neovim) → leader keys, plugin globals, vim-plug declarations
- `vim/plugin/settings.vim` → all `set` options
- `vim/plugin/mappings/` → keybindings split by mode: `normal.vim`, `visual.vim`, `leader.vim`, `command.vim`, `coc.vim`, `omnifunc.vim`
- `vim/plugin/*.vim` → per-plugin configuration files (one file per plugin)
- `vim/ftplugin/*.vim` → filetype-specific settings (26 filetypes)
- `vim/ftdetect/*.vim` → filetype detection rules
- `vim/after/plugin/*.vim` → post-plugin-load overrides
- `vim/after/compiler/*.vim` → custom compiler definitions
- `vim/autoload/wincent/` → lazy-loaded utility functions namespaced under `wincent#`
- Local override: `~/.vim/vimrc.local` sourced if it exists
- `tmux.conf` → monolithic config file (170 lines)
- `tmux/` → plugin submodules (nord-tmux, tmux-prefix-highlight)
- Local override: `~/.tmux-local.conf` sourced if it exists (via `source-file -q`)
- Each tool gets its own subdirectory: `config/alacritty/`, `config/nvim/`, `config/skhd/`, etc.
- Maps to `~/.config/` via rcm symlinks
- Neovim init delegates entirely to Vim config: `config/nvim/init.vim` → sources `~/.vim/vimrc`
## Local Override Pattern
- **Zsh:** `~/.zshrc.local` and `~/.zsh/host/$(hostname -s)` — `zshrc` line 452-457
- **Vim:** `~/.vim/vimrc.local` — `vim/vimrc` line 38-41
- **Tmux:** `~/.tmux-local.conf` — `tmux.conf` line 170
- **Vim local-settings:** `vim/plugin/local-settings.vim` is gitignored — `vim/.gitignore`
## Keybinding Conventions
- `h/j/k/l` for directional movement used consistently:
- **Vim:** `<Space>` as leader, `,` as local leader — `vim/vimrc` lines 5-6
- **IdeaVim:** `<Space>` as leader — `ideavimrc` line 7
- Leader mappings organized by purpose:
- `C-a` (remapped from default `C-b`) — `tmux.conf` line 3
- `C-a C-a` → toggle last window (like vim `<C-^>`)
- Intuitive splits: `|` for horizontal, `-` for vertical — `tmux.conf` lines 50-51
- `prefix-r` → reload config — `tmux.conf` line 168
- `tt` → TestNearest, `tf` → TestFile, `ts` → TestSuite, `tl` → TestLast, `tv` → TestVisit — `vim/plugin/vim-test.vim`
- Same pattern in IdeaVim: `tt` → RunCoverage, `td` → DebugClass, `ts` → Run — `ideavimrc`
- `hyper` key (Shift+Cmd+Alt+Ctrl) as primary modifier — `config/skhd/skhdrc`
- `rctrl+rcmd` for opening applications — `config/skhd/skhdrc` lines 13-15
- `shift+alt` for resizing — `config/skhd/skhdrc` lines 31-34
- `hyper-f` for fullscreen toggle — `config/skhd/skhdrc` line 28
## Plugin Management Conventions
- vim-plug for plugin management — `vim/vimrc` lines 52-114 (`call plug#begin()` / `call plug#end()`)
- Lazy loading via `'on'` (commands) and `'for'` (filetypes): `Plug 'fatih/vim-go', { 'for': ['go', 'gomod'] }`
- Some legacy git submodules still referenced in `.gitmodules` for opt packages under `vim/pack/bundle/opt/`
- CoC extensions managed separately in `config/coc/`
- Plugins stored as directories under `zsh/`: `zsh/zsh-autosuggestions/`, `zsh/zsh-syntax-highlighting/`, etc.
- Some managed as git submodules (listed in `.gitmodules`), some appear to be manually placed
- Sourced explicitly in `zshrc` lines 242-249
- No plugin manager (no oh-my-zsh, no zinit) — direct sourcing
- Plugins as git submodules under `tmux/`: `tmux/nord-tmux/`, `tmux/tmux-prefix-highlight/`
- Loaded via `run-shell` commands in `tmux.conf` lines 61, 66
- `straight.el` for package management (indicated by `emacs.d/straight/` directory)
- Literate config via org-babel: `emacs.d/init.el` loads `config.org`
## Dotfile Symlink Management
- `rcrc` defines exclusions: `EXCLUDES="*.md *.png *.jpg install.sh dotfiles.yml dotfiles.yaml tags* sample*"`
- Files/directories at repo root become dotfiles in `$HOME` (e.g., `zshrc` → `~/.zshrc`)
- `config/` directory maps to `~/.config/` (XDG convention)
- `vim/` maps to `~/.vim/`
- `zsh/` maps to `~/.zsh/`
- `emacs.d/` maps to `~/.emacs.d/`
## Import/Source Organization
## Error Handling
- Guard command existence before use: `if command -v dry &> /dev/null; then` — `zshrc` line 51
- Conditional platform checks: `if [ "$(uname)" = "Darwin" ]; then` — `zshrc` line 16
- Test file existence before sourcing: `test -f $LOCAL_RC && source $LOCAL_RC` — `zshrc` line 454
- Silent failures for optional tools: `[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"` — `zshrc` line 493
- Feature detection: `if has('nvim')`, `if exists('+colorcolumn')`, `if has('termguicolors')`
- File readability checks: `if filereadable(s:vimrc_local)` — `vim/vimrc` line 39
- Try/catch blocks for error handling: `try ... catch /\<E186\>/ ... endtry` — `vim/autoload/wincent/autocmds.vim` line 33
- Executable checks: `if !executable('open')` — `vim/autoload/wincent/commands.vim` line 9
- Minimal error handling; most yabai scripts use `||` fallback pattern: `yabai -m window --display prev || yabai -m window --display last`
- No `set -e` or `set -u` in shell scripts (scripts use `#!/bin/dash` or `#!/bin/bash`)
## Module/File Design
- Zsh files do not use explicit exports for functions/aliases — they rely on being sourced into the main shell
- Vim autoload files are namespaced and lazy-loaded via the `autoload/wincent/` directory structure
- Each Vim plugin config is isolated in its own file under `vim/plugin/`
- Settings (options) are never mixed with mappings
- Plugin configuration is one file per plugin
- Filetype-specific config lives in `ftplugin/` or `after/ftplugin/`
- Custom commands are separated from mappings: `vim/plugin/commands.vim` vs `vim/plugin/mappings/`
<!-- GSD:conventions-end -->

<!-- GSD:architecture-start source:ARCHITECTURE.md -->
## Architecture

## Pattern Overview
- Files are organized by tool (zsh, vim, tmux, emacs) at the top level
- XDG-compatible configs live under `config/` (maps to `~/.config/`)
- rcm handles symlinking from repo to home directory, prepending `.` to file/directory names
- Ansible playbook (`dotfiles.yml`) automates full workstation setup including Homebrew packages, shell configuration, and rcm deployment
- Modular zsh configuration with dedicated files for aliases, exports, path, colors, functions, and plugins
- Vim configuration uses a layered architecture: `vimrc` → `plugin/` → `after/plugin/` with autoload functions
- Neovim delegates entirely to the Vim configuration via `config/nvim/init.vim`
## Layers
- Purpose: Automate full workstation setup from scratch
- Location: `dotfiles.yml`
- Contains: Homebrew package installation, shell setup, rcm deployment
- Depends on: Homebrew, Ansible
- Used by: Initial setup or full reprovisioning
- Purpose: Map repository files to home directory locations as symlinks
- Location: `rcrc` (configuration for rcm)
- Contains: Exclusion patterns for non-deployable files
- Depends on: rcm (`rcup` command)
- Used by: All tools that read configs from home directory
- Purpose: Interactive shell configuration
- Location: `zshenv`, `zshrc`, `zsh/`
- Contains: Environment variables, PATH, aliases, functions, plugins, prompt, hooks
- Depends on: Homebrew, fzf, pyenv, rbenv, nvm, base16-shell
- Used by: All terminal sessions
- Purpose: Text editor configuration
- Location: `vim/`, `config/nvim/`
- Contains: Plugin management (vim-plug), settings, mappings, filetype configs, autoload functions
- Depends on: vim-plug, CoC (Conquer of Completion), pyenv, rbenv
- Used by: Vim and Neovim (shared configuration)
- Purpose: Emacs configuration using literate programming
- Location: `emacs.d/`
- Contains: Literate Org-mode config, straight.el package management, custom themes
- Depends on: straight.el, use-package
- Used by: Emacs
- Purpose: Terminal multiplexer configuration and plugins
- Location: `tmux.conf`, `tmux/`
- Contains: Key bindings, appearance settings, plugin references
- Depends on: nord-tmux theme, tmux-prefix-highlight plugin
- Used by: tmux sessions
- Purpose: Tiling window manager and hotkey daemon for macOS
- Location: `config/yabai/`, `config/skhd/`, `config/limelight/`, `scripts/yabai/`
- Contains: Layout rules, app exclusions, keyboard shortcuts, helper scripts
- Depends on: yabai, skhd, limelight, jq
- Used by: macOS desktop environment
- Purpose: Application configs that follow XDG Base Directory spec
- Location: `config/` (maps to `~/.config/`)
- Contains: alacritty, bat, coc, karabiner, nvim, opencode, skhd, tridactyl, yabai, limelight
- Depends on: Individual applications
- Used by: rcm (deployed to `~/.config/`)
## Data Flow
- Color scheme state: `~/.vim/.base16` file (shared between zsh and vim)
- Shell history: `~/.history` (shared across shells via SHARE_HISTORY)
- Vim undo history: `~/.vim/tmp/undo/`
- Vim swap files: `~/.vim/tmp/swap/`
- Vim backups: `~/.vim/tmp/backup/`
- Emacs state: `~/.emacs.d/straight/` (packages), `~/.emacs.d/var/` (runtime state)
## Key Abstractions
- Purpose: Maps repo files to home directory with `.` prefix
- Pattern: `{repo}/foo` → `~/.foo`, `{repo}/config/bar/baz` → `~/.config/bar/baz`
- Examples: `rcrc` → `~/.rcrc`, `zshrc` → `~/.zshrc`, `vim/` → `~/.vim/`
- Exclusions defined in `rcrc`: `*.md *.png *.jpg install.sh dotfiles.yml dotfiles.yaml tags* sample*`
- Purpose: Split shell configuration into focused, single-responsibility files
- Examples: `zsh/aliases.zsh`, `zsh/exports.zsh`, `zsh/path.zsh`, `zsh/colors.zsh`, `zsh/functions.zsh`
- Pattern: Each file sourced explicitly from `zshenv` or `zshrc`
- Purpose: Separate Vim configuration by concern using Vim's native directory structure
- Examples: `vim/plugin/settings.vim`, `vim/plugin/mappings/leader.vim`, `vim/after/plugin/color.vim`
- Pattern: `plugin/` for pre-plugin config, `after/plugin/` for post-plugin overrides
- Purpose: Lazy-loaded utility functions under `wincent#` namespace
- Examples: `vim/autoload/wincent/settings.vim`, `vim/autoload/wincent/autocmds.vim`, `vim/autoload/wincent/mappings/`
- Pattern: Functions called as `wincent#module#function()`, only loaded when first invoked
- Purpose: Third-party zsh plugins included as subdirectories (git submodules or vendored)
- Examples: `zsh/zsh-autosuggestions/`, `zsh/zsh-history-substring-search/`, `zsh/git-aliases/`
- Pattern: Sourced directly from `zshrc` via `source $HOME/.zsh/{plugin}/{main-file}.zsh`
## Entry Points
- Location: `zshenv` → `zshrc`
- Triggers: Opening a terminal, SSH session, tmux pane
- Responsibilities: Set up complete shell environment with PATH, aliases, functions, plugins, prompt
- Location: `config/nvim/init.vim` → `vim/vimrc`
- Triggers: Running `nvim` or `vim`
- Responsibilities: Load all editor configuration, plugins, mappings, and appearance
- Location: `emacs.d/init.el` → `emacs.d/config.org`
- Triggers: Running `emacs`
- Responsibilities: Bootstrap straight.el, tangle org config, load full configuration
- Location: `tmux.conf`
- Triggers: Starting tmux
- Responsibilities: Set prefix, bindings, appearance, plugins; source `~/.tmux-local.conf` for overrides
- Location: `config/yabai/yabairc`
- Triggers: yabai service start
- Responsibilities: Configure tiling layout, app rules, limelight integration
- Location: `config/skhd/skhdrc`
- Triggers: skhd service start
- Responsibilities: Map keyboard shortcuts to yabai commands and app launchers
- Location: `dotfiles.yml`
- Triggers: Manual run via `ansible-playbook dotfiles.yml`
- Responsibilities: Install all tools, set default shell, deploy dotfiles via rcm
## Error Handling
- Shell: `test -f $FILE && source $FILE` for optional local overrides (`~/.zshrc.local`, `~/.zsh/host/$(hostname -s)`)
- Shell: `command -v tool &> /dev/null` before using optional tools (`dry`, `pyenv`, etc.)
- Vim: `if filereadable(s:vimrc_local)` before sourcing local vim config
- Vim: `if has('feature')` / `if exists('option')` guards for feature-dependent settings
- Vim: `if v:progname == 'vi'` disables plugins when invoked as plain `vi`
- tmux: `source-file -q ~/.tmux-local.conf` (quiet flag suppresses error if missing)
- Emacs: `(when (file-exists-p private-init-file) (load-file private-init-file))`
- Emacs: `vc-follow-symlinks` set to handle rcm symlinks transparently
## Cross-Cutting Concerns
- Base16 color scheme system shared between terminal (zsh), editor (vim), and multiplexer (tmux)
- `zsh/colors.zsh` provides the `color` function to switch schemes
- State persisted in `~/.vim/.base16`, read by both zsh and vim
- Supports dark/light detection via luma calculation
- base16-shell scripts in `zsh/base16-shell/` apply terminal escape sequences
- zsh: `~/.zshrc.local` for machine-specific shell config
- zsh: `~/.zsh/host/$(hostname -s)` for host-specific config
- vim: `~/.vim/vimrc.local` for machine-specific vim config (gitignored)
- vim: `vim/plugin/local-settings.vim` for checked-in but environment-specific settings (gitignored by `vim/.gitignore`)
- tmux: `~/.tmux-local.conf` for machine-specific tmux config
- emacs: `~/.emacs.d/private-init.el` for private variables (sample provided)
- Entire repo assumes macOS (Homebrew, `defaults write`, Karabiner, yabai/skhd)
- Ansible playbook handles Intel vs Apple Silicon architecture differences
- Helper scripts in `scripts/` for macOS Automator apps (VPN, TOTP)
- Karabiner config maps function keys to custom scripts
- Source Code Pro for Powerline configured in Alacritty (`config/alacritty/alacritty.toml`)
- Powerline symbols enabled in vim-airline (`vim/plugin/airline.vim`)
- Fonts installed via Homebrew casks in Ansible playbook
<!-- GSD:architecture-end -->

<!-- GSD:workflow-start source:GSD defaults -->
## GSD Workflow Enforcement

Before using Edit, Write, or other file-changing tools, start work through a GSD command so planning artifacts and execution context stay in sync.

Use these entry points:
- `/gsd:quick` for small fixes, doc updates, and ad-hoc tasks
- `/gsd:debug` for investigation and bug fixing
- `/gsd:execute-phase` for planned phase work

Do not make direct repo edits outside a GSD workflow unless the user explicitly asks to bypass it.
<!-- GSD:workflow-end -->



<!-- GSD:profile-start -->
## Developer Profile

> Profile not yet configured. Run `/gsd:profile-user` to generate your developer profile.
> This section is managed by `generate-claude-profile` -- do not edit manually.
<!-- GSD:profile-end -->
