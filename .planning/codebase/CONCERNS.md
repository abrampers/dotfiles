# Codebase Concerns

**Analysis Date:** 2026-03-25

## Tech Debt

**Entirely Commented-Out Vim Autocmds:**
- Issue: The entire `vim/plugin/autocmds.vim` file (74 lines) is commented out. This is dead code that served as the window focus/blur/cursorline management system. It references `wincent#autocmds#*` functions that still exist in `vim/autoload/wincent/autocmds.vim`.
- Files: `vim/plugin/autocmds.vim`
- Impact: Confusing for maintenance; unclear whether this was intentionally disabled or accidentally broken. The autoload functions it references are still shipped but never called.
- Fix approach: Either restore the autocmds or delete both the commented file and the unused autoload functions.

**Duplicate NVM Initialization:**
- Issue: NVM is initialized twice in `zshrc` - once at line 466 via `source $(brew --prefix nvm)/nvm.sh` and again at lines 486-487 via the Intel-path `/usr/local/opt/nvm/nvm.sh`. This causes redundant evaluation on every shell startup.
- Files: `zshrc` (lines 466 and 486-487)
- Impact: Slower shell startup; potential conflicts if two different nvm versions get loaded.
- Fix approach: Remove the duplicate. Keep only the `$(brew --prefix nvm)/nvm.sh` version which is architecture-agnostic.

**Duplicate rbenv Initialization:**
- Issue: `rbenv init -` is called twice in `zshrc` - at line 469 and again at line 490. Additionally, `$HOME/.rbenv/bin` is added to PATH at line 489 even though rbenv from Homebrew doesn't use that path.
- Files: `zshrc` (lines 469, 489-491)
- Impact: Slower shell startup from redundant `eval "$(rbenv init -)"` calls.
- Fix approach: Consolidate to a single rbenv initialization block.

**Hardcoded Ruby Version in Vim Config:**
- Issue: `g:ruby_host_prog` and `g:ruby_path` are hardcoded to version `2.7.1` in `vim/vimrc` (lines 10, 13). This will break when the Ruby version changes via rbenv.
- Files: `vim/vimrc` (lines 10, 13)
- Impact: Neovim Ruby provider breaks silently when Ruby version is updated.
- Fix approach: Use dynamic path resolution, e.g., `$HOME . '/.rbenv/shims/neovim-ruby-host'` instead of a version-specific path.

**Outdated Homebrew Install URL in Ansible Playbook:**
- Issue: The Homebrew installation command in `dotfiles.yml` (line 33) uses the deprecated Ruby-based installer: `/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`. The current installer uses `bash` and a different URL.
- Files: `dotfiles.yml` (line 33)
- Impact: Fresh system setup via Ansible will fail if Homebrew needs to be installed.
- Fix approach: Update to `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`.

**Emacs-Plus Version Mismatch in Ansible:**
- Issue: `dotfiles.yml` installs `emacs-plus@30` (line 113) but creates symlinks for `emacs-plus@29` (lines 119, 129). The symlinks will point to a non-existent path.
- Files: `dotfiles.yml` (lines 113, 119, 129)
- Impact: The Emacs.app symlink in `/Applications/` will be broken after running the playbook.
- Fix approach: Update the symlink paths from `@29` to `@30` to match the installed version.

**Outdated Python Path in PATH Configuration:**
- Issue: `zsh/path.zsh` includes hardcoded paths to Python 3.6 and 2.7 framework installations (lines 23-24) that are likely no longer present. The system uses pyenv for Python management.
- Files: `zsh/path.zsh` (lines 23-24)
- Impact: No functional impact (paths just won't exist), but adds clutter and confusion about which Python is intended.
- Fix approach: Remove the framework Python paths since pyenv manages Python versions.

**Stale `.gitmodules` Entries:**
- Issue: `.gitmodules` contains entries for paths that don't exist in the current repo structure: `.zsh/zsh-history-substring-search` and `.vim/pack/bundle/opt/*` (vim-go, ferret, base16-vim). The actual submodules are at `zsh/zsh-history-substring-search` and `zsh/base16-shell`.
- Files: `.gitmodules` (lines 1-12)
- Impact: Git submodule operations may produce warnings or confusion. The `.vim/pack/bundle/opt/` submodules reference a legacy Vim native package approach that was replaced by vim-plug.
- Fix approach: Remove the stale submodule entries and clean up with `git rm --cached` for any orphaned references.

**Deprecated `brew upgrade --all` and `brew cask cleanup`:**
- Issue: The `update()` function in `zsh/plugin-osx/osx-aliases.plugin.zsh` (line 38) uses `brew upgrade --all` and `brew cask cleanup` which are deprecated. Modern Homebrew uses `brew upgrade` (upgrades all by default) and `brew cleanup`.
- Files: `zsh/plugin-osx/osx-aliases.plugin.zsh` (line 38)
- Impact: The `update` command may fail or produce deprecation warnings.
- Fix approach: Replace with `brew upgrade` and remove `brew cask cleanup`.

**Deprecated `urlencode` Alias Uses Python 2:**
- Issue: The `urlencode` alias in `zsh/plugin-osx/osx-aliases.plugin.zsh` (line 89) uses `python -c` with `urllib` (Python 2 syntax). macOS no longer ships Python 2.
- Files: `zsh/plugin-osx/osx-aliases.plugin.zsh` (line 89)
- Impact: The `urlencode` alias is broken.
- Fix approach: Update to `python3 -c "import sys, urllib.parse; print(urllib.parse.quote_plus(sys.argv[1]))"`.

**brew-zsh-plugin `repair` Resets to `origin/master`:**
- Issue: The `brew repair` function in `zsh/brew-zsh-plugin/brew.plugin.zsh` (line 21) runs `git reset --hard origin/master`. Homebrew's default branch is now `main`.
- Files: `zsh/brew-zsh-plugin/brew.plugin.zsh` (line 21)
- Impact: `brew repair` will fail or produce unexpected results.
- Fix approach: Update to `origin/main` or use `origin/HEAD`.

## Security Considerations

**Company-Specific Automator Scripts in Public Repo:**
- Risk: Three Automator `.app` bundles (`scripts/gojek-integration-vpn.app`, `scripts/gojek-production-vpn.app`, `scripts/gojek-totp.app`) and Karabiner keybindings (`config/karabiner/karabiner.json`) reference company-specific VPN and TOTP workflows. The `gojek-production-vpn.app` wflow reveals it runs `~/bin/gojek-totp | pbcopy` and invokes a Shortcuts automation for `gojek-production-vpn`.
- Files: `scripts/gojek-*.app/`, `config/karabiner/karabiner.json`
- Current mitigation: No secrets are directly embedded (TOTP binary is external at `~/bin/gojek-totp`).
- Recommendations: Consider moving company-specific scripts to a private repo or `.gitignore`'d directory. The scripts reveal corporate infrastructure details (VPN names, tooling) that shouldn't be public.

**Hardcoded Homebrew Path Assumes Apple Silicon:**
- Risk: `zshrc` line 56 hardcodes `eval $(/opt/homebrew/bin/brew shellenv)` which only works on Apple Silicon Macs. Intel Macs use `/usr/local/bin/brew`.
- Files: `zshrc` (line 56)
- Current mitigation: None. The `if [ "$(uname)" = "Darwin" ]` block above (line 16) doesn't guard this line.
- Recommendations: Wrap in architecture detection or use a conditional like `if [ -f /opt/homebrew/bin/brew ]; then ... elif [ -f /usr/local/bin/brew ]; then ... fi`.

**Private Submodule Uses SSH URL:**
- Risk: `zsh/base16-shell` submodule uses `git@github.com:abrampers/base16-shell.git` (SSH). This will fail on systems without the correct SSH key configured.
- Files: `.gitmodules` (lines 16-18)
- Current mitigation: None.
- Recommendations: Use HTTPS URL unless there's a specific reason for SSH, or document the SSH key requirement.

**`.gitignore` Doesn't Protect Sensitive Config:**
- Risk: The root `.gitignore` only excludes `vars/*.yml`. There's no protection against accidentally committing `.env` files, credential files, or other sensitive data that might appear during development.
- Files: `.gitignore`
- Current mitigation: Minimal. `vim/.gitignore` excludes `vimrc.local` and `local-settings.vim`.
- Recommendations: Add common patterns like `.env`, `*.pem`, `*.key`, `credentials*`, `secrets*` to root `.gitignore`.

## Performance Bottlenecks

**Slow Shell Startup from `brew --prefix` Calls:**
- Problem: Multiple `$(brew --prefix)` invocations during shell startup in `zshrc` (lines 63, 466, 473, 477) and `zsh/aliases.zsh` (lines 18, 23). Each `brew --prefix` call takes ~100-200ms.
- Files: `zshrc` (lines 63, 466, 473, 477), `zsh/aliases.zsh` (lines 18, 23)
- Cause: `brew --prefix` spawns a subprocess every time it's called.
- Improvement path: Cache the result once: `BREW_PREFIX=$(brew --prefix)` and reuse the variable. Or hardcode `/opt/homebrew` since the config already assumes Apple Silicon.

**Eager Loading of Version Managers:**
- Problem: nvm, rbenv, pyenv, and gvm are all eagerly loaded on every shell startup in `zshrc` (lines 466-493). Each `eval "$(tool init -)"` call adds significant startup time.
- Files: `zshrc` (lines 466-493)
- Cause: Version managers hook into the shell with shims and completion setup.
- Improvement path: Use lazy-loading patterns (e.g., only initialize nvm/rbenv/pyenv when first invoked) or switch to faster alternatives like `fnm` for Node.

**brew-zsh-plugin Hash Directories on Load:**
- Problem: `zsh/brew-zsh-plugin/brew.plugin.zsh` (lines 32-36) calls `brew --repo`, `brew --cache`, `brew --prefix`, and `brew --cellar` at source time, adding 4 subprocess calls (~400-800ms).
- Files: `zsh/brew-zsh-plugin/brew.plugin.zsh` (lines 32-36)
- Cause: Hash directory setup runs unconditionally on plugin load.
- Improvement path: Lazy-evaluate these or hardcode known paths for the target platform.

**vcs_info Runs on Every Prompt:**
- Problem: `vcs_info` is called on every precmd hook in `zshrc` (line 427) without conditions. In large git repos this can be slow.
- Files: `zshrc` (line 427, function `-maybe-show-vcs-info`)
- Cause: vcs_info checks git status every time the prompt is drawn.
- Improvement path: The `disable-patterns` config (line 108) excludes some repos, which is good. Consider adding more large-repo exclusions or using async prompt updates.

## Fragile Areas

**Zsh Plugin Management:**
- Files: `zsh/zsh-autosuggestions/`, `zsh/zsh-syntax-highlighting/`, `zsh/git-aliases/`, `zsh/plugin-osx/`, `zsh/brew-zsh-plugin/`
- Why fragile: Zsh plugins are managed with a mix of git submodules (`zsh-history-substring-search`, `base16-shell`) and manually vendored directories (`zsh-autosuggestions`, `zsh-syntax-highlighting`, `git-aliases`, `plugin-osx`, `brew-zsh-plugin`). There's no plugin manager and no consistent update mechanism.
- Safe modification: For submodules, use `git submodule update --remote`. For vendored plugins, manually copy new versions.
- Test coverage: None. Shell startup must be tested manually.

**Self-Referential Symlink:**
- Files: `zsh/.zsh` (symlink pointing to `./.zsh` - self-referential loop)
- Why fragile: This is an ELOOP (too many symbolic links) error when trying to resolve. It exists in the repo but serves no obvious purpose.
- Safe modification: Remove the symlink.
- Test coverage: None.

**`.DS_Store` Committed:**
- Files: `tmux/.DS_Store`
- Why fragile: macOS metadata file that shouldn't be in version control. Can cause unnecessary merge conflicts.
- Safe modification: Remove and add `.DS_Store` to `.gitignore`.
- Test coverage: N/A.

**Yabai Script Path References:**
- Files: `config/yabai/yabairc` (line 114), `config/skhd/skhdrc` (lines 18-19, 63-65, 86)
- Why fragile: Scripts reference `~/.scripts/yabai/*.sh` but the repo stores them at `scripts/yabai/*.sh`. This depends on rcm symlinking `scripts/` to `~/.scripts/`, which is an unusual mapping. If rcm config changes, all yabai/skhd integrations break.
- Safe modification: Verify the rcm EXCLUDES pattern in `rcrc` doesn't accidentally exclude the scripts directory.
- Test coverage: None.

**`System Preferences` vs `System Settings`:**
- Files: `config/yabai/yabairc` (line 22)
- Why fragile: macOS Ventura (13+) renamed "System Preferences" to "System Settings". The yabai rule `app="^System Preferences$"` won't match on modern macOS.
- Safe modification: Add a rule for `"^System Settings$"` alongside the existing one.
- Test coverage: None.

**FZF Plugin Path Hardcoded:**
- Files: `vim/vimrc` (line 60)
- Why fragile: `Plug '/usr/local/opt/fzf'` hardcodes the Intel Homebrew path. On Apple Silicon, fzf is at `/opt/homebrew/opt/fzf`.
- Safe modification: Use `Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }` instead.
- Test coverage: None.

## Consistency Issues

**Mixed Plugin Management Approaches:**
- Issue: Vim uses vim-plug (`vim/vimrc`), Emacs uses straight.el (`emacs.d/config.org`), zsh uses a mix of manual vendoring and git submodules. Neovim delegates to Vim's config entirely (`config/nvim/init.vim` just sources `~/.vim/vimrc`).
- Files: `vim/vimrc`, `emacs.d/config.org`, `zshrc`, `config/nvim/init.vim`
- Impact: No single pattern for updating all plugins. Requires different knowledge for each tool.

**Inconsistent Path Handling Between Intel and Apple Silicon:**
- Issue: Some code properly handles both architectures (`dotfiles.yml` tasks for homebrew check), while other code hardcodes Apple Silicon paths (`zshrc` line 56, `dotfiles.yml` Python install lines 219-224 both use `/opt/homebrew/bin/pyenv`).
- Files: `zshrc` (line 56), `dotfiles.yml` (lines 213, 220, 227), `vim/vimrc` (line 60)
- Impact: Intel Mac support is silently broken in several places.

**CoC Config Contains Test Data:**
- Issue: `config/coc/list-extensions-history.json` contains what appears to be test data (`"asdfasdf"`). The `config/coc/extensions/db.json` and `config/coc/memos.json` are empty `{}` objects.
- Files: `config/coc/list-extensions-history.json`, `config/coc/extensions/db.json`, `config/coc/memos.json`
- Impact: Unnecessary files in version control that get overwritten locally anyway.
- Fix approach: Add these runtime-generated files to `.gitignore`.

## Missing Features / Best Practices Not Followed

**No Shell Startup Time Profiling:**
- Problem: With the heavy loading described above, there's no built-in way to profile shell startup time.
- Blocks: Diagnosing slow shell startup.
- Recommendation: Add `zmodload zsh/zprof` at the top of `zshrc` behind a flag, and `zprof` at the bottom, to enable profiling when needed.

**No Automatic Plugin Updates:**
- Problem: There's no cron job, script, or documented process for updating vim-plug plugins, zsh plugins (vendored or submodule), or Emacs straight.el packages.
- Blocks: Plugins may become stale and accumulate security vulnerabilities.

**No Bootstrap Validation:**
- Problem: The Ansible playbook (`dotfiles.yml`) has no idempotency checks for most tasks and no validation that the setup completed successfully. The `rcup` commands at the end (lines 294-306) run unconditionally.
- Blocks: Reliable repeatable setup on new machines.

**Missing `vars/custom.yml` Template:**
- Problem: `dotfiles.yml` references `vars/custom.yml` (line 7) which is gitignored (`vars/*.yml` in `.gitignore`). There's no template or documentation for what this file should contain.
- Blocks: New machine setup requires guessing or prior knowledge of required variables.

**README References Non-Existent File:**
- Problem: `README.org` (line 57) links to `emacs.d/configuration.org` but the actual file is `emacs.d/config.org`.
- Files: `README.org` (line 57)
- Impact: Broken documentation link.

## Dependencies at Risk

**chriskempson/base16-vim (Archived):**
- Risk: The `chriskempson/base16-vim` repository referenced in `.gitmodules` (line 12) and as a vim-plug plugin in `vim/vimrc` (line 57) is archived/unmaintained. The base16 project has moved to `tinted-theming/base16-vim`.
- Impact: No future updates, potential compatibility issues with newer Vim/Neovim.
- Migration plan: Switch to `tinted-theming/base16-vim` or `tinted-theming/tinted-vim`.

**Limelight (Window Borders):**
- Risk: Limelight (`config/limelight/limelightrc`) is launched by `config/yabai/yabairc` (lines 90-91). Limelight has been superseded by JankyBorders for modern macOS.
- Impact: May not work on newer macOS versions.
- Migration plan: Switch to `FelixKratz/JankyBorders`.

**raxod502/straight.el Bootstrap URL:**
- Risk: The Emacs config (`emacs.d/config.org` line 67) bootstraps straight.el from `raxod502/straight.el` on GitHub. The project has been transferred to `radian-software/straight.el`.
- Impact: The bootstrap URL may stop working if the redirect is removed.
- Migration plan: Update the URL to `radian-software/straight.el`.

**Vendored Zsh Plugins Without Version Pinning:**
- Risk: `zsh/zsh-autosuggestions/`, `zsh/zsh-syntax-highlighting/`, `zsh/git-aliases/`, `zsh/plugin-osx/`, `zsh/brew-zsh-plugin/` are vendored with no version tracking. It's impossible to tell what version is installed or if updates are needed.
- Impact: Potential bugs from outdated versions; no audit trail.
- Migration plan: Convert to git submodules with version tracking, or adopt a zsh plugin manager like zinit or antidote.

## Test Coverage Gaps

**No Automated Testing:**
- What's not tested: Nothing is tested. There are no CI pipelines, shellcheck runs, or validation scripts for any shell configuration, Vim config, or Ansible playbook.
- Files: All shell scripts in `scripts/yabai/`, `zsh/*.zsh`, `zshrc`, `zshenv`
- Risk: Syntax errors or broken configs won't be caught until they affect the user's shell session.
- Priority: Medium. Add at minimum: `shellcheck` for shell scripts, `ansible-lint` for the playbook, and `vint` for Vim scripts.

**No Idempotency Testing for Ansible:**
- What's not tested: Running `dotfiles.yml` multiple times may produce different results. Some tasks use `shell` module without proper `creates`/`removes` guards.
- Files: `dotfiles.yml`
- Risk: Re-running the playbook could break an already-working setup.
- Priority: Medium.

---

*Concerns audit: 2026-03-25*
