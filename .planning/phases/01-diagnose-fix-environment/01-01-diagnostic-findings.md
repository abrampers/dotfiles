# Diagnostic Findings: lsp-mode + Node.js Environment

**Date:** 2026-03-25
**Source:** Terminal diagnostics (Task 1 of Plan 01-01)

## 1. lsp-mode Git State

### Lockfile
```
("lsp-mode" . "bdae0f406d040366193a359ab70f55af30e928ae")
```
- File: `emacs.d/straight/versions/default.el` line 61

### Actual Checked-Out Commit
```
bdae0f406d [semantic-tokens] Add/remove tokens when toggle minor-mode
Full hash: bdae0f406d040366193a359ab70f55af30e928ae
Date: 2021-07-11 11:40:17 -0300
```

### Tag v9.0.0
- **NOT found locally** — `git rev-parse v9.0.0` fails with "unknown revision"
- No v9.x tags exist in the local clone
- The `config.org` declaration specifies `:tag "v9.0.0"` but straight.el uses the lockfile commit, which overrides the tag

### Remote HEAD
- `origin/master` is at commit `3a952ca135` (Fix lsp-completion-default-behaviour)
- The local checkout is significantly behind master

### Conclusion
**The lockfile commit `bdae0f406d` is from July 2021 and is NOT v9.0.0.** The `:tag "v9.0.0"` in config.org is misleading — straight.el pins to the lockfile hash, which is a much older commit. This is likely the root cause of the `--tsserver-path` error: the old lsp-mode passes arguments that typescript-language-server v4.x no longer accepts.

## 2. Node.js Environment

| Item | Value |
|------|-------|
| Node.js version | v22.9.0 |
| Node.js path | `/Users/abram.perdanaputra/.nvm/versions/node/v22.9.0/bin/node` |
| npm version | 10.8.3 |
| NVM_DIR | `$HOME/.nvm` |
| typescript-language-server version | 4.3.3 |
| typescript-language-server path | `/Users/abram.perdanaputra/.nvm/versions/node/v22.9.0/bin/typescript-language-server` |

**Conclusion:** Node.js v22.9.0 is well above the v14 minimum. typescript-language-server v4.3.3 is already installed. This confirms the version mismatch: the old lsp-mode (2021) passes `--tsserver-path` which was removed in typescript-language-server v4.x.

## 3. Emacs exec-path (Batch Mode)

- **`(executable-find "node")`** → `/Users/abram.perdanaputra/.nvm/versions/node/v22.9.0/bin/node`
- **`(executable-find "typescript-language-server")`** → `/Users/abram.perdanaputra/.nvm/versions/node/v22.9.0/bin/typescript-language-server`
- The nvm path `~/.nvm/versions/node/v22.9.0/bin` IS present in exec-path
- exec-path-from-shell successfully imports the shell PATH including nvm paths

**Conclusion:** In batch mode, Emacs CAN find both `node` and `typescript-language-server`. The exec-path-from-shell package is working for batch mode. GUI session needs verification (Task 2 checkpoint).

## Summary for Plan 02

| Finding | Status | Impact on Plan 02 |
|---------|--------|--------------------|
| lsp-mode commit is from 2021, not v9.0.0 | CONFIRMED | Must update lockfile to modern lsp-mode |
| Node.js v22.9.0 available | OK | No action needed |
| typescript-language-server v4.3.3 installed | OK | Compatible with modern lsp-mode |
| Emacs batch-mode finds node/tls | OK | exec-path-from-shell works in batch mode |
| GUI exec-path state | PENDING | Needs checkpoint verification |
