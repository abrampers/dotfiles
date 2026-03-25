# External Integrations

**Analysis Date:** 2026-03-25

## External Tools Configured

### Shell: Zsh
- **Config files:** `zshrc`, `zshenv`, `zsh/*.zsh`
- **Key integrations:**
  - Homebrew shell environment (`eval $(/opt/homebrew/bin/brew shellenv)`)
  - fzf completion and key bindings (sourced from Homebrew prefix)
  - pyenv, rbenv, nvm, gvm initialization
  - vcs_info for Git/Hg prompt display
  - Emacs vterm compatibility (`vterm_printf`, `vterm_prompt_end` functions in `zshrc`)
  - base16-shell color scheme management (`zsh/base16-shell/`, `zsh/colors.zsh`)
- **Custom completions:** `zsh/completions/_color`, `zsh/completions/_portool`
- **Local override:** `$HOME/.zshrc.local` and `$HOME/.zsh/host/$(hostname -s)` sourced if present

### Editor: Emacs (emacs-plus@30)
- **Config files:** `emacs.d/init.el`, `emacs.d/config.org` (literate config, 2168 lines)
- **Package manager:** straight.el with use-package
- **Key integrations:**
  - **LSP (Language Server Protocol)** via `lsp-mode` v9.0.0 — IDE features for Go, Ruby, Clojure, C/C++, Python, TypeScript, Lua, Erlang
  - **DAP (Debug Adapter Protocol)** via `dap-mode` — debugging with Go support configured
  - **Magit** — Git porcelain
  - **Projectile** — project management with Ivy completion
  - **GitHub Copilot** via `copilot.el` (`copilot-emacs/copilot.el` from GitHub)
  - **Org Mode** — task management, agenda, journaling, capture templates
  - **Org Roam** — Zettelkasten-style note-taking
  - **ox-hugo** — blog writing via Org to Hugo export
  - **Flycheck** — code diagnostics
  - **Tree-sitter** — syntax parsing (TypeScript, JSON, CSS)
  - **restclient** — HTTP REST client within Emacs
  - **browse-at-remote** — open code in GitHub/GitLab from Emacs
  - **exec-path-from-shell** — sync shell env vars into Emacs (copies GOPATH)
  - **cider** — Clojure REPL integration
  - **gotest** — Go test runner
  - **rspec-mode** — Ruby RSpec test runner

### Editor: Neovim/Vim
- **Config files:** `vim/vimrc`, `vim/init.vim`, `config/nvim/init.vim`
- **Plugin manager:** vim-plug (`~/.vim/plugged`)
- **Key integrations:**
  - **CoC.nvim** (Conquer of Completion) — LSP client
    - Extensions (`config/coc/extensions/package.json`): `coc-marketplace`, `coc-solargraph` (Ruby LSP), `coc-vimlsp`
  - **ALE** — Asynchronous Lint Engine
  - **fzf.vim** + **fzf-checkout.vim** — fuzzy finding in Vim
  - **vim-fugitive** + **fugitive-gitlab.vim** + **vim-rhubarb** — Git integration with GitHub/GitLab browse
  - **vim-go** — Go development (auto-updates binaries)
  - **vim-test** — test runner abstraction
  - **vim-grepper** — multi-tool search
  - **vim-projectionist** — project-aware file navigation
  - **NERDTree** + **nerdtree-git-plugin** — file tree explorer
  - **vim-airline** — status line with powerline fonts
  - **vim-clipper** — clipboard integration via clipper daemon
  - **vim-buf** + **vim-protobuf** — Protocol Buffers support
  - **vim-gitgutter** — Git diff markers in gutter
- **Language-specific ftplugins** (`vim/ftplugin/`): arc, c, go, haskell, java, javascript, json, markdown, objc, proto, python, ruby, rust, typescript, typescriptreact (26 total)
- **File type detection** (`vim/ftdetect/`): arc, bnd, ignore, jest, json, jsx, muttrc, npmbundler, ruby, spec, tsx, wikitext

### Editor: IdeaVim (JetBrains)
- **Config file:** `ideavimrc`
- **Emulated plugins:** surround, commentary, argtextobj, textobj-entire
- **Key actions:** GotoTest, FindInPath, GotoClass, GotoFile, RunCoverage, DebugClass, ToggleLineBreakpoint

### Terminal: tmux
- **Config files:** `tmux.conf`, `tmux/` directory
- **Prefix:** `C-a` (rebound from default `C-b`)
- **Key integrations:**
  - Nord color theme (`tmux/nord-tmux/nord.tmux`)
  - Prefix highlight plugin (`tmux/tmux-prefix-highlight/prefix_highlight.tmux`)
  - Clipper integration for system clipboard (`nc -U ~/.clipper.sock`)
  - vim-style copy mode with vi keybindings
  - Local override: `~/.tmux-local.conf` sourced if present
- **Terminal type:** `tmux-256color` with `xterm-256color` true color override

### Terminal Emulator: Alacritty
- **Config file:** `config/alacritty/alacritty.toml`
- **Font:** Source Code Pro for Powerline, size 14
- **Window:** 0.9 opacity, buttonless decorations, 10px padding

### Git Interface: tig
- **Config file:** `tigrc`
- **Customizations:** Ctrl-F/Ctrl-B for page up/down in main view

### Window Management: yabai + skhd + limelight
- **yabai config:** `config/yabai/yabairc`
  - BSP (Binary Space Partitioning) tiling layout
  - 10px gaps and padding
  - Mouse modifier: ctrl
  - Extensive floating rules for system apps (Finder, System Preferences, Bitwarden, etc.)
  - Signals for window focus on destroy (`scripts/yabai/windowFocusOnDestroy.sh`)
- **skhd config:** `config/skhd/skhdrc`
  - Hyper key (Shift+Cmd+Alt+Ctrl) for window management
  - App launchers: `rctrl+rcmd-t` (Alacritty), `rctrl+rcmd-e` (Emacs), `rctrl+rcmd-b` (Firefox)
  - Window focus, resize, swap, rotate, stack operations
  - Multi-monitor/space navigation
- **limelight config:** `config/limelight/limelightrc`
  - Active window border: red (`0xFFFF3657`)
  - Started/managed by yabai config

### Keyboard Customizer: Karabiner-Elements
- **Config file:** `config/karabiner/karabiner.json`
- Installed via Homebrew cask

### Browser: Tridactyl (Firefox Vim extension)
- **Config file:** `config/tridactyl/tridactylrc`
- Vim-like keybindings for Firefox (dd to close tab, J/K for tab navigation, etc.)
- Custom search URLs for Google Translate and Google Scholar
- Gruvbox dark theme from base16-tridactyl
- Gmail auto-enters ignore mode

### Cat Replacement: bat
- **Config file:** `config/bat/config`
- Theme: base16
- Style: numbers, changes, header
- Aliased as `cat` in `zsh/aliases.zsh`

### AI Coding Tool: OpenCode
- **Config files:** `config/opencode/opencode.jsonc`, `config/opencode/tui.json`, `config/opencode/package.json`
- **Provider:** Google (via Antigravity proxy)
- **Models configured:**
  - Gemini 3.1 Pro (1M context)
  - Gemini 3 Flash (1M context, multiple thinking levels)
  - Claude Sonnet 4.6 (200K context)
  - Claude Sonnet 4.6 Thinking (200K context, configurable thinking budget)
  - Claude Opus 4.5 Thinking (200K context, configurable thinking budget)
- **Theme:** Nord
- **Permission:** Read access to `~/.config/opencode/get-shit-done/*`
- **Dependency:** `@opencode-ai/plugin` v1.3.2

## Zsh Plugin Dependencies

**Sourced in `zshrc`:**

| Plugin | Path | Source |
|--------|------|--------|
| zsh-autosuggestions | `zsh/zsh-autosuggestions/` | Vendored directory |
| zsh-syntax-highlighting | `zsh/zsh-syntax-highlighting/` | Vendored directory |
| zsh-history-substring-search | `zsh/zsh-history-substring-search/` | Git submodule (`zsh-users/zsh-history-substring-search`) |
| plugin-osx | `zsh/plugin-osx/osx-aliases.plugin.zsh` | Vendored directory |
| brew-zsh-plugin | `zsh/brew-zsh-plugin/brew.plugin.zsh` | Vendored directory |
| git-aliases | `zsh/git-aliases/git-aliases.zsh` | Vendored directory (oh-my-zsh derived) |
| base16-shell | `zsh/base16-shell/` | Git submodule (`abrampers/base16-shell`, personal fork) |

**Custom Zsh modules:**
- `zsh/aliases.zsh` — Unix/Vim aliases, bat as cat
- `zsh/colors.zsh` — base16 color scheme switching (`color` function)
- `zsh/exports.zsh` — environment variables
- `zsh/path.zsh` — PATH construction
- `zsh/functions.zsh` — utility functions (`jdk` version switcher)
- `zsh/bin/diff-highlight` — custom diff highlighting binary

## Vim Plugin Dependencies (vim-plug)

**Declared in `vim/vimrc` (identical to `vim/init.vim`):**

| Category | Plugin | Lazy Loading |
|----------|--------|--------------|
| **LSP/Completion** | `neoclide/coc.nvim` | No |
| **Linting** | `dense-analysis/ale` | No |
| **Git** | `tpope/vim-fugitive` | No |
| **Git** | `shumphrey/fugitive-gitlab.vim` | No |
| **Git** | `tpope/vim-rhubarb` | No |
| **Git** | `airblade/vim-gitgutter` | No |
| **Fuzzy Finding** | `junegunn/fzf.vim` | No |
| **Fuzzy Finding** | `stsewd/fzf-checkout.vim` | No |
| **File Tree** | `preservim/nerdtree` | On command |
| **File Tree** | `Xuyuanp/nerdtree-git-plugin` | On command |
| **Status Line** | `vim-airline/vim-airline` | No |
| **Status Line** | `vim-airline/vim-airline-themes` | No |
| **Go** | `fatih/vim-go` | For go, gomod |
| **Ruby** | `tpope/vim-rbenv` | For ruby |
| **Ruby** | `tpope/vim-bundler` | For ruby |
| **Ruby** | `tpope/vim-rails` | For ruby |
| **Ruby** | `tpope/vim-rake` | For ruby |
| **Ruby** | `vim-ruby/vim-ruby` | For ruby |
| **Protobuf** | `uarun/vim-protobuf` | For proto |
| **Protobuf** | `bufbuild/vim-buf` | No |
| **JSON** | `elzr/vim-json` | For json |
| **Markdown** | `plasticboy/vim-markdown` | For markdown |
| **Zsh** | `chrisbra/vim-zsh` | No |
| **Editing** | `tpope/vim-surround` | No |
| **Editing** | `tpope/vim-commentary` | No |
| **Editing** | `tpope/vim-repeat` | No |
| **Editing** | `tpope/vim-eunuch` | No |
| **Editing** | `jiangmiao/auto-pairs` | No |
| **Editing** | `duggiefresh/vim-easydir` | No |
| **Text Objects** | `vim-scripts/argtextobj.vim` | No |
| **Text Objects** | `kana/vim-textobj-user` | No |
| **Text Objects** | `kana/vim-textobj-entire` | No |
| **Text Objects** | `thinca/vim-textobj-comment` | No |
| **Text Objects** | `nelstrom/vim-textobj-rubyblock` | For ruby |
| **Themes** | `chriskempson/base16-vim` | No |
| **Themes** | `arcticicestudio/nord-vim` | No |
| **Themes** | `morhetz/gruvbox` | No |
| **Testing** | `vim-test/vim-test` | On command |
| **Search** | `wincent/loupe` | No |
| **Search** | `mhinz/vim-grepper` | On command |
| **Navigation** | `airblade/vim-rooter` | No |
| **Navigation** | `tpope/vim-projectionist` | No |
| **UI** | `Yggdroot/indentLine` | No |
| **UI** | `kshenoy/vim-signature` | No |
| **UI** | `mbbill/undotree` | No |
| **UI** | `junegunn/goyo.vim` | No |
| **Wincent Suite** | `wincent/pinnacle`, `wincent/replay`, `wincent/scalpel`, `wincent/terminus`, `wincent/vim-clipper`, `wincent/vim-docvim` | No |
| **Dispatch** | `tpope/vim-dispatch` | No |

## Emacs Package Dependencies (straight.el + use-package)

**Declared in `emacs.d/config.org`:**

| Category | Package | Notes |
|----------|---------|-------|
| **Evil (Vi emulation)** | evil, evil-collection, evil-org, evil-commentary, evil-surround, evil-smartparens | Core editing model |
| **Completion** | ivy, counsel, swiper, ivy-rich, ivy-prescient, ivy-hydra, company | Completion framework |
| **LSP** | lsp-mode (v9.0.0), lsp-ui, lsp-treemacs, lsp-ivy, lsp-origami | IDE features |
| **Debug** | dap-mode | Debug adapter protocol (Go configured) |
| **Git** | magit, git-gutter, browse-at-remote | Git integration |
| **Project** | projectile, counsel-projectile | Project management |
| **Diagnostics** | flycheck | Code checking |
| **AI** | copilot (copilot-emacs/copilot.el) | GitHub Copilot |
| **Org** | org-bullets, visual-fill-column, org-wild-notifier, org-roam, ox-hugo | Org mode ecosystem |
| **Themes** | doom-themes, gruvbox-theme, material-theme, night-owl-theme, nord-theme (active), ayu-theme, seti-theme | Visual themes |
| **UI** | doom-modeline, nerd-icons, which-key, command-log-mode, hydra | UI enhancements |
| **Languages** | go-mode, go-playground, gotest, clojure-mode, cider, typescript-mode, tree-sitter, tree-sitter-langs, tsi, lua-mode, erlang, groovy-mode, jsonnet-mode, protobuf-mode, cmake-font-lock, pyenv-mode, rspec-mode, yaml-mode | Language support |
| **File Management** | dired-single, dired-hide-dotfiles, dired-sidebar, vscode-icon | File browsing |
| **Editing** | smartparens, rainbow-delimiters, undo-tree | Code editing |
| **Writing** | ox-hugo | Blog writing |
| **Utilities** | exec-path-from-shell, no-littering, auto-package-update, xterm-color, restclient, makefile-executor, unicode-fonts, general, helpful, vterm | Various utilities |

## Git Submodules

| Submodule Path | Repository | Purpose |
|----------------|-----------|---------|
| `zsh/zsh-history-substring-search` | `github.com/zsh-users/zsh-history-substring-search` | Fish-like history substring search for Zsh |
| `zsh/base16-shell` | `github.com/abrampers/base16-shell` (personal fork) | Base16 color scheme scripts for shell |
| `.vim/pack/bundle/opt/vim-go` | `github.com/fatih/vim-go` | **Legacy** — Go Vim plugin (now managed by vim-plug) |
| `.vim/pack/bundle/opt/ferret` | `github.com/wincent/ferret` | **Legacy** — Multi-file search (now using vim-grepper) |
| `.vim/pack/bundle/opt/base16-vim` | `github.com/chriskempson/base16-vim` | **Legacy** — Base16 color scheme for Vim (now via vim-plug) |

## External Services & APIs

**GitHub Copilot:**
- Integrated in Emacs via `copilot.el`
- Requires GitHub authentication (handled by copilot.el login flow)

**OpenCode AI Models (via Antigravity proxy):**
- Google Gemini 3.1 Pro, Gemini 3 Flash
- Anthropic Claude Sonnet 4.6, Claude Opus 4.5
- Configured in `config/opencode/opencode.jsonc`

**Clipper (clipboard daemon):**
- Used by tmux (`tmux.conf`) and Vim (`vim-clipper`) for remote clipboard sync
- Communicates via Unix socket: `~/.clipper.sock`

**GPG:**
- `GPG_TTY=$(tty)` exported in `zsh/exports.zsh`
- Used for git commit signing

## System Dependencies

**Must be installed for full functionality:**

| Tool | Install Method | Required By |
|------|---------------|-------------|
| Homebrew | Manual or Ansible | Everything |
| zsh | Pre-installed (macOS) | Shell |
| rcm | `brew install rcm` | Dotfile management |
| ansible | `pip install ansible` | Provisioning |
| neovim | `brew install neovim` | Editor |
| emacs-plus@30 | `brew install emacs-plus@30` | Editor |
| tmux | `brew install tmux` | Terminal multiplexer |
| alacritty | `brew install --cask alacritty` | Terminal emulator |
| fzf | `brew install fzf` | Fuzzy finder (shell + vim) |
| ripgrep | `brew install ripgrep` | Search (fzf backend, vim-grepper) |
| bat | `brew install bat` | Cat replacement |
| tig | `brew install tig` | Git TUI |
| jq | `brew install jq` | JSON processing (yabai scripts) |
| yabai | `brew install yabai` | Window manager |
| skhd | `brew install skhd` | Hotkey daemon |
| karabiner-elements | `brew install --cask karabiner-elements` | Keyboard customizer |
| pyenv | `brew install pyenv` | Python version management |
| pyenv-virtualenv | `brew install pyenv-virtualenv` | Python virtualenvs |
| rbenv | `brew install rbenv` | Ruby version management |
| nvm | `brew install nvm` | Node.js version management |
| go | `brew install go` | Go language |
| erlang | `brew install erlang` | Erlang language |
| rebar3 | `brew install rebar3` | Erlang build tool |
| leiningen | `brew install leiningen` | Clojure build tool |
| clojure-lsp-native | `brew install clojure-lsp-native` | Clojure LSP |
| cmake | `brew install cmake` | Build system |
| grpcurl | `brew install grpcurl` | gRPC client |
| temurin@8 | `brew install --cask temurin@8` | JDK 8 |
| coreutils | Manual (for `gls`) | Emacs dired (macOS) |
| stats | `brew install stats` | System monitor menubar app |
| Source Code Pro for Powerline | Homebrew cask | Alacritty + Vim font |
| SauceCodePro Nerd Font Mono | Homebrew cask | Emacs font |

**Language Servers (required for LSP features):**
- `gopls` — Go (auto-detected from `$GOPATH/bin/gopls`)
- `clojure-lsp` — Clojure (installed via Homebrew)
- `erlang_ls` — Erlang (built from source in Ansible)
- `ccls` — C/C++ (manual install required)
- `solargraph` — Ruby (via coc-solargraph)
- `typescript-language-server` — TypeScript (`npm install -g typescript-language-server typescript`)
- `pyls` — Python (via pyenv pip)

## Helper Scripts

**Yabai window management scripts** (`scripts/yabai/`):
- `moveWindowLeftAndFollowFocus.sh` — Move window to left display
- `moveWindowRightAndFollowFocus.sh` — Move window to right display
- `switchAndFocusSIP.sh` — Switch spaces with SIP enabled
- `toggleStackLayout.sh` — Toggle between BSP and stack layout
- `windowFocusOnDestroy.sh` — Auto-focus after window close

**macOS automation scripts** (`scripts/`):
- `gojek-integration-vpn.app/` — Automator app for VPN
- `gojek-production-vpn.app/` — Automator app for VPN
- `gojek-totp.app/` — Automator app for TOTP

## Environment Configuration

**Required env vars** (set in `zsh/exports.zsh` and `zsh/path.zsh`):
- `EDITOR` — set to `nvim`
- `KUBE_EDITOR` — set to `nvim`
- `PYENV_ROOT` — set to `$HOME/.pyenv`
- `NVM_DIR` — set to `$HOME/.nvm`
- `FZF_DEFAULT_COMMAND` — set to use ripgrep
- `FZF_DEFAULT_OPTS` — reverse layout, inline info
- `GPG_TTY` — set to current tty
- `LANG`, `LANGUAGE`, `LC_ALL` — set to `en_US.UTF-8`

**Secret/private configuration (gitignored):**
- `vars/custom.yml` — Ansible variables (gitignored via `vars/*.yml`)
- `$HOME/.zshrc.local` — local shell overrides
- `$HOME/.tmux-local.conf` — local tmux overrides
- `$HOME/.vim/vimrc.local` — local Vim overrides
- `$HOME/.emacs.d/private-init.el` — local Emacs overrides (sample: `emacs.d/sample.private-init.el`)

## Color Scheme Ecosystem

The Nord theme is used consistently across tools:
- **Emacs:** `(load-theme 'nord t)` in `emacs.d/config.org`
- **Vim:** `arcticicestudio/nord-vim` plugin
- **tmux:** `tmux/nord-tmux/nord.tmux`
- **OpenCode TUI:** `"theme": "nord"` in `config/opencode/tui.json`
- **Base16 support:** Managed via `zsh/base16-shell/` and `zsh/colors.zsh` with a `color` function for switching themes

---

*Integration audit: 2026-03-25*
