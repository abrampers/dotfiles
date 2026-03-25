# Phase 1: Diagnose & Fix Environment - Context

**Gathered:** 2026-03-25
**Status:** Ready for planning

<domain>
## Phase Boundary

Establish ground truth about the lsp-mode version, Node.js availability, and Emacs PATH before changing any LSP or TypeScript configuration. After this phase, the user knows exactly what lsp-mode commit is loaded, Emacs can find nvm-managed Node.js, and `typescript-language-server` is discoverable via `exec-path`. No LSP connection fixes or keybinding changes happen here — those are Phase 2.

</domain>

<decisions>
## Implementation Decisions

### Emacs PATH Strategy
- **D-01:** Add explicit `NVM_DIR` env var copy to `exec-path-from-shell` config, alongside existing `GOPATH` copy
- **D-02:** Rely on `exec-path-from-shell-initialize` (with `-l` flag) for PATH inheritance — this picks up nvm shims from zshrc. No need to copy `NVM_BIN` separately.
- **D-03:** Keep change minimal — add `NVM_DIR` only. Leave `PYENV_ROOT` commented out (not needed for this project).
- **D-04:** Verify fix by evaluating `(executable-find "node")` and `(executable-find "typescript-language-server")` in Emacs. Both must return valid nvm-managed paths (not nil or system Node).

### Mode Routing for .ts vs .tsx
- **D-05:** Split `auto-mode-alist` into two entries: `.ts` files use `typescript-mode`, `.tsx` files use `typescriptreact-mode`. Replace the current unified regex `"\\.tsx?\\'"` with separate entries.
- **D-06:** Update `tree-sitter-major-mode-language-alist` accordingly — `typescript-mode` maps to `typescript` parser, `typescriptreact-mode` maps to `tsx` parser.

### LSP Hook Strategy
- **D-07:** Switch TypeScript/TSX hooks from `#'lsp` (eager) to `#'lsp-deferred`, matching the Go mode pattern (config.org:1172). Consistent behavior across all language modes.
- **D-08:** With separate modes (D-05), each mode gets its own hook calling `lsp-deferred` once — eliminating the current double-fire issue where `typescriptreact-mode` inherits `typescript-mode-hook`.

### lsp-mode Version Verification
- **D-09:** Verify actual loaded lsp-mode version via manual `M-x lsp-version` and `(straight--get-recipe 'lsp-mode)` in a live Emacs session. Compare loaded commit hash against lockfile entry `bdae0f4` and tag `v9.0.0`.
- **D-10:** Document findings as input for Phase 2 (which will fix any mismatch).

### Agent's Discretion
- Exact diagnostic steps ordering (check Node first vs lsp-mode first)
- How to document diagnostic findings (inline notes vs separate file)
- Whether to check `(executable-find "tsc")` in addition to `typescript-language-server`
- Node.js version pinning strategy — determine compatible version during research

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Emacs Configuration
- `emacs.d/config.org` lines 287-296 -- exec-path-from-shell configuration (GOPATH copy, -l flag)
- `emacs.d/config.org` lines 1064-1088 -- lsp-mode declaration (v9.0.0 pin, hooks, settings)
- `emacs.d/config.org` lines 1553-1565 -- typescript-mode and typescriptreact-mode setup (auto-mode-alist, LSP hooks, tree-sitter mapping)
- `emacs.d/config.org` lines 1569-1584 -- tsi.el indentation hooks for typescript-mode
- `emacs.d/config.org` lines 1145-1150 -- abram/evil-lsp-keybindings function (gd/gi/gr/gy/,r)
- `emacs.d/config.org` lines 1172 -- go-mode lsp-deferred hook (reference pattern for D-07)

### Version Lockfile
- `emacs.d/straight/versions/default.el` line 61 -- lsp-mode pinned to commit bdae0f406d

### Shell Environment
- `zshrc` lines 466-487 -- nvm initialization (where NVM_DIR and nvm PATH are set)
- `zsh/exports.zsh` -- NVM_DIR export definition

### Project Planning
- `.planning/PROJECT.md` -- Key decisions table, root cause analysis
- `.planning/REQUIREMENTS.md` -- DIAG-01, DIAG-03, ENV-01, ENV-02 requirements for this phase

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- `exec-path-from-shell` package: Already installed and configured. Just needs one additional `copy-env` call for NVM_DIR.
- `abram/evil-lsp-keybindings`: Already hooked into `lsp-mode-hook` — will automatically apply to TypeScript once lsp-mode activates. No changes needed.
- `typescriptreact-mode`: Already derived from `typescript-mode`. Needs to be split into separate auto-mode-alist entries rather than rewritten.

### Established Patterns
- **env var copying pattern**: `(exec-path-from-shell-copy-env "GOPATH")` at config.org:294. Adding NVM_DIR follows the same one-liner pattern.
- **LSP hook pattern**: Go uses `(add-hook 'go-mode-hook #'lsp-deferred)` at config.org:1172. TypeScript should follow this same pattern.
- **Literate config**: All changes go into `emacs.d/config.org` Org-mode source blocks. Changes tangle to elisp on Emacs restart.

### Integration Points
- `exec-path-from-shell` runs early in Emacs startup — the NVM_DIR addition must be in the same `:config` block (config.org:293-295)
- `typescript-mode` section (config.org:1553-1565) is where auto-mode-alist and hooks live — mode routing and hook changes happen here
- `straight/versions/default.el` is the lockfile that determines which lsp-mode commit actually loads — Phase 2 will modify this based on Phase 1 findings

</code_context>

<specifics>
## Specific Ideas

No specific requirements — open to standard approaches for diagnostics and environment fixes.

</specifics>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope.

</deferred>

---

*Phase: 01-diagnose-fix-environment*
*Context gathered: 2026-03-25*
