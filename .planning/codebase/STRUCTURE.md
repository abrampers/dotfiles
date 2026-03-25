# Codebase Structure

**Analysis Date:** 2026-03-25

## Directory Layout

```
.dotfiles/
├── .gitignore              # Ignores vars/*.yml (Ansible secrets)
├── .gitmodules             # Git submodules for zsh/vim plugins
├── assets/                 # Screenshots for README
├── config/                 # XDG-compliant configs → ~/.config/
│   ├── alacritty/          # Terminal emulator config
│   ├── bat/                # bat (cat replacement) config
│   ├── coc/                # CoC (Vim LSP) extensions/state
│   ├── karabiner/          # Keyboard remapping
│   ├── limelight/          # Window border highlighting
│   ├── nvim/               # Neovim entry point (delegates to vim/)
│   ├── opencode/           # OpenCode AI assistant config
│   ├── skhd/               # Hotkey daemon config
│   ├── tridactyl/          # Firefox vim keybindings
│   └── yabai/              # Tiling window manager config
├── dotfiles.yml            # Ansible playbook for full setup
├── emacs.d/                # Emacs configuration → ~/.emacs.d/
│   ├── config.org          # Literate config (2168 lines)
│   ├── init.el             # Bootstrap: loads config.org
│   ├── sample.private-init.el  # Template for private vars
│   ├── straight/           # Package manager version locks
│   └── themes/             # Custom Emacs themes
├── ideavimrc               # JetBrains IDE vim emulation → ~/.ideavimrc
├── rcrc                    # rcm configuration → ~/.rcrc
├── README.org              # Repository documentation
├── scripts/                # Helper scripts and macOS apps
│   ├── gojek-integration-vpn.app/  # macOS Automator app
│   ├── gojek-production-vpn.app/   # macOS Automator app
│   ├── gojek-totp.app/             # macOS Automator app
│   └── yabai/              # Window manager helper scripts
├── tigrc                   # tig (git TUI) config → ~/.tigrc
├── tmux.conf               # tmux configuration → ~/.tmux.conf
├── tmux/                   # tmux plugins → ~/.tmux/
│   ├── nord-tmux/          # Nord color theme for tmux
│   └── tmux-prefix-highlight/  # Prefix indicator plugin
├── vim/                    # Vim/Neovim configuration → ~/.vim/
│   ├── .gitignore          # Ignores tmp/, tags, .base16, local settings
│   ├── after/              # Post-plugin overrides
│   ├── autoload/           # Lazy-loaded utility functions
│   ├── doc/                # Vim documentation (empty, gitignored)
│   ├── ftdetect/           # Filetype detection rules
│   ├── ftplugin/           # Filetype-specific settings
│   ├── init.vim            # Neovim legacy entry (identical to vimrc)
│   ├── plugin/             # Auto-loaded config files
│   ├── spell/              # Custom spelling dictionary
│   └── vimrc               # Main Vim configuration entry point
├── zsh/                    # Zsh configuration modules → ~/.zsh/
│   ├── .zsh                # Self-referencing symlink (rcm artifact)
│   ├── aliases.zsh         # Shell aliases
│   ├── base16-shell/       # Base16 terminal color scripts (submodule)
│   ├── bin/                # User scripts added to PATH
│   ├── brew-zsh-plugin/    # Homebrew helper functions/aliases
│   ├── colors.zsh          # Color scheme management (base16)
│   ├── completions/        # Custom zsh completions
│   ├── exports.zsh         # Environment variable exports
│   ├── functions.zsh       # Shell utility functions
│   ├── git-aliases/        # Comprehensive git alias set
│   ├── path.zsh            # PATH construction
│   ├── plugin-osx/         # macOS-specific aliases and functions
│   ├── zsh-autosuggestions/       # Fish-like autosuggestions plugin
│   ├── zsh-history-substring-search/  # History substring search (submodule)
│   └── zsh-syntax-highlighting/   # Syntax highlighting plugin
├── zshenv                  # Zsh environment (sourced first) → ~/.zshenv
└── zshrc                   # Zsh interactive config → ~/.zshrc
```

## Directory Purposes

**`config/`:**
- Purpose: Houses all XDG Base Directory spec configurations
- Contains: Application configs that expect to live under `~/.config/`
- Key files:
  - `config/nvim/init.vim`: 3-line shim that redirects Neovim to use `~/.vim/vimrc`
  - `config/alacritty/alacritty.toml`: Terminal font, opacity, padding settings
  - `config/yabai/yabairc`: Tiling WM layout, app rules, spacing
  - `config/skhd/skhdrc`: Global keyboard shortcuts for window management
  - `config/karabiner/karabiner.json`: Keyboard remapping (F2-F4 for VPN/TOTP)
  - `config/bat/config`: bat theme and display options
  - `config/tridactyl/tridactylrc`: Firefox vim-mode key bindings
  - `config/limelight/limelightrc`: Active window border highlighting
  - `config/opencode/opencode.jsonc`: AI assistant model configuration
  - `config/coc/extensions/`: CoC LSP extensions and state

**`zsh/`:**
- Purpose: All zsh-related configuration modules and plugins
- Contains: Shell scripts (.zsh), plugin directories, completions, user binaries
- Key files:
  - `zsh/exports.zsh`: EDITOR, PYENV_ROOT, KUBE_EDITOR, locale, FZF, GPG, NVM
  - `zsh/path.zsh`: Complete PATH reconstruction (~/bin, ~/.zsh/bin, fzf, system, pyenv, rbenv)
  - `zsh/aliases.zsh`: Unix aliases (ls, grep, cat→bat, vim, ctags)
  - `zsh/colors.zsh`: Base16 color scheme switching (`color` function), luma calculation, auto-apply on shell start
  - `zsh/functions.zsh`: Utility functions (`jdk` for Java version switching)
  - `zsh/bin/diff-highlight`: Git diff highlighting script (added to PATH)
  - `zsh/completions/_color`: Completion for `color` command
  - `zsh/completions/_portool`: Completion for `portool` command

**`vim/`:**
- Purpose: Complete Vim/Neovim configuration
- Contains: Plugin configs, key mappings, filetype settings, autoload functions
- Key files:
  - `vim/vimrc`: Main entry point — leader keys, plugin vars, vim-plug plugin list
  - `vim/init.vim`: Identical to vimrc (Neovim legacy compatibility)
  - `vim/plugin/settings.vim`: Core Vim settings (231 lines — indent, tabs, folding, undo, etc.)
  - `vim/plugin/fzf.vim`: Fuzzy finder bindings (Ctrl-P for files, Leader-f for ripgrep)
  - `vim/plugin/airline.vim`: Status line configuration
  - `vim/plugin/git.vim`: Fugitive/git key bindings
  - `vim/plugin/mappings/leader.vim`: Space-key leader mappings
  - `vim/plugin/mappings/normal.vim`: Normal mode remaps (window nav, quickfix nav)
  - `vim/plugin/mappings/coc.vim`: LSP mappings (go-to-definition, references, rename)
  - `vim/after/plugin/color.vim`: Color scheme loader (reads ~/.vim/.base16, applies base16/nord/gruvbox)

**`vim/autoload/wincent/`:**
- Purpose: Lazy-loaded Vim utility functions under `wincent#` namespace
- Contains: Functions for autocmds, commands, compiler, debug, defer, git, mappings, settings, statusline, tabline, undotree, variables
- Key files:
  - `vim/autoload/wincent/settings.vim`: Fold text formatting function
  - `vim/autoload/wincent/autocmds.vim`: Autocmd helper functions
  - `vim/autoload/wincent/mappings/`: Leader mapping helper functions
  - `vim/autoload/health/wincent.vim`: Neovim health check

**`vim/ftdetect/`:**
- Purpose: Custom filetype detection rules for non-standard extensions
- Contains: 12 detection files for: arc, bnd, ignore, jest, json, jsx, muttrc, npmbundler, ruby, spec, tsx, wikitext

**`vim/ftplugin/`:**
- Purpose: Filetype-specific editor settings
- Contains: 26 filetype configs for: arc, c, crontab, diff, gitcommit, gitconfig, go, haskell, hgcommit, java, javascript, javascriptreact, json, mail, markdown, objc, prolog, proto, python, qf, ruby, rust, typescript, typescriptreact, vim, wikitext

**`vim/after/`:**
- Purpose: Post-plugin configuration overrides
- Contains: Plugin overrides (`after/plugin/`), filetype overrides (`after/ftplugin/`), compiler definitions (`after/compiler/`)
- Key files:
  - `vim/after/plugin/color.vim`: Color scheme application (91 lines)
  - `vim/after/plugin/fugitive.vim`: Git plugin overrides
  - `vim/after/plugin/loupe.vim`: Search highlight overrides
  - `vim/after/compiler/jest.vim`, `tsc.vim`, `eslint.vim`: Compiler definitions

**`emacs.d/`:**
- Purpose: Emacs configuration using literate Org-mode approach
- Contains: Org-mode config, init bootstrap, package version locks, custom themes
- Key files:
  - `emacs.d/init.el`: 6-line bootstrap that tangles and loads config.org
  - `emacs.d/config.org`: Full Emacs config in literate Org-mode (2168 lines)
  - `emacs.d/sample.private-init.el`: Template for private/local Emacs variables
  - `emacs.d/themes/vivid-chalk-theme.el`: Custom Emacs color theme
  - `emacs.d/straight/versions/default.el`: Package version lock file

**`tmux/`:**
- Purpose: tmux plugins (loaded via `run-shell` in `tmux.conf`)
- Contains: Theme and UI enhancement plugins
- Key files:
  - `tmux/nord-tmux/`: Nord color theme for tmux status bar
  - `tmux/tmux-prefix-highlight/`: Shows prefix/copy/sync mode indicators

**`scripts/`:**
- Purpose: Helper scripts and macOS Automator applications
- Contains: Yabai window management scripts, VPN/TOTP automation
- Key files:
  - `scripts/yabai/moveWindowLeftAndFollowFocus.sh`: Move window to left monitor
  - `scripts/yabai/moveWindowRightAndFollowFocus.sh`: Move window to right monitor
  - `scripts/yabai/switchAndFocusSIP.sh`: Switch spaces with SIP enabled
  - `scripts/yabai/toggleStackLayout.sh`: Toggle between BSP and stack layouts
  - `scripts/yabai/windowFocusOnDestroy.sh`: Auto-focus on window close
  - `scripts/gojek-*.app/`: macOS Automator apps for VPN/TOTP

**`assets/`:**
- Purpose: Screenshots for README documentation
- Contains: `emacs.png`, `terminal.png`
- Note: Excluded from rcm deployment via `rcrc` EXCLUDES pattern (`*.png`)

## Key File Locations

**Entry Points:**
- `zshenv`: First file sourced by zsh (environment variables + PATH)
- `zshrc`: Interactive shell configuration (prompt, plugins, hooks, bindings)
- `vim/vimrc`: Main Vim/Neovim configuration with plugin list
- `config/nvim/init.vim`: Neovim shim that delegates to `vim/vimrc`
- `emacs.d/init.el`: Emacs bootstrap that loads `config.org`
- `tmux.conf`: tmux configuration
- `dotfiles.yml`: Ansible provisioning playbook

**Configuration:**
- `rcrc`: rcm deployment rules (EXCLUDES pattern)
- `config/alacritty/alacritty.toml`: Terminal emulator appearance
- `config/karabiner/karabiner.json`: Keyboard remapping rules
- `config/yabai/yabairc`: Window manager layout and rules
- `config/skhd/skhdrc`: Global keyboard shortcuts
- `config/bat/config`: bat (cat replacement) settings

**Core Logic:**
- `zsh/path.zsh`: PATH construction (rebuilt from scratch on every shell)
- `zsh/colors.zsh`: Base16 color scheme management system
- `zsh/exports.zsh`: Environment variable definitions
- `vim/plugin/settings.vim`: Core Vim editor settings
- `vim/after/plugin/color.vim`: Color scheme synchronization with shell

**Testing:**
- No test framework present (this is a personal dotfiles repo)

## Naming Conventions

**Files:**
- Top-level dotfiles: No dot prefix in repo, rcm prepends `.` during deployment (`zshrc` → `~/.zshrc`)
- Zsh modules: `{purpose}.zsh` pattern (e.g., `aliases.zsh`, `exports.zsh`, `path.zsh`)
- Vim plugin configs: `{plugin-or-feature}.vim` in `vim/plugin/`
- Vim mappings: `{mode}.vim` in `vim/plugin/mappings/` (e.g., `leader.vim`, `normal.vim`, `visual.vim`)
- Vim filetypes: `{language}.vim` in `vim/ftplugin/` and `vim/ftdetect/`
- Vim autoload: `wincent/{module}.vim` in `vim/autoload/`
- Config dirs: Match the application name they configure (e.g., `config/alacritty/`, `config/bat/`)

**Directories:**
- Tool-named at top level: `zsh/`, `vim/`, `tmux/`, `emacs.d/`
- Plugin directories named after the plugin: `zsh-autosuggestions/`, `nord-tmux/`
- `config/` subdirectories match XDG application names

## How rcm Maps Dotfiles to Home Directory

**rcm** (the `rcup` command) creates symlinks from the dotfiles repo to the home directory.

**Mapping Rules:**
1. Top-level files get a `.` prefix: `rcrc` → `~/.rcrc`, `zshrc` → `~/.zshrc`
2. Top-level directories get a `.` prefix: `vim/` → `~/.vim/`, `zsh/` → `~/.zsh/`, `tmux/` → `~/.tmux/`
3. The `config/` directory maps to `~/.config/`: `config/nvim/init.vim` → `~/.config/nvim/init.vim`
4. Files inside directories are symlinked individually (not the directory itself for `~/.vim`, `~/.zsh`, etc.)
5. For `emacs.d/`, files are symlinked into `~/.emacs.d/` individually

**Exclusions (from `rcrc`):**
```
EXCLUDES="*.md *.png *.jpg install.sh dotfiles.yml dotfiles.yaml tags* sample*"
```
This prevents README files, images, the Ansible playbook, tag files, and sample configs from being symlinked.

**Deployment Commands:**
```bash
rcup rcrc          # First: deploy rcrc itself so rcm knows the rules
rcup               # Then: deploy all dotfiles according to rcrc rules
```

**Verified Symlinks:**
| Repo Path | Home Path |
|-----------|-----------|
| `rcrc` | `~/.rcrc` |
| `zshrc` | `~/.zshrc` |
| `zshenv` | `~/.zshenv` |
| `tmux.conf` | `~/.tmux.conf` |
| `tigrc` | `~/.tigrc` |
| `ideavimrc` | `~/.ideavimrc` |
| `vim/vimrc` | `~/.vim/vimrc` |
| `vim/init.vim` | `~/.vim/init.vim` |
| `vim/plugin/*` | `~/.vim/plugin/*` |
| `zsh/aliases.zsh` | `~/.zsh/aliases.zsh` |
| `zsh/exports.zsh` | `~/.zsh/exports.zsh` |
| `config/nvim/init.vim` | `~/.config/nvim/init.vim` |
| `config/alacritty/alacritty.toml` | `~/.config/alacritty/alacritty.toml` |
| `emacs.d/init.el` | `~/.emacs.d/init.el` |
| `emacs.d/config.org` | `~/.emacs.d/config.org` |

## Relationship Between Files (What Sources What)

**Zsh Source Chain:**
```
~/.zshenv (zshenv)
├── sources → ~/.zsh/exports.zsh (zsh/exports.zsh)
└── sources → ~/.zsh/path.zsh (zsh/path.zsh)

~/.zshrc (zshrc)
├── sources → ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
├── sources → ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
├── sources → ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
├── sources → ~/.zsh/plugin-osx/osx-aliases.plugin.zsh
├── sources → ~/.zsh/brew-zsh-plugin/brew.plugin.zsh
├── sources → ~/.zsh/git-aliases/git-aliases.zsh
├── sources → ~/.zsh/aliases.zsh (zsh/aliases.zsh)
├── sources → ~/.zsh/colors.zsh (zsh/colors.zsh)
├── sources → ~/.zsh/functions.zsh (zsh/functions.zsh)
├── sources → ~/.zshrc.local (if exists, not in repo)
├── sources → ~/.zsh/host/$(hostname -s) (if exists, not in repo)
├── sources → $(brew --prefix nvm)/nvm.sh
├── sources → $(brew --prefix)/opt/fzf/shell/completion.zsh
├── sources → $(brew --prefix)/opt/fzf/shell/key-bindings.zsh
└── sources → ~/.gvm/scripts/gvm (if exists)
```

**Vim/Neovim Source Chain:**
```
~/.config/nvim/init.vim (config/nvim/init.vim)
└── sources → ~/.vim/vimrc (vim/vimrc)
    ├── sources → ~/.vim/vimrc.local (if exists, gitignored)
    ├── vim-plug loads plugins from ~/.vim/plugged/
    ├── auto-loads → ~/.vim/plugin/*.vim (vim/plugin/*)
    │   ├── settings.vim        — core editor settings
    │   ├── airline.vim          — status line config
    │   ├── fzf.vim              — fuzzy finder bindings
    │   ├── git.vim              — fugitive bindings
    │   ├── nerdtree.vim         — file tree config
    │   ├── undotree.vim         — undo visualization
    │   ├── vim-grepper.vim      — search tool config
    │   ├── vim-test.vim         — test runner config
    │   ├── dispatch.vim         — async dispatch config
    │   ├── goyo.vim             — distraction-free writing
    │   ├── autocmds.vim         — autocommands (currently commented out)
    │   ├── commands.vim         — custom commands
    │   ├── abbreviations.vim    — text abbreviations
    │   ├── matchit.vim          — enhanced % matching
    │   ├── par.vim              — paragraph formatting
    │   ├── term.vim             — terminal settings
    │   └── mappings/
    │       ├── leader.vim       — Space-key mappings
    │       ├── normal.vim       — Normal mode mappings
    │       ├── visual.vim       — Visual mode mappings
    │       ├── command.vim      — Command mode mappings
    │       ├── coc.vim          — LSP mappings
    │       └── omnifunc.vim     — Omni completion
    ├── auto-loads → ~/.vim/after/plugin/*.vim (vim/after/plugin/*)
    │   ├── color.vim            — color scheme application
    │   ├── fugitive.vim         — fugitive overrides
    │   ├── indentLine.vim       — indent guide overrides
    │   ├── loupe.vim            — search highlight overrides
    │   ├── matchparen.vim       — paren matching overrides
    │   ├── projectionist.vim    — project navigation overrides
    │   ├── tcomment.vim         — comment plugin overrides
    │   ├── vim-clipper.vim      — clipboard overrides
    │   └── vim-eunuch.vim       — unix command overrides
    └── lazy-loads → ~/.vim/autoload/wincent/*.vim (on demand)
```

**tmux Source Chain:**
```
~/.tmux.conf (tmux.conf)
├── run-shell → ~/.tmux/nord-tmux/nord.tmux
├── run-shell → ~/.tmux/tmux-prefix-highlight/prefix_highlight.tmux
└── source-file -q → ~/.tmux-local.conf (if exists, not in repo)
```

**Emacs Source Chain:**
```
~/.emacs.d/init.el (emacs.d/init.el)
└── org-babel-load-file → ~/.emacs.d/config.org (emacs.d/config.org)
    ├── loads → ~/.emacs.d/private-init.el (if exists)
    └── bootstraps → straight.el + use-package for all packages
```

## Where to Add New Code

**New Zsh Alias:**
- Add to `zsh/aliases.zsh` for general aliases
- Add to `zsh/git-aliases/git-aliases.zsh` for git-specific aliases

**New Zsh Function:**
- Simple utility: Add to `zsh/functions.zsh`
- Complex feature: Create a new `zsh/{feature}.zsh` and source it from `zshrc`

**New Environment Variable:**
- Add to `zsh/exports.zsh`

**New PATH Entry:**
- Add to `zsh/path.zsh`

**New Zsh Plugin:**
- Add plugin directory under `zsh/` (clone or submodule)
- Add `source` line in `zshrc` under the "Plugins" section

**New Vim Plugin:**
- Add `Plug` line in `vim/vimrc` (inside `plug#begin`/`plug#end`)
- Add plugin-specific config in `vim/plugin/{plugin-name}.vim`
- Add post-plugin overrides in `vim/after/plugin/{plugin-name}.vim` if needed

**New Vim Key Mapping:**
- Leader mappings: `vim/plugin/mappings/leader.vim`
- Normal mode: `vim/plugin/mappings/normal.vim`
- Visual mode: `vim/plugin/mappings/visual.vim`
- Filetype-specific: `vim/plugin/ftmappings/{language}.vim`

**New Vim Filetype Support:**
- Detection: `vim/ftdetect/{filetype}.vim`
- Settings: `vim/ftplugin/{filetype}.vim`

**New Vim Utility Function:**
- Add to `vim/autoload/wincent/{module}.vim` (lazy-loaded)
- Call as `wincent#module#functionname()`

**New XDG Application Config:**
- Create `config/{appname}/{configfile}`
- rcm will deploy to `~/.config/{appname}/{configfile}`

**New tmux Plugin:**
- Add plugin directory under `tmux/`
- Add `run-shell` line in `tmux.conf`

**New Homebrew Package:**
- Add task in `dotfiles.yml` under the tasks section

**Machine-Specific Overrides:**
- Zsh: Create `~/.zshrc.local` (not tracked in repo)
- Vim: Create `~/.vim/vimrc.local` (gitignored)
- tmux: Create `~/.tmux-local.conf` (not tracked in repo)
- Emacs: Create `~/.emacs.d/private-init.el` (sample provided at `emacs.d/sample.private-init.el`)

## Special Directories

**`vim/plugged/` (not in repo):**
- Purpose: vim-plug managed plugin installations
- Generated: Yes (by `:PlugInstall`)
- Committed: No (gitignored, recreated from `vim/vimrc` plugin list)

**`vim/tmp/` (not in repo):**
- Purpose: Vim temporary files (swap, backup, undo, view)
- Generated: Yes (auto-created by vim settings)
- Committed: No (gitignored)

**`emacs.d/straight/`:**
- Purpose: straight.el package manager data
- Generated: Partially (repos downloaded on first use)
- Committed: Only `versions/default.el` (version lock file)

**`zsh/base16-shell/` (submodule):**
- Purpose: Base16 color scheme shell scripts
- Generated: No (git submodule, forked repo)
- Committed: Yes (as git submodule reference)

**`zsh/zsh-history-substring-search/` (submodule):**
- Purpose: History substring search zsh plugin
- Generated: No (git submodule)
- Committed: Yes (as git submodule reference)

**Git Submodules:**
| Path | Repository |
|------|-----------|
| `zsh/zsh-history-substring-search` | `github.com/zsh-users/zsh-history-substring-search` |
| `zsh/base16-shell` | `github.com/abrampers/base16-shell` (fork) |

---

*Structure analysis: 2026-03-25*
