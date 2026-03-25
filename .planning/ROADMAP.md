# Roadmap: Emacs Next.js/TypeScript LSP Setup

## Overview

Fix the version mismatch between lsp-mode and typescript-language-server that prevents LSP from connecting in TypeScript files. Once the connection works, all 5 navigation keybindings (gd/gi/gr/gy/,r) activate automatically via existing hooks. Then add format-on-save and code actions as the only new config.org features. Three phases with a strict dependency chain: diagnose environment → fix LSP + verify navigation → add formatting + code actions.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [x] **Phase 1: Diagnose & Fix Environment** - Establish ground truth about lsp-mode version, Node.js, and Emacs PATH before changing anything
- [ ] **Phase 2: Fix LSP Connection & Verify Navigation** - Fix the lsp-mode/typescript-language-server version mismatch and confirm all 5 navigation keybindings work
- [ ] **Phase 3: Format-on-Save & Code Actions** - Add buffer-local format-on-save and auto-import as new config.org features

## Phase Details

### Phase 1: Diagnose & Fix Environment
**Goal**: User knows the exact state of their toolchain and Emacs can find nvm-managed Node.js
**Depends on**: Nothing (first phase)
**Requirements**: DIAG-01, DIAG-03, ENV-01, ENV-02
**Success Criteria** (what must be TRUE):
  1. User can verify which lsp-mode commit is actually loaded (not just what the tag says) by running `M-x lsp-version` or inspecting `(straight--get-recipe 'lsp-mode)`
  2. Evaluating `(executable-find "node")` in Emacs returns the nvm-managed Node.js path (not nil or a system Node)
  3. Evaluating `(executable-find "typescript-language-server")` in Emacs returns a valid path (or confirms it's not yet installed — either way, the PATH is correct)
**Plans**: 2 plans
Plans:
- [x] 01-01-PLAN.md — Diagnose lsp-mode version and Node.js environment
- [x] 01-02-PLAN.md — Fix exec-path-from-shell PATH and TypeScript mode routing

### Phase 2: Fix LSP Connection & Verify Navigation
**Goal**: LSP connects successfully in .ts and .tsx files, and all 5 navigation keybindings work at Go-parity
**Depends on**: Phase 1
**Requirements**: DIAG-02, DIAG-04, NAV-01, NAV-02, NAV-03, NAV-04, NAV-05, REG-01, REG-02
**Success Criteria** (what must be TRUE):
  1. Opening a .ts file in a Next.js project shows LSP connected in the modeline (no `--tsserver-path` error)
  2. Opening a .tsx file in a Next.js project shows LSP connected in the modeline
  3. User can go-to-definition (gd), find-references (gr), find-implementation (gi), find-type-definition (gy), and rename symbol (,r) in both .ts and .tsx files
  4. Go LSP (gopls) still works after the lsp-mode change — gd/gr work in a .go file
  5. Other language LSPs (Clojure, etc.) are unaffected — no errors on startup or when opening those file types
**Plans**: 1 plan
Plans:
- [ ] 02-01-PLAN.md — Update lsp-mode lockfile to 9.0.0 and verify navigation keybindings

### Phase 3: Format-on-Save & Code Actions
**Goal**: TypeScript files auto-format on save and code actions (auto-import, organize imports) are available
**Depends on**: Phase 2
**Requirements**: FMT-01, FMT-02, FMT-03, ACT-01, ACT-02
**Success Criteria** (what must be TRUE):
  1. Saving a .ts file auto-formats it (indentation, spacing corrected)
  2. Saving a .tsx file auto-formats it (indentation, spacing corrected)
  3. Saving a .go file still uses gofmt (format-on-save does not interfere with Go's formatter)
  4. Completing a symbol from another module triggers auto-import (import statement added automatically)
  5. User can invoke organize-imports code action to sort/clean import statements
**Plans**: TBD

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Diagnose & Fix Environment | 2/2 | Complete | 2026-03-25 |
| 2. Fix LSP Connection & Verify Navigation | 0/1 | Not started | - |
| 3. Format-on-Save & Code Actions | 0/0 | Not started | - |
