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

### Active

<!-- Current scope. Building toward these. -->

- [ ] Fix ts-ls error: `unknown option '--tsserver-path'` (version mismatch between lsp-mode and typescript-language-server v4.x)
- [ ] Determine best lsp-mode + LSP server combination for Next.js/TypeScript in 2025
- [ ] LSP keybindings (gd, gi, gr, gy, ,r) work in .ts and .tsx files
- [ ] Format-on-save for TypeScript/TSX files
- [ ] Auto-mode-alist correctly routes .ts and .tsx to appropriate modes

### Out of Scope

- .js/.jsx file support — TS-only workflow, not needed
- Full Next.js DX (tailwind LSP, auto-import, JSX snippets) — just LSP nav + format
- Neovim/CoC TypeScript setup — Emacs only
- Linting integration (ESLint) — not requested
- Complete JS/TS toolchain overhaul — focused fix only

## Context

- Emacs config is a literate Org-mode file (`emacs.d/config.org`, ~2168 lines) managed by straight.el + use-package
- lsp-mode is pinned to v9.0.0 via straight.el tag. This version passes `--tsserver-path` to typescript-language-server, which was removed in typescript-language-server v4.x
- The LSP keybindings are defined once in `abram/evil-lsp-keybindings` (config.org:1145-1151) and hooked into all lsp-mode buffers — so they'll automatically apply to any buffer where lsp-mode activates
- typescript-mode already has LSP hooks (config.org:1562-1563) calling `#'lsp`, and typescriptreact-mode is derived from it
- auto-mode-alist maps `\.tsx?\` to typescriptreact-mode (config.org:1558)
- The disabled rjsx-mode block (`:tangle no`, config.org:1507-1529) is irrelevant
- Node.js managed via nvm, so `typescript-language-server` would be installed via npm
- Go LSP (gopls) works, confirming lsp-mode infrastructure is sound

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
| Fix ts-ls compatibility rather than switch LSP client | lsp-mode works for Go; the issue is version mismatch, not lsp-mode itself | — Pending |
| Research best LSP server for Next.js before committing | typescript-language-server v4.x changed API; need to verify best option in 2025 | — Pending |
| TS/TSX only, no JS/JSX | User's Next.js project is TypeScript-only | — Pending |
| Format-on-save via LSP formatter | Simplest integration with existing lsp-mode setup | — Pending |

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
*Last updated: 2026-03-25 after initialization*
