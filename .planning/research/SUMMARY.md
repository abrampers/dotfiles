# Project Research Summary

**Project:** Emacs TypeScript/Next.js LSP Setup
**Domain:** Emacs config fix (brownfield — surgical modification to literate config)
**Researched:** 2026-03-25
**Confidence:** HIGH

## Executive Summary

This is a **brownfield config fix**, not a greenfield project. The user has a fully working Emacs setup with lsp-mode for Go, and wants Go-parity LSP navigation (gd/gi/gr/gy/,r) plus format-on-save for TypeScript/Next.js files. The entire problem reduces to a single root cause: **a version mismatch between lsp-mode and typescript-language-server**. The installed lsp-mode (pinned via straight.el but likely running stale code from ~v7.0.1-era commit `bdae0f4`) passes `--tsserver-path` as a CLI argument, which typescript-language-server v4.0.0+ removed in favor of `initializationOptions`. The v9.0.0 tag already contains the fix. Every other feature — keybindings, completion, diagnostics — is already wired up and will activate automatically once the LSP server connection works.

The recommended approach is a **3-phase surgical fix**: (1) Diagnose the exact state — verify which lsp-mode commit is actually loaded and which typescript-language-server version is installed, since straight.el's lockfile and tag can disagree silently; (2) Fix the version mismatch — ensure straight.el actually loads v9.0.0 code, install typescript-language-server globally, verify PATH resolution in Emacs GUI; (3) Add format-on-save as the only new config.org feature. Total estimated effort is 1-2 hours, with the version diagnosis being the only real risk.

The key risk is **upgrading lsp-mode breaks Go/Clojure LSP**. lsp-mode is monolithic — all language clients ship in the same package. Mitigation: use the smallest version jump possible (the v9.0.0 tag, not bleeding-edge master), back up the straight.el lockfile before pulling, and immediately test Go LSP after the upgrade. A secondary risk is Node.js/nvm PATH not being visible to Emacs GUI — the user has `exec-path-from-shell` but may need to verify nvm PATH propagation.

## Key Findings

### Recommended Stack

The stack is almost entirely already in place. Only two changes are needed: update lsp-mode to actually load v9.0.0, and install typescript-language-server as a system dependency. See [STACK.md](STACK.md) for full details.

**Core technologies:**
- **lsp-mode v9.0.0** (unpin from stale lockfile): LSP client — the v9.0.0 tag fixes `--tsserver-path` to use `initializationOptions` instead of CLI args, compatible with typescript-language-server v4+
- **typescript-language-server v4.4.x or v5.1.x**: LSP server — use v4.4.x if on Node 18, v5.1.x if on Node 20+. Built-in lsp-mode client (`ts-ls`) requires zero configuration
- **apheleia + Prettier** (optional, for format-on-save): Async external formatter — preferred over `lsp-format-buffer` because most Next.js projects use Prettier with project-specific `.prettierrc` config

**Critical version constraint:** typescript-language-server v5.0.0+ requires Node.js 20+. Check `node --version` before installing.

**Do NOT use:** vtsls (no lsp-mode client exists), eglot (would rewrite entire LSP setup), built-in treesit (major migration, out of scope), rjsx-mode (obsolete).

### Expected Features

Almost everything is already implemented and just waiting for a working LSP connection. See [FEATURES.md](FEATURES.md) for the full feature landscape and dependency tree.

**Must have (table stakes — already wired, just need LSP connection):**
- LSP go-to-definition (gd), find-references (gr), find-implementation (gi), type-definition (gy), rename (,r) — all bound in `abram/evil-lsp-keybindings`, auto-applied via `lsp-mode-hook`
- Company-mode completion — hooked via `(lsp-mode . company-mode)`, auto-activates
- Flycheck diagnostics — configured via `(lsp-diagnostics-provider :flycheck)`, auto-activates
- Tree-sitter TSX syntax highlighting — already mapped via `tree-sitter-major-mode-language-alist`

**Must add (new capability):**
- Format-on-save — the only actual config.org feature addition needed. Use buffer-local `before-save-hook` with `lsp-format-buffer` or apheleia+Prettier

**Defer (v2+):**
- Organize imports on save, separate .ts vs .tsx mode routing, inlay type hints, Prettier integration (if LSP formatter suffices), ESLint LSP integration, Tailwind CSS LSP

### Architecture Approach

This is a surgical 2-block edit to an existing literate config (`config.org`), not a new architecture. The system has three interacting config blocks (lsp-mode core, Evil keybindings, TypeScript block) plus one external dependency (typescript-language-server). See [ARCHITECTURE.md](ARCHITECTURE.md) for the full data flow diagram and component map.

**Major components (existing, need no changes):**
1. **lsp-mode core** (config.org lines 1062-1088) — package install, global LSP settings, hook registration
2. **Evil LSP keybindings** (lines 1145-1151) — gd/gi/gr/gy/,r, auto-applied to any lsp-mode buffer
3. **TypeScript block** (lines 1531-1593) — typescript-mode, typescriptreact-mode, auto-mode-alist, tree-sitter, tsi.el indentation

**What changes:**
1. **lsp-mode recipe** — ensure straight.el loads v9.0.0 (or remove stale lockfile entry)
2. **TypeScript block** — add format-on-save hook (buffer-local `before-save-hook`)
3. **System** — `npm install -g typescript-language-server typescript`

**Must NOT change:** keybinding block, lsp-ui, lsp-ivy, Go mode, Clojure, Company mode, tree-sitter config.

### Critical Pitfalls

See [PITFALLS.md](PITFALLS.md) for all 11 pitfalls with full prevention strategies.

1. **straight.el tag vs lockfile disconnect** — The config says `:tag "v9.0.0"` but the lockfile pins commit `bdae0f4` (a different commit). straight.el prioritizes the lockfile. **Must verify actual loaded commit before any fix attempt** via `M-x lsp-version` or `(straight--get-recipe 'lsp-mode)`.
2. **Wrong direction of version mismatch** — The `--tsserver-path` error could mean lsp-mode is too old OR typescript-language-server is too old. **Must check BOTH versions** before applying any fix.
3. **lsp-mode upgrade breaks Go/Clojure** — lsp-mode is monolithic; upgrading changes all language clients. **Test Go LSP immediately after any lsp-mode change.** Back up lockfile first.
4. **Node.js/nvm PATH not visible to Emacs GUI** — `exec-path-from-shell` may not propagate nvm's PATH fully. **Verify `(executable-find "typescript-language-server")` returns a path in Emacs.**
5. **Global format-on-save breaks other languages** — Adding `lsp-format-buffer` without buffer-local flag causes double-formatting in Go. **Always use `(add-hook 'before-save-hook #'lsp-format-buffer nil t)` with the `t` flag.**

## Implications for Roadmap

Based on research, this is a **3-phase project** with a clear dependency chain. The phases are small (1-2 hours total) because most infrastructure already exists.

### Phase 1: Diagnose and Verify State
**Rationale:** Pitfalls #1 and #2 show that assumptions about versions are dangerous. The tag says v9.0.0 but the lockfile says a different commit. Must establish ground truth before changing anything.
**Delivers:** Confirmed versions of lsp-mode (actual loaded commit), typescript-language-server (if installed), Node.js version, and Emacs PATH state.
**Addresses:** Prerequisite validation — no features, but prevents wasted effort on wrong fixes.
**Avoids:** Pitfall 1 (tag vs lockfile disconnect), Pitfall 2 (wrong version direction), Pitfall 4 (PATH issues), Pitfall 11 (Node.js version).

### Phase 2: Fix LSP Connection + Format-on-Save
**Rationale:** This is the core fix. Everything depends on a working LSP server connection — all 5 navigation keybindings, completion, diagnostics activate automatically once LSP connects. Format-on-save is the only new config addition.
**Delivers:** Working TypeScript LSP with go-to-definition, find-references, find-implementation, type-definition, rename, completion, diagnostics, and format-on-save.
**Uses:** lsp-mode v9.0.0, typescript-language-server v4.4+/v5.1+, buffer-local before-save-hook pattern.
**Implements:** lsp-mode recipe fix + TypeScript block format-on-save addition.
**Avoids:** Pitfall 3 (regression testing Go/Clojure immediately), Pitfall 5 (clean up double hooks), Pitfall 9 (buffer-local format-on-save only).

### Phase 3: Verify and Polish
**Rationale:** Confirm all features work end-to-end across .ts and .tsx files, verify no regressions in Go/Clojure, and optionally address cosmetic issues.
**Delivers:** Fully verified TypeScript editing experience at Go-parity, documented in config.org.
**Addresses:** End-to-end validation, optional .ts vs .tsx mode separation, optional organize-imports-on-save.
**Avoids:** Pitfall 6 (TSX parser for .ts files — only fix if visible issues), Pitfall 8 (monorepo root — only if applicable).

### Phase Ordering Rationale

- **Phase 1 before Phase 2:** Diagnosis must happen first because the fix depends on knowing the actual state. If lsp-mode is already at v9.0.0 code, the fix is different (check typescript-language-server version instead).
- **Phase 2 is the core delivery:** All stated requirements (navigation + format-on-save) are delivered here. The keybindings and completion are pre-wired — they just need LSP to connect.
- **Phase 3 is optional polish:** The project is functionally complete after Phase 2. Phase 3 covers edge cases and verification.
- **Phases 1 and 2 could merge** if the diagnostic step is trivial (run 3-4 Emacs commands). They're separated for safety.

### Research Flags

Phases with standard patterns (skip `/gsd-research-phase`):
- **Phase 1 (Diagnose):** Standard Emacs introspection commands. Well-documented.
- **Phase 2 (Fix):** The version fix pattern is clear from STACK.md and ARCHITECTURE.md. Format-on-save is a documented pattern (Go setup is the reference).
- **Phase 3 (Polish):** Standard verification steps.

**No phases need deeper research.** This is a well-understood domain with high-confidence sources. The research has already identified the exact root cause, the exact fix, and the exact pitfalls.

## Confidence Assessment

| Area | Confidence | Notes |
|------|------------|-------|
| Stack | HIGH | Verified against lsp-mode source code, typescript-language-server release notes, and the user's actual lockfile. Root cause identified with specificity (PR #4202, commit hashes). |
| Features | HIGH | Features derived from existing config.org analysis + PROJECT.md explicit requirements. Dependency tree is clear: everything gates on LSP connection. |
| Architecture | HIGH | Based on direct examination of config.org, lsp-javascript.el source at multiple commits, and straight.el lockfile. Data flow fully traced. |
| Pitfalls | HIGH | 4 critical, 5 moderate, 2 minor pitfalls identified. Critical pitfalls verified against official sources (GitHub PRs, release notes, lockfile). |

**Overall confidence:** HIGH

### Gaps to Address

- **Actual loaded lsp-mode commit:** Research identified that the lockfile pins `bdae0f4` while the tag is v9.0.0 — but we haven't confirmed which code is *actually running*. Phase 1 must verify this in a live Emacs session.
- **User's Node.js version:** Unknown. Determines whether to install typescript-language-server v4.x (Node 18) or v5.x (Node 20+).
- **User's project structure:** Unknown if monorepo or single Next.js app. Affects whether Pitfall 8 (root detection) matters.
- **Prettier vs LSP formatter preference:** STACK.md recommends apheleia+Prettier, FEATURES.md suggests `lsp-format-buffer` as simpler MVP. The choice depends on whether the project has a `.prettierrc` — start with `lsp-format-buffer`, switch to apheleia if formatting doesn't match team conventions.

## Sources

### Primary (HIGH confidence)
- lsp-mode lsp-javascript.el source (v9.0.0 tag vs old commit) — confirmed root cause
- lsp-mode CHANGELOG.org and PR #4202 — tsserver-path fix timeline
- typescript-language-server releases (v4.0.0, v4.1.0, v5.0.0) — breaking changes and Node requirements
- User's config.org — existing setup analysis
- User's straight.el lockfile (default.el) — actual pinned commits

### Secondary (MEDIUM confidence)
- Doom Emacs issue #7540 — same problem pattern in another Emacs distribution
- Community consensus on apheleia vs format-all-mode for async formatting
- tree-sitter vs treesit migration complexity assessment

### Tertiary (LOW confidence)
- tsi.el maintenance status — not verified, assumed working based on existing config

---
*Research completed: 2026-03-25*
*Ready for roadmap: yes*
