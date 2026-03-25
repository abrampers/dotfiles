# Coding Conventions

**Analysis Date:** 2026-03-25

## Naming Patterns

**Files:**
- Zsh config files use lowercase with `.zsh` extension: `aliases.zsh`, `functions.zsh`, `exports.zsh`, `path.zsh`, `colors.zsh`
- Vim plugin config files use lowercase with `.vim` extension, named after the plugin they configure: `airline.vim`, `nerdtree.vim`, `fzf.vim`
- Vim mapping files are organized by mode: `normal.vim`, `visual.vim`, `leader.vim`, `command.vim`
- Shell scripts use camelCase for yabai helpers: `moveWindowLeftAndFollowFocus.sh`, `switchAndFocusSIP.sh`, `toggleStackLayout.sh`
- XDG config directories use lowercase tool names: `config/alacritty/`, `config/skhd/`, `config/yabai/`

**Functions (Zsh):**
- Private hook functions use hyphen-prefix naming: `-set-tab-and-window-title()`, `-update-window-title-precmd()`, `-record-start-time()`, `-report-start-time()`
- VCS info hook functions use `+vi-` prefix per zsh convention: `+vi-hg-bookmarks()`, `+vi-git-untracked()`
- Utility functions use lowercase with no prefix: `luma()`, `color()`, `jdk()`
- Anonymous functions use `function () { }` for scoping: see `zshrc` lines 173, 134 in `colors.zsh`
- Inner/nested functions use double-underscore prefix: `__color()` in `zsh/colors.zsh`
- All zsh hook functions use `emulate -L zsh` as the first line for local option scoping

**Functions (Vim):**
- Autoload functions use namespace pattern: `wincent#commands#find()`, `wincent#autocmds#mkview()`
- Script-local functions use `s:` prefix: `s:CheckColorScheme()`, `s:Open()`, `s:get_spell_settings()`
- Filetype mapping functions use module pattern: `ftmappings#go#vim_go_maps()`, `mappings#coc#SetupMappings()`
- Global blacklist variables use `g:Wincent` prefix: `g:WincentColorColumnFileTypeBlacklist`, `g:WincentCursorlineBlacklist`

**Variables (Zsh):**
- Global state hash table: `__ABRAMPERS` (uppercase with double-underscore prefix)
- Environment variables: `UPPERCASE_WITH_UNDERSCORES` (standard convention)
- Local variables in functions: use `local` keyword with `UPPER_CASE` names for computed values: `local TMUXING`, `local LVL`, `local SUFFIX`
- Color function locals use `COLOR_` prefix: `COLOR_HEX`, `COLOR_HEX_RED`, `COLOR_DEC_RED`, `COLOR_LUMA`

**Variables (Vim):**
- Plugin config uses `g:` scope with plugin-prefixed names: `g:go_fmt_command`, `g:NERDTreeWinSize`
- Script-local uses `s:` scope: `s:vimrc_local`, `s:config_file`
- Buffer-local uses `b:` scope for filetype-specific: `b:ale_linters`, `b:ale_fixers`

**Aliases (Zsh):**
- Git aliases follow alphabetical organization sorted by git subcommand: `ga='git add'`, `gb='git branch'`, `gc='git commit -v'`
- Git compound aliases build from first letters: `gaa='git add --all'`, `gcmsg='git commit -m'`
- Unix aliases override defaults with preferred flags: `ls='ls -G'`, `grep='grep --color'`, `mkdir='mkdir -p'`
- Global aliases (pipe shortcuts) use uppercase single chars: `-g G='| grep'`, `-g M='| less'`, `-g ONE="| awk '{ print \$1}'"`
- Tool replacement aliases: `cat='bat'`, `vim="$(brew --prefix)/bin/vim"`
- Humorous aliases: `:w="echo this isn\'t vim"`, `:q='exit'`

**Types (Emacs Lisp):**
- Custom variables use `abram/` prefix: `abram/blog-content-org-file`, `abram/org-directory`, `abram/org-roam-directory`

## Code Style

**Formatting:**
- No automated formatter (no `.prettierrc`, `.editorconfig`, or similar)
- Indentation: 2 spaces in Vim/Zsh config files
- Go files: tabs with width 4 (set in `vim/ftplugin/go.vim`)
- Ruby files: 2 spaces (set in `vim/ftplugin/ruby.vim`)
- Default Vim: 2-space soft tabs (`shiftwidth=2`, `tabstop=2`, `expandtab` in `vim/plugin/settings.vim`)

**Linting:**
- ALE (Asynchronous Lint Engine) for Vim: `dense-analysis/ale` plugin in `vim/vimrc`
- Proto files use `buf-lint` via ALE: `vim/ftplugin/proto.vim`
- No global shell linter configured (no shellcheck integration)

## Comment Style

**Zsh (`zshrc`, `zsh/*.zsh`):**
- Section headers use `#` with blank lines above and below:
  ```zsh
  #
  # Section Name
  #
  ```
- Inline comments explain "why" not "what": `# Suppress unwanted Homebrew-installed stuff.`
- URL references included for sources: `# See: https://github.com/mathiasbynens/dotfiles/issues/687`
- `[default]` annotation in setopt lines marks options that are default: `setopt AUTO_CD  # [default] .. is shortcut for cd ..`
- Block comments for multi-line explanations use `#` prefix on each line

**Vim (`vim/**/*.vim`):**
- Use `"` for comments (Vim standard)
- Setting comments use inline explanation aligned with padding: `set autoindent  " maintain indent of current line`
- Unicode characters documented with name and code: `set listchars=nbsp:⦸  " CIRCLED REVERSE SOLIDUS (U+29B8, UTF-8: E2 A6 B8)`
- Mnemonic hints in parentheses: `" (mnemonic: path; useful when...)`
- TODO/FIXME markers present: `" TODO: make this async` in `vim/autoload/wincent/commands.vim`

**Tmux (`tmux.conf`):**
- Comments explain key context: `# normally used for last-window`
- Section grouping with comment blocks
- Reference to documentation: `# Bindings: - to see current bindings: tmux list-keys`

**Shell scripts (`scripts/yabai/*.sh`):**
- Sparse commenting, primarily for context: `# $1 is the first argument passed in (window id).`
- Operator explanations: `# (-n) >> != null`, `# -z >> true if it's null`

## Configuration Organization Patterns

**Zsh configuration is split by concern across multiple files:**
- `zshenv` → sources `exports.zsh` and `path.zsh` (loaded for all shells)
- `zshrc` → main interactive config with sections: Global, Completion, Prompt, History, Options, Plugins, Bindings, Hooks, Source variables, Third-Party
- `zsh/exports.zsh` → environment variable exports
- `zsh/path.zsh` → PATH construction (unsets and rebuilds from scratch)
- `zsh/aliases.zsh` → command aliases
- `zsh/functions.zsh` → utility functions
- `zsh/colors.zsh` → color scheme management (base16)
- Local override: `~/.zshrc.local` and `~/.zsh/host/$(hostname -s)` are sourced if they exist

**Vim configuration is split by concern across directories:**
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

**Tmux configuration:**
- `tmux.conf` → monolithic config file (170 lines)
- `tmux/` → plugin submodules (nord-tmux, tmux-prefix-highlight)
- Local override: `~/.tmux-local.conf` sourced if it exists (via `source-file -q`)

**XDG Config (`config/`):**
- Each tool gets its own subdirectory: `config/alacritty/`, `config/nvim/`, `config/skhd/`, etc.
- Maps to `~/.config/` via rcm symlinks
- Neovim init delegates entirely to Vim config: `config/nvim/init.vim` → sources `~/.vim/vimrc`

## Local Override Pattern

A consistent pattern across tools enables machine-specific customization without modifying tracked files:

- **Zsh:** `~/.zshrc.local` and `~/.zsh/host/$(hostname -s)` — `zshrc` line 452-457
- **Vim:** `~/.vim/vimrc.local` — `vim/vimrc` line 38-41
- **Tmux:** `~/.tmux-local.conf` — `tmux.conf` line 170
- **Vim local-settings:** `vim/plugin/local-settings.vim` is gitignored — `vim/.gitignore`

Use this pattern when adding new tool configs. Always source local overrides at the end of the main config.

## Keybinding Conventions

**Cross-Tool Vim-Style Navigation:**
- `h/j/k/l` for directional movement used consistently:
  - **Tmux:** `prefix-h/j/k/l` for pane navigation — `tmux.conf` lines 21-28
  - **Vim:** `<C-h>/<C-j>/<C-k>/<C-l>` for window movement — `vim/plugin/mappings/normal.vim` lines 12-15
  - **skhd/yabai:** `hyper-h/j/k/l` for window focus — `config/skhd/skhdrc` lines 22-25
  - **Tridactyl:** `J/K` for tab navigation — `config/tridactyl/tridactylrc`
  - **Tig:** `<Ctrl-f>/<Ctrl-b>` for page scroll — `tigrc`
  - **IdeaVim:** standard vim motions — `ideavimrc`

**Leader Keys:**
- **Vim:** `<Space>` as leader, `,` as local leader — `vim/vimrc` lines 5-6
- **IdeaVim:** `<Space>` as leader — `ideavimrc` line 7
- Leader mappings organized by purpose:
  - `<Leader>f` → find/search (fzf Rg in Vim, FindInPath in IdeaVim)
  - `<Leader>q` → quit
  - `<Leader><Leader>` → toggle last buffer (Vim)
  - `<Leader><CR>` → re-source vimrc
  - `<LocalLeader>w` → write
  - `<LocalLeader>a` → alternate file (projectionist)
  - `<LocalLeader>q` → quit window

**Tmux Prefix:**
- `C-a` (remapped from default `C-b`) — `tmux.conf` line 3
- `C-a C-a` → toggle last window (like vim `<C-^>`)
- Intuitive splits: `|` for horizontal, `-` for vertical — `tmux.conf` lines 50-51
- `prefix-r` → reload config — `tmux.conf` line 168

**Test Runners (Vim):**
- `tt` → TestNearest, `tf` → TestFile, `ts` → TestSuite, `tl` → TestLast, `tv` → TestVisit — `vim/plugin/vim-test.vim`
- Same pattern in IdeaVim: `tt` → RunCoverage, `td` → DebugClass, `ts` → Run — `ideavimrc`

**Window Management (skhd/yabai):**
- `hyper` key (Shift+Cmd+Alt+Ctrl) as primary modifier — `config/skhd/skhdrc`
- `rctrl+rcmd` for opening applications — `config/skhd/skhdrc` lines 13-15
- `shift+alt` for resizing — `config/skhd/skhdrc` lines 31-34
- `hyper-f` for fullscreen toggle — `config/skhd/skhdrc` line 28

## Plugin Management Conventions

**Vim:**
- vim-plug for plugin management — `vim/vimrc` lines 52-114 (`call plug#begin()` / `call plug#end()`)
- Lazy loading via `'on'` (commands) and `'for'` (filetypes): `Plug 'fatih/vim-go', { 'for': ['go', 'gomod'] }`
- Some legacy git submodules still referenced in `.gitmodules` for opt packages under `vim/pack/bundle/opt/`
- CoC extensions managed separately in `config/coc/`

**Zsh:**
- Plugins stored as directories under `zsh/`: `zsh/zsh-autosuggestions/`, `zsh/zsh-syntax-highlighting/`, etc.
- Some managed as git submodules (listed in `.gitmodules`), some appear to be manually placed
- Sourced explicitly in `zshrc` lines 242-249
- No plugin manager (no oh-my-zsh, no zinit) — direct sourcing

**Tmux:**
- Plugins as git submodules under `tmux/`: `tmux/nord-tmux/`, `tmux/tmux-prefix-highlight/`
- Loaded via `run-shell` commands in `tmux.conf` lines 61, 66

**Emacs:**
- `straight.el` for package management (indicated by `emacs.d/straight/` directory)
- Literate config via org-babel: `emacs.d/init.el` loads `config.org`

## Dotfile Symlink Management

**Tool:** rcm (RCM - RC file management) — installed and configured via Ansible
- `rcrc` defines exclusions: `EXCLUDES="*.md *.png *.jpg install.sh dotfiles.yml dotfiles.yaml tags* sample*"`
- Files/directories at repo root become dotfiles in `$HOME` (e.g., `zshrc` → `~/.zshrc`)
- `config/` directory maps to `~/.config/` (XDG convention)
- `vim/` maps to `~/.vim/`
- `zsh/` maps to `~/.zsh/`
- `emacs.d/` maps to `~/.emacs.d/`

## Import/Source Organization

**Zsh Source Order:**
1. `zshenv` (all shells) → `exports.zsh`, `path.zsh`
2. `zshrc` (interactive shells):
   - Global state initialization
   - Platform-specific hacks
   - Homebrew shellenv
   - Completion setup
   - Prompt configuration
   - History settings
   - Shell options (`setopt`)
   - Plugin sourcing (autosuggestions, syntax highlighting, substring search, osx, brew, git-aliases)
   - Key bindings
   - Hooks (precmd, preexec, chpwd)
   - Custom sources (aliases, colors, functions)
   - Local/host overrides
   - Third-party tool initialization (jdk, nvm, rbenv, fzf, pyenv, gvm)

**Vim Evaluation Order:**
1. `vimrc` / `init.vim` → leader keys, plugin globals, vim-plug declarations
2. `plugin/` directory (alphabetical) → settings, mappings, plugin config
3. Plugin code from vim-plug
4. `after/plugin/` → post-plugin overrides (colors, highlight tweaks)

## Error Handling

**Zsh Patterns:**
- Guard command existence before use: `if command -v dry &> /dev/null; then` — `zshrc` line 51
- Conditional platform checks: `if [ "$(uname)" = "Darwin" ]; then` — `zshrc` line 16
- Test file existence before sourcing: `test -f $LOCAL_RC && source $LOCAL_RC` — `zshrc` line 454
- Silent failures for optional tools: `[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"` — `zshrc` line 493

**Vim Patterns:**
- Feature detection: `if has('nvim')`, `if exists('+colorcolumn')`, `if has('termguicolors')`
- File readability checks: `if filereadable(s:vimrc_local)` — `vim/vimrc` line 39
- Try/catch blocks for error handling: `try ... catch /\<E186\>/ ... endtry` — `vim/autoload/wincent/autocmds.vim` line 33
- Executable checks: `if !executable('open')` — `vim/autoload/wincent/commands.vim` line 9

**Shell Scripts:**
- Minimal error handling; most yabai scripts use `||` fallback pattern: `yabai -m window --display prev || yabai -m window --display last`
- No `set -e` or `set -u` in shell scripts (scripts use `#!/bin/dash` or `#!/bin/bash`)

## Module/File Design

**Exports Pattern:**
- Zsh files do not use explicit exports for functions/aliases — they rely on being sourced into the main shell
- Vim autoload files are namespaced and lazy-loaded via the `autoload/wincent/` directory structure
- Each Vim plugin config is isolated in its own file under `vim/plugin/`

**Separation of Concerns:**
- Settings (options) are never mixed with mappings
- Plugin configuration is one file per plugin
- Filetype-specific config lives in `ftplugin/` or `after/ftplugin/`
- Custom commands are separated from mappings: `vim/plugin/commands.vim` vs `vim/plugin/mappings/`

---

*Convention analysis: 2026-03-25*
