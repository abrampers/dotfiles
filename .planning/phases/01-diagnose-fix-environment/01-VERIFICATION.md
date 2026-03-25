---
phase: 01-diagnose-fix-environment
verified: 2026-03-25T11:35:00Z
status: passed
score: 5/5 must-haves verified
re_verification: false
human_verification:
  - test: "Restart Emacs GUI and evaluate (executable-find \"node\") — confirm it returns nvm path"
    expected: "Path containing .nvm/versions/ (e.g., /Users/abram.perdanaputra/.nvm/versions/node/v18.20.5/bin/node)"
    why_human: "Batch mode and GUI mode can differ; exec-path-from-shell behavior depends on launch-time shell state"
  - test: "Open a .ts file and check modeline shows 'TypeScript' (not 'TypeScript TSX')"
    expected: "Modeline displays TypeScript mode"
    why_human: "Mode routing depends on auto-mode-alist evaluation order at runtime in GUI Emacs"
  - test: "Open a .tsx file and check modeline shows 'TypeScript TSX'"
    expected: "Modeline displays TypeScript TSX mode"
    why_human: "Derived mode routing requires live Emacs verification"
---

# Phase 1: Diagnose & Fix Environment — Verification Report

**Phase Goal:** User knows the exact state of their toolchain and Emacs can find nvm-managed Node.js
**Verified:** 2026-03-25T11:35:00Z
**Status:** passed
**Re-verification:** No — initial verification

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | User can verify which lsp-mode commit is actually loaded | ✓ VERIFIED | Diagnostic findings document commit `bdae0f406d` (2021-07-11) is loaded, NOT v9.0.0. `M-x lsp-version` returns nil package-desc (confirming stale state). Lockfile at `emacs.d/straight/versions/default.el:61` confirms `bdae0f406d`. |
| 2 | `(executable-find "node")` in Emacs returns nvm-managed path | ✓ VERIFIED | Diagnostic findings: batch mode returns `/Users/abram.perdanaputra/.nvm/versions/node/v22.9.0/bin/node`; GUI returns `/Users/abram.perdanaputra/.nvm/versions/node/v18.20.5/bin/node`. Both are nvm paths (not nil, not system Node). NVM_DIR copy added at config.org:295. |
| 3 | `(executable-find "typescript-language-server")` returns valid path or confirms correct PATH | ✓ VERIFIED | Diagnostic findings: returns `/Users/abram.perdanaputra/.nvm/versions/node/v22.9.0/bin/typescript-language-server` (v4.3.3 installed). PATH is correct — nvm paths are present in Emacs exec-path. |
| 4 | .ts files open in typescript-mode, .tsx files open in typescriptreact-mode | ✓ VERIFIED | config.org:1560 has `"\\.tsx\\'" . typescriptreact-mode`, config.org:1561 has `"\\.ts\\'" . typescript-mode`. Old unified regex `"\\.tsx?\\'"` confirmed removed (grep returns 0 matches). |
| 5 | TypeScript and TSX hooks use lsp-deferred (matching Go pattern) | ✓ VERIFIED | config.org:1565 has `#'lsp-deferred` for typescript-mode-hook, config.org:1566 has `#'lsp-deferred` for typescriptreact-mode-hook. Old eager `#'lsp` hooks confirmed absent (grep returns 0 matches). Go-mode at config.org:1251 unchanged, still uses `lsp-deferred`. |

**Score:** 5/5 truths verified

### Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `emacs.d/config.org` | Updated exec-path-from-shell with NVM_DIR, split auto-mode-alist, lsp-deferred hooks | ✓ VERIFIED | Line 295: `(exec-path-from-shell-copy-env "NVM_DIR")` present. Lines 1560-1566: split .ts/.tsx entries, lsp-deferred hooks. Git diff confirms exactly 3 targeted changes across 2 sections. |
| `.planning/phases/01-diagnose-fix-environment/01-01-SUMMARY.md` | Diagnostic findings documented | ✓ VERIFIED | 99 lines, contains lsp-mode commit analysis, Node.js version, PATH state. |
| `.planning/phases/01-diagnose-fix-environment/01-01-diagnostic-findings.md` | Detailed diagnostic data | ✓ VERIFIED | 90 lines with terminal + GUI session findings: lockfile commit, Node versions (v22 terminal, v18 GUI), exec-path state. |
| `.planning/phases/01-diagnose-fix-environment/01-02-SUMMARY.md` | Config change summary | ✓ VERIFIED | 119 lines documenting all 3 changes, commits, human verification approval. |

### Key Link Verification

| From | To | Via | Status | Details |
|------|----|-----|--------|---------|
| `emacs.d/config.org` (exec-path-from-shell, line 295) | `zsh/exports.zsh` (line 23: `export NVM_DIR="$HOME/.nvm"`) | `exec-path-from-shell-copy-env "NVM_DIR"` | ✓ WIRED | config.org:295 copies NVM_DIR; exports.zsh:23 exports it. exec-path-from-shell uses `-l` flag which sources `.zshrc` (which sources `exports.zsh`). Chain: zshrc → exports.zsh → NVM_DIR → exec-path-from-shell → Emacs env. |
| `emacs.d/config.org` (typescript-mode, lines 1565-1566) | `emacs.d/config.org` (lsp-mode, line 1078: `lsp-deferred` in `:commands`) | `add-hook ... #'lsp-deferred` | ✓ WIRED | lsp-mode declares `lsp-deferred` as a command (line 1078). Both typescript hooks call `#'lsp-deferred` (lines 1565-1566). lsp-mode-hook triggers `abram/evil-lsp-keybindings` (line 1080), which will apply to TS buffers when lsp-deferred activates lsp-mode. |

### Data-Flow Trace (Level 4)

Not applicable — this phase modifies Emacs configuration (Elisp declarations), not components that render dynamic data. The "data" is environment variables and mode routing, which are declarative configurations verified by structural inspection.

### Behavioral Spot-Checks

| Behavior | Command | Result | Status |
|----------|---------|--------|--------|
| NVM_DIR copy in config.org | `grep 'exec-path-from-shell-copy-env.*NVM_DIR' emacs.d/config.org` | Line 295: match found | ✓ PASS |
| Split .tsx auto-mode-alist | `grep '\\.tsx.*typescriptreact' emacs.d/config.org` | Line 1560: match found | ✓ PASS |
| Split .ts auto-mode-alist | `grep '\\.ts.*typescript-mode' emacs.d/config.org` | Line 1561: match found | ✓ PASS |
| Old unified regex removed | `grep '\\.tsx?\\' emacs.d/config.org` | No matches | ✓ PASS |
| lsp-deferred hooks (not eager lsp) | `grep 'add-hook.*typescript.*lsp-deferred' emacs.d/config.org` | 2 matches (lines 1565, 1566) | ✓ PASS |
| Old eager hooks removed | `grep "add-hook.*typescript-mode-hook.*#'lsp)" emacs.d/config.org` | No matches | ✓ PASS |
| Go-mode section unchanged | `git diff 35e4106^..dba9eed -- emacs.d/config.org` (count go-mode lines) | 0 go-mode changes | ✓ PASS |
| tsi.el section unchanged | Direct read of config.org:1572-1584 | Identical to pre-change state | ✓ PASS |
| Commits exist in git | `git show --stat 35e4106` and `git show --stat dba9eed` | Both exist with correct messages | ✓ PASS |

### Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
|-------------|------------|-------------|--------|----------|
| DIAG-01 | 01-01 | Verify actual loaded lsp-mode commit hash matches v9.0.0 tag | ✓ SATISFIED | Diagnostic findings document: lockfile pins `bdae0f406d` (2021-07-11), which is NOT v9.0.0. `M-x lsp-version` returns nil package-desc confirming stale commit. `straight--get-recipe` unavailable at runtime (internal function). User has ground truth. |
| DIAG-03 | 01-01 | Verify Node.js version via nvm is sufficient for typescript-language-server | ✓ SATISFIED | Diagnostic findings: Node.js v22.9.0 in terminal, v18.20.5 in Emacs GUI — both ≥ v14 (minimum for typescript-language-server v4.x). typescript-language-server v4.3.3 already installed. |
| ENV-01 | 01-02 | Emacs inherits nvm-managed Node.js PATH | ✓ SATISFIED | exec-path-from-shell with `-l` flag sources zshrc (which initializes nvm). Diagnostic findings confirm `(executable-find "node")` returns nvm path in both batch and GUI mode. NVM_DIR copy added for completeness. |
| ENV-02 | 01-02 | exec-path-from-shell config updated to ensure nvm shims are on Emacs exec-path | ✓ SATISFIED | config.org:295 adds `(exec-path-from-shell-copy-env "NVM_DIR")`. The `-l` flag at config.org:290 already causes nvm PATH inheritance. Commit `35e4106` adds NVM_DIR copy. |

**Orphaned requirements check:** REQUIREMENTS.md maps DIAG-01, DIAG-03, ENV-01, ENV-02 to Phase 1. Plan 01-01 claims DIAG-01 and DIAG-03. Plan 01-02 claims ENV-01 and ENV-02. All 4 requirements accounted for — no orphans.

### Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
|------|------|---------|----------|--------|
| emacs.d/config.org | 1077 | `:tag "v9.0.0"` still present but lockfile overrides it | ℹ️ Info | Misleading tag declaration — lockfile `bdae0f406d` is from 2021, not v9.0.0. Phase 2 will update the lockfile, which will resolve this. Not a Phase 1 concern. |
| emacs.d/config.org | 1364, 1366 | `TODO Text object`, `TODO Java` | ℹ️ Info | Org-mode task entries, not code placeholders. Normal for a literate config. |

No blocker or warning-level anti-patterns found.

### Human Verification Required

Human verification was **already performed** during plan execution (Task 2 of Plan 01-01 and Task 3 of Plan 01-02 were `checkpoint:human-verify` gates). The user approved both checkpoints.

**For additional confidence, these can be re-verified:**

### 1. Node.js Discovery in GUI Emacs

**Test:** Restart Emacs GUI, evaluate `M-: (executable-find "node")`
**Expected:** Returns a path containing `.nvm/versions/` (e.g., `/Users/abram.perdanaputra/.nvm/versions/node/v18.20.5/bin/node`)
**Why human:** Batch mode and GUI mode can differ due to exec-path-from-shell timing; user already confirmed this works.

### 2. TypeScript Mode Routing

**Test:** Open a `.ts` file — check modeline; open a `.tsx` file — check modeline
**Expected:** `.ts` shows "TypeScript", `.tsx` shows "TypeScript TSX"
**Why human:** Mode routing depends on auto-mode-alist evaluation at runtime; user confirmed via checkpoint.

### 3. Go LSP Regression Check

**Test:** Open a `.go` file — confirm LSP connects and `gd` works
**Expected:** Go LSP still works (modeline shows LSP connected)
**Why human:** Regression testing requires live editor interaction; go-mode section confirmed unchanged in git diff.

### Gaps Summary

No gaps found. All 5 observable truths verified against the actual codebase. All 4 requirement IDs (DIAG-01, DIAG-03, ENV-01, ENV-02) satisfied with evidence. Key links between exec-path-from-shell ↔ NVM_DIR export and typescript hooks ↔ lsp-deferred are wired. Config changes are minimal and targeted (only 2 sections of config.org modified across 2 commits). Go-mode and tsi.el sections confirmed unchanged via git diff.

The known `--tsserver-path` error observed during human verification is expected — it is the root cause that Phase 2 will fix (stale lsp-mode lockfile). It is NOT a Phase 1 concern.

---

_Verified: 2026-03-25T11:35:00Z_
_Verifier: the agent (gsd-verifier)_
