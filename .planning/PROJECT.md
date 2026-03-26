# Emacs Next.js/TypeScript LSP Setup

## What This Is

Fix and configure Emacs for proper Next.js editing with working LSP support for .ts and .tsx files. The goal is to have the same code navigation experience (go-to-definition, find-references, etc.) that already works for Go, but for TypeScript/TSX — and to add format-on-save.

## Core Value

LSP code navigation (gd, gi, gr, gy, ,r) works reliably in .ts and .tsx files inside a Next.js project, matching the Go editing experience.

## Requirements

### Validated

<!-- Existing capabilities confirmed working -->

- ✓ lsp-mode installed and configured (v9.0.0 pinned via straight.el) — existing
- ✓ Evil-mode LSP keybindings (gd/gi/gr/gy/,r) defined in `abram/evil-lsp-keybindings` — existing
- ✓ Go LSP working with gopls — existing
- ✓ typescript-mode and derived typescriptreact-mode defined — existing
- ✓ tree-sitter and tree-sitter-langs installed for syntax highlighting — existing
- ✓ tsi.el installed for tree-sitter indentation — existing
- ✓ LSP hooks on typescript-mode-hook and typescriptreact-mode-hook — existing
- ✓ company-mode completion framework — existing
- ✓ lsp-ui, lsp-treemacs, lsp-ivy supporting packages — existing
- ✓ straight.el + use-package package management — existing
- ✓ Auto-mode-alist correctly routes .ts and .tsx to appropriate modes — Validated in Phase 1: Diagnose & Fix Environment
- ✓ Emacs inherits nvm-managed Node.js PATH (`executable-find "node"` returns nvm path) — Validated in Phase 1
- ✓ lsp-mode lockfile updated to 9.0.0 tag commit — ts-ls connects without `--tsserver-path` error — Validated in Phase 2
- ✓ LSP keybindings (gd/gi/gr/gy/,r) work in .ts and .tsx files — Validated in Phase 2
- ✓ Go LSP (gopls) unaffected by lsp-mode update — Validated in Phase 2
- ✓ Other language LSPs (Clojure) unaffected — Validated in Phase 2

- ✓ Format-on-save for TypeScript/TSX via lsp-eslint-auto-fix-on-save (ESLint+Prettier) — Validated in Phase 3
- ✓ Organize-imports on save for TypeScript/TSX (buffer-local before-save-hook) — Validated in Phase 3
- ✓ Auto-import on completion (default lsp-completion-enable-additional-text-edit) — Validated in Phase 3

### Active

<!-- All requirements validated. Project complete. -->

<!-- Current scope. Building toward these. -->

- [x] ~~Format-on-save for TypeScript/TSX files~~ → moved to Validated (Phase 3, via ESLint+Prettier)
- [x] ~~Fix ts-ls error: `unknown option '--tsserver-path'`~~ → moved to Validated
- [x] ~~LSP keybindings (gd, gi, gr, gy, ,r) work in .ts and .tsx files~~ → moved to Validated
- [x] ~~Auto-mode-alist correctly routes .ts and .tsx to appropriate modes~~ → moved to Validated

### Out of Scope

- .js/.jsx file support — TS-only workflow, not needed
- Full Next.js DX (tailwind LSP, auto-import, JSX snippets) — just LSP nav + format
- Neovim/CoC TypeScript setup — Emacs only
- Linting integration (ESLint) — not requested
- Complete JS/TS toolchain overhaul — focused fix only

## Context

- Emacs config is a literate Org-mode file (`emacs.d/config.org`, ~2168 lines) managed by straight.el + use-package
- lsp-mode lockfile now pins commit `a478e03cd1` (tag 9.0.0). Previously pinned stale 2021 commit that passed `--tsserver-path`.
- The LSP keybindings are defined once in `abram/evil-lsp-keybindings` (config.org:1145-1151) and hooked into all lsp-mode buffers — so they'll automatically apply to any buffer where lsp-mode activates
- typescript-mode hooks now use `#'lsp-deferred` (matching Go pattern), .ts and .tsx route to separate modes
- Node.js v22.9.0 via nvm (terminal), v18.20.5 in Emacs GUI (nvm default at launch). Both work. typescript-language-server v4.3.3 installed under v22.
- Go LSP (gopls) works, confirming lsp-mode infrastructure is sound
- LSP connects and keybindings work in .ts and .tsx files — core value delivered
- Format-on-save uses ESLint auto-fix (lsp-eslint-auto-fix-on-save) which invokes Prettier via eslint-plugin-prettier, respecting project .prettierrc.json
- Organize-imports runs as buffer-local before-save-hook on TypeScript modes
- **All 3 phases complete. Project goal achieved.**

## Constraints

- **Package manager**: Must use straight.el + use-package (existing system)
- **Config format**: Changes go into `emacs.d/config.org` (literate Org-mode)
- **Keybinding parity**: Must reuse existing `abram/evil-lsp-keybindings` — no separate TS keybindings
- **Minimal disruption**: Don't break existing Go, Clojure, or other language LSP setups
- **macOS**: Homebrew + nvm environment for installing system dependencies

## Key Decisions

<!-- Decisions that constrain future work. Add throughout project lifecycle. -->

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Fix ts-ls compatibility rather than switch LSP client | lsp-mode works for Go; the issue is version mismatch, not lsp-mode itself | ✓ Confirmed — lockfile update fixed it |
| Research best LSP server for Next.js before committing | typescript-language-server v4.x changed API; need to verify best option in 2025 | ✓ ts-ls with typescript-language-server v4.3.3 works after lsp-mode 9.0.0 |
| TS/TSX only, no JS/JSX | User's Next.js project is TypeScript-only | — Confirmed |
| Format-on-save via ESLint+Prettier | User's project uses eslint-plugin-prettier; ESLint auto-fix respects .prettierrc.json (tabWidth: 2) | ✓ Confirmed — lsp-eslint-auto-fix-on-save works |
| Prefer `GOPATH/bin` after shell import for Go tools | gvm exported the right `GOPATH`, but stale `~/bin/gopls` stayed earlier on `PATH`, so `executable-find` chose the wrong binary | ✓ Confirmed — Emacs now resolves the active-session `gopls` |

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd-transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd-complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

---
*Last updated: 2026-03-26 after quick fix for active-session gopls path resolution*
