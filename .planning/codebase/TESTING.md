# Testing Patterns

**Analysis Date:** 2026-03-25

## Test Framework

**Runner:**
- No test framework exists for this dotfiles repository
- No automated tests for shell configurations, vim configs, or dotfile management

**Third-Party Plugin Tests (not executed as part of this repo):**
- `zsh/zsh-syntax-highlighting/` contains its own test suite: `tests/test-highlighting.zsh`, `tests/test-perfs.zsh`
- `zsh/base16-shell/realpath/` contains its own tests: `t/test_realpath_integration`, `t/test_resolve_symlinks`, etc.
- These are upstream test suites belonging to submodule dependencies — they are not run as part of dotfile validation

**Run Commands:**
```bash
# No test commands exist for this repository
# The only "test" is manual: source configs and verify behavior
```

## Validation Approach

**Manual Verification:**
- This repository relies entirely on manual verification
- Changes are tested by sourcing config files or restarting the relevant tool
- Tmux has a quick-reload binding: `prefix-r` sources `~/.tmux.conf` and shows "Config reloaded..." — `tmux.conf` line 168
- Vim has leader reload: `<Leader><CR>` re-sources vimrc — `vim/plugin/mappings/leader.vim` line 17-21
- Zsh changes require opening a new shell or manually sourcing the changed file

**Vim Health Check:**
- A minimal Neovim health check exists: `vim/autoload/health/wincent.vim`
- Invoked via `:checkhealth wincent` in Neovim
- Currently only has a stub (Ruby support check is commented out):
  ```vim
  function! health#wincent#check() abort
    call health#report_start('Wincent')
    " call s:require(has('ruby'), 'Has Ruby support')
  endfunction
  ```
- Pattern for adding health checks: use `s:require(condition, message)` helper

**Color Scheme Validation:**
- `zsh/base16-shell/colortest` script can verify terminal color rendering
- `vim/after/plugin/color.vim` includes error reporting for bad color schemes:
  ```vim
  echoerr 'Bad background ' . s:config[1] . ' in ' . s:config_file
  echoerr 'Bad scheme ' . s:config[0] . ' in ' . s:config_file
  ```

## Installation Scripts and Error Handling

**Primary Installation: Ansible Playbook (`dotfiles.yml`)**

The main setup automation is a 306-line Ansible playbook that:

1. **Pre-flight checks:**
   - Detects CPU architecture (Intel vs Apple Silicon) for correct Homebrew path — lines 9-23
   - Verifies Homebrew installation, fails with message if missing — lines 25-30
   - Creates `~/bin` directory, handles case where `~/bin` is a file (removes and recreates) — lines 38-56

2. **Package installation:** Uses `community.general.homebrew` and `community.general.homebrew_cask` modules for idempotent installs — lines 69-293

3. **Conditional execution:**
   - Shell change only if not already zsh: `when: current_shell_output.stdout != "/bin/zsh"` — lines 72-86
   - Python install only if version not present: `when: not pyenv_python.stat.exists` — lines 213-224
   - erlang_ls build only if binary not present: `when: not erlang_ls_binary_stat['stat']['exists']` — lines 180-192

4. **Error handling:**
   - `failed_when` and `changed_when` conditions on shell commands — lines 77-78, 84-85, 298-299, 304-305
   - `check_mode: no` on info-gathering tasks — lines 62, 67
   - `creates:` argument for idempotent file creation (vim-plug install) — line 101

5. **Dotfile deployment via rcm:**
   - Installs rcm config first: `rcup rcrc` — line 296-299
   - Then deploys all dotfiles: `rcup` — line 301-306

**Running the playbook:**
```bash
# Full installation
ansible-playbook dotfiles.yml

# Dry run (check mode)
ansible-playbook dotfiles.yml --check

# Prerequisites
python3 -m pip install --user ansible-core
ansible-galaxy collection install community.general
```

## Idempotency

**Ansible Playbook (`dotfiles.yml`):**
- Homebrew module is inherently idempotent (won't reinstall existing packages)
- `stat` checks prevent redundant operations (pyenv Python, erlang_ls binary, Homebrew existence)
- `creates:` argument on vim-plug download prevents re-download — line 101
- rcm's `rcup` is idempotent (updates symlinks, skips existing correct ones)

**Shell Scripts (`scripts/yabai/*.sh`):**
- Not designed for idempotency — they are reactive scripts triggered by events
- `windowFocusOnDestroy.sh` checks for null state before acting — line 3
- `toggleStackLayout.sh` reads current state and toggles — line 6

**Zsh Config:**
- `zshrc` is idempotent on re-source (uses `typeset -A` which is safe to re-run)
- PATH construction in `zsh/path.zsh` starts fresh (`unset PATH`) then rebuilds — this is idempotent

**Tmux Config:**
- `tmux.conf` reloading is idempotent (settings are overwritten, not appended)
- Plugin `run-shell` calls are safe to re-execute

**Yabai Config (`config/yabai/yabairc`):**
- Kills limelight before restarting: `killall limelight &>/dev/null` — line 90
- Rules are additive (may duplicate on re-source, but yabai handles this)

## CI/CD and Automation

**CI/CD:**
- No CI/CD pipeline exists (no `.github/workflows/`, no `.gitlab-ci.yml`, no `Makefile` at root)
- No automated testing on push/PR
- No linting pipeline for shell scripts

**Automation:**
- Ansible playbook is the sole automation tool for setup
- Karabiner-Elements provides keyboard automation:
  - F2 → TOTP copy to clipboard — `config/karabiner/karabiner.json` line 32
  - F3 → Integration VPN — line 19
  - F4 → Production VPN — line 12
  - Disables page_up/page_down/home/end keys — lines 38-60
- macOS Automator `.app` bundles in `scripts/` for VPN and TOTP workflows

## Backup and Rollback

**Git as primary backup:**
- All configuration is version-controlled in git
- Rollback = `git checkout` to a previous commit
- No automated backup scripts

**Color scheme backup:**
- Base16 color config maintains a `.previous` file for quick rollback:
  - `color -` restores previous scheme — `zsh/colors.zsh` lines 117-123
  - Previous config stored at `~/.vim/.base16.previous`

**Vim-specific backups:**
- Undo history persisted to disk: `~/.vim/tmp/undo/` — `vim/plugin/settings.vim` lines 163-172
- Swap files: `~/.vim/tmp/swap/` — `vim/plugin/settings.vim` line 37
- Backup files: `~/.vim/tmp/backup/` — `vim/plugin/settings.vim` line 13
- View files (folds/cursor): `~/.vim/tmp/view/` — `vim/plugin/settings.vim` line 215
- All temp files are scoped under `~/.vim/tmp/` to keep them out of project directories
- Root/sudo sessions explicitly disable these: `set nobackup`, `set noswapfile`, `set noundofile`

**rcm (dotfile manager):**
- rcm creates symlinks, not copies — original files remain in `~/.dotfiles/`
- `rcup` can be re-run safely to repair broken symlinks
- `rcdn` can be used to remove all managed symlinks (cleanup)

**No explicit rollback mechanism:**
- No snapshot/stow-style backup before applying changes
- No `dotfiles restore` or undo command
- Relies on git history for recovery

## How Changes Are Typically Verified

**Zsh changes:**
1. Edit file in `~/.dotfiles/zsh/` or `~/.dotfiles/zshrc`
2. Open a new terminal window, or `source ~/.zshrc`
3. Visually verify prompt, test aliases/functions manually

**Vim changes:**
1. Edit file in `~/.dotfiles/vim/`
2. Re-source via `<Leader><CR>` or restart vim
3. Test mappings and settings manually
4. Use `:scriptnames` to verify load order
5. Use `vim --startuptime vim.log` for performance profiling — documented in `vim/vimrc` line 122

**Tmux changes:**
1. Edit `~/.dotfiles/tmux.conf`
2. Press `prefix-r` to reload
3. Verify status line and keybindings

**Yabai/skhd changes:**
1. Edit config files in `config/yabai/` or `config/skhd/`
2. Restart services: `launchctl kickstart -k "gui/${UID}/homebrew.mxcl.yabai"` — referenced in `config/skhd/skhdrc` line 4
3. Test window management behavior

**Full system setup:**
1. Run `ansible-playbook dotfiles.yml --check` for dry run
2. Run `ansible-playbook dotfiles.yml` for actual deployment
3. Open new terminal, verify all tools work

## Test Coverage Gaps

**Shell scripts have zero test coverage:**
- `scripts/yabai/*.sh` — 5 scripts with no tests
- `zsh/functions.zsh` — no tests
- `zsh/colors.zsh` — complex color management logic with no tests
- `zsh/path.zsh` — PATH construction with no validation

**Ansible playbook has no integration tests:**
- No molecule or testinfra tests for the playbook
- No verification that installed tools are functional after setup
- No smoke tests for the complete setup

**Configuration correctness is entirely manual:**
- No syntax validation for vim configs (e.g., `vint`)
- No shellcheck for shell scripts
- No yamllint for YAML files
- No jsonlint for JSON configs

**Areas most at risk from untested changes:**
- `zsh/path.zsh` — PATH ordering bugs could break tool resolution
- `zsh/colors.zsh` — color scheme switching logic has file I/O and state management
- `vim/after/plugin/color.vim` — complex colorscheme detection with multiple fallback paths
- `vim/autoload/wincent/autocmds.vim` — 257 lines of autocommand logic
- `dotfiles.yml` — architecture-specific conditionals (Intel vs Apple Silicon) cannot be tested on a single machine

## Recommended Testing Approach (If Adding Tests)

**Shell script validation:**
```bash
# Add to a Makefile or CI
shellcheck scripts/yabai/*.sh
shellcheck zsh/*.zsh
```

**Vim config validation:**
```bash
# Syntax check vim files
vim --not-a-term -c 'source vim/vimrc' -c 'qa!' 2>&1
# Or use vint linter
vint vim/**/*.vim
```

**Ansible dry run:**
```bash
ansible-playbook dotfiles.yml --check --diff
```

**Symlink verification:**
```bash
# Verify all expected symlinks exist and point correctly
lsrc  # rcm command to list managed files
```

---

*Testing analysis: 2026-03-25*
