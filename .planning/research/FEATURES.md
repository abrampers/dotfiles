# Feature Landscape

**Domain:** Emacs TypeScript/Next.js LSP Editing Setup
**Researched:** 2026-03-25
**Scope:** Brownfield fix — achieving Go-parity LSP navigation + format-on-save for .ts/.tsx files

## Table Stakes

Features the user explicitly needs. Missing = the setup is broken relative to stated goals.

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| **LSP go-to-definition (gd)** | Explicit requirement; works for Go | Low | `lsp-find-definition` — already bound in `abram/evil-lsp-keybindings`. Just needs working LSP server connection. |
| **LSP find-references (gr)** | Explicit requirement; works for Go | Low | `lsp-find-references` — already bound. Provided by typescript-language-server out of the box. |
| **LSP find-implementation (gi)** | Explicit requirement; works for Go | Low | `lsp-find-implementation` — already bound. Works for TS interfaces/classes via tsserver. |
| **LSP type-definition (gy)** | Explicit requirement; works for Go | Low | `lsp-find-type-definition` — already bound. Jump to the type of a symbol. |
| **LSP rename (,r)** | Explicit requirement; works for Go | Low | `lsp-rename` — already bound. typescript-language-server provides project-wide rename. |
| **Working LSP server connection** | Nothing works without it | Medium | The core blocker. lsp-mode v9.0.0 passes `--tsserver-path` which typescript-language-server v4.x removed. Must resolve version mismatch. |
| **Correct auto-mode-alist routing** | .ts and .tsx must open in correct modes | Low | Currently `\.tsx?\` maps both to `typescriptreact-mode`. May need separate routing for .ts vs .tsx (see Pitfalls). |
| **Tree-sitter TSX syntax highlighting** | Already configured; regression = broken | Low | `tree-sitter-major-mode-language-alist` maps `typescriptreact-mode` to TSX parser. Already works if modes load correctly. |
| **Format-on-save** | Explicit requirement | Medium | Not yet implemented for TS. Go uses `gofmt-before-save`. TS needs `lsp-format-buffer` on `before-save-hook` or external formatter (prettier). |
| **Flycheck diagnostics** | Already configured globally via lsp-mode | Low | `lsp-diagnostics-provider` is set to `:flycheck`. Will auto-activate once LSP connects. Inline errors, squiggly lines. |
| **Company-mode completion** | Already configured globally | Low | `company-mode` hooks into `lsp-mode` buffers. Auto-activates with `company-idle-delay 0.0`. Will work once LSP connects. |

## Differentiators

Features that improve the editing experience beyond the stated requirements. Not expected, but valued.

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| **Auto-import on completion** | Saves manual import typing; high-value for React/Next.js codebases with many imports | Low | Already enabled by default: `lsp-typescript-suggest-auto-imports t`. typescript-language-server adds import when you accept a completion candidate. |
| **Organize imports on save** | Removes unused imports, sorts remaining | Low | `lsp-organize-imports` on `before-save-hook`. User already had this commented out in old JS block. Pairs naturally with format-on-save. |
| **Code actions (quick fixes)** | "Add missing import", "Remove unused variable", etc. | Low | Available via `lsp-execute-code-action` (bound to `C-c l a a` by default). No config needed — just awareness. |
| **lsp-ui-doc hover** | Show type info/docs on hover | Low | Currently disabled (`lsp-ui-doc-enable nil`). User can toggle later. Some find it noisy. |
| **Inlay type hints** | Show inferred types inline (e.g., `const x /* : string */ = ...`) | Medium | Via `lsp-javascript-display-variable-type-hints`, `lsp-javascript-display-return-type-hints`, etc. All default to `nil`. Useful but can be visually noisy. |
| **Electric pair / auto-close tags** | Auto-close JSX tags like `<div>` -> `</div>` | Low | `lsp-typescript-auto-closing-tags` defaults to `t` in lsp-mode. Works via LSP `onTypeFormatting`. `electric-pair-local-mode` for regular bracket pairing (used in Go, not yet hooked for TS). |
| **Separate .ts vs .tsx mode routing** | .ts files don't need TSX parser overhead; cleaner separation | Low-Medium | Currently both .ts and .tsx map to `typescriptreact-mode`. Could map .ts to `typescript-mode` and only .tsx to `typescriptreact-mode`. Avoids potential false-positive JSX parsing in pure .ts files. |
| **lsp-ivy workspace symbol search** | Fuzzy-find symbols across project | Low | Already installed (`lsp-ivy`). Access via `lsp-ivy-workspace-symbol`. No additional config needed. |
| **Prettier as external formatter** | Matches team formatting (most Next.js projects use Prettier) | Medium | Alternative to LSP built-in formatter. Would need `prettier-js` package or `apheleia` for async formatting. More complex than `lsp-format-buffer` but more likely to match project conventions. |
| **Complete function calls with signatures** | Insert parentheses and parameter placeholders on function completion | Low | `lsp-javascript-completions-complete-function-calls` defaults to `t`. Already active. |
| **Path completion in imports** | Autocomplete file paths in `import ... from './...'` | Low | `lsp-typescript-suggest-paths` defaults to `t`. Already active by default. |

## Anti-Features

Features commonly added to Emacs TypeScript setups that are problematic in this context.

| Anti-Feature | Why Avoid | What to Do Instead |
|--------------|-----------|-------------------|
| **ESLint LSP integration** | Explicitly out of scope in PROJECT.md. Adds a second language server, doubles memory usage, adds complexity. ESLint diagnostics can conflict with TypeScript diagnostics. | Rely on tsserver diagnostics only. Run ESLint in CI or terminal. |
| **web-mode for TSX** | Often recommended for JSX/TSX. Replaces `typescript-mode` entirely, loses tree-sitter integration, different indentation engine, different syntax highlighting. Incompatible with current setup built on `typescript-mode` + tree-sitter. | Keep `typescript-mode` + `typescriptreact-mode` (derived) with tree-sitter TSX parser. This is already configured correctly. |
| **rjsx-mode** | Already disabled in config (`:tangle no`). Based on `js2-mode` which has its own parser — conflicts with tree-sitter and LSP. Old approach from pre-tree-sitter era. | Keep disabled. Use `typescript-mode` derivatives + tree-sitter. |
| **Multiple LSP servers simultaneously** | Running ts-ls + eslint-ls + tailwind-ls + emmet-ls. Each adds memory, startup time, and potential conflicts. Some have overlapping capabilities (formatting, diagnostics). | Start with ts-ls only. Add others individually only if specific pain points arise. |
| **Tailwind CSS LSP** | Out of scope per PROJECT.md ("Full Next.js DX... just LSP nav + format"). Adds complexity for className completions the user didn't ask for. | Skip entirely. Add later if needed. |
| **JSX/TSX snippet libraries (yasnippet templates)** | Out of scope ("JSX snippets" explicitly excluded). Snippets can interfere with company-mode completion ordering. | Skip. Let LSP completion handle it. |
| **Switching to eglot** | Emacs 29+ ships eglot as built-in. Some recommend it over lsp-mode. But this user has a fully configured lsp-mode setup with keybindings, lsp-ui, lsp-treemacs, lsp-ivy — switching means rewriting the entire LSP infrastructure. | Keep lsp-mode. The problem is version mismatch, not the LSP client. |
| **Upgrading to Emacs 29+ built-in tree-sitter (treesit)** | Emacs 29 has native tree-sitter support (`typescript-ts-mode`, `tsx-ts-mode`). Tempting but requires: new grammar build system, different mode names, re-mapping all hooks, potentially breaking other language configs (Go, Clojure). Major migration for uncertain gain. | Keep current `tree-sitter` + `tree-sitter-langs` packages. They work. Revisit as a separate project. |
| **lsp-mode master branch (unpinned)** | Removing the v9.0.0 pin to get "latest" lsp-mode. Risks breaking Go, Clojure, or other language LSP setups with untested changes. | Pin to a specific known-good version (research which version works with typescript-language-server v4.x). |
| **Global before-save-hook for formatting** | Adding `lsp-format-buffer` to global `before-save-hook` would format ALL file types, potentially breaking non-TS buffers. | Use mode-specific hook: add to `typescript-mode-hook` or `typescriptreact-mode-hook` only. |
| **Copilot / AI completion conflicts** | User has GitHub Copilot configured. Multiple completion sources (copilot + company + LSP) can fight for the same keybindings and visual space. | Be aware of interaction but don't try to "fix" it proactively. Current setup likely has Copilot as overlay + company as popup — they coexist. |

## Feature Dependencies

```
Working LSP server connection
  ├── go-to-definition (gd)
  ├── find-references (gr)
  ├── find-implementation (gi)
  ├── type-definition (gy)
  ├── rename (,r)
  ├── company-mode completion (auto-import, path completion, function calls)
  ├── flycheck diagnostics
  ├── code actions
  ├── organize imports
  └── format-on-save (via lsp-format-buffer)

Correct auto-mode-alist
  ├── typescript-mode / typescriptreact-mode activation
  │     └── tree-sitter TSX parser selection
  │     └── LSP hooks fire (#'lsp)
  │           └── Working LSP server connection (above)
  └── tsi.el indentation

format-on-save
  ├── EITHER lsp-format-buffer (depends on LSP connection)
  └── OR external formatter like prettier (independent of LSP)

electric-pair-local-mode (independent — no LSP dependency)
```

**Key insight:** Almost everything depends on getting the LSP server connection working. The five keybinding features (gd/gi/gr/gy/,r) are already defined and hooked — they activate automatically in any buffer where lsp-mode starts. The entire problem reduces to: **make lsp-mode successfully connect to a working typescript-language-server for .ts/.tsx files**.

## MVP Recommendation

### Must fix first (everything else depends on it):
1. **LSP server connection** — Resolve lsp-mode v9.0.0 `--tsserver-path` incompatibility with typescript-language-server v4.x. This is the single blocker.

### Then verify (should "just work" once LSP connects):
2. **gd/gi/gr/gy/,r keybindings** — Already defined in `abram/evil-lsp-keybindings`, hooked via `(lsp-mode . abram/evil-lsp-keybindings)`. Test, don't re-implement.
3. **Company-mode completion** — Already hooked via `(lsp-mode . company-mode)`. Verify it shows TypeScript completions.
4. **Flycheck diagnostics** — Already configured via `(lsp-diagnostics-provider :flycheck)`. Verify inline errors appear.

### Then add (new capability):
5. **Format-on-save** — Add `lsp-format-buffer` to `before-save-hook` in TypeScript mode hooks. Simple, mirrors the Go approach (which uses `gofmt-before-save`).

### Defer (nice-to-have, not needed for MVP):
- **Organize imports on save** — Easy to add alongside format-on-save, but not explicitly requested. Could be phase 2.
- **Separate .ts vs .tsx mode routing** — Current "everything is typescriptreact-mode" works. Optimize later.
- **Inlay hints** — Visual noise for most users. Enable per-preference.
- **Prettier integration** — Only needed if LSP formatter output doesn't match project conventions.
- **Electric pair mode for TS** — Not requested but trivial to add if desired.

## Complexity Assessment

| Feature Group | Estimated Effort | Risk |
|--------------|-----------------|------|
| Fix LSP server connection | 30-60 min | Medium — version compatibility research needed |
| Verify navigation keybindings | 5-10 min | Low — already implemented, just needs working LSP |
| Verify completion + diagnostics | 5-10 min | Low — global hooks, auto-activates |
| Add format-on-save | 10-15 min | Low — well-understood pattern (Go has it) |
| Auto-mode-alist fix (if needed) | 10-15 min | Low — regex change |
| **Total estimated** | **~1-2 hours** | **Medium overall (LSP version fix is the risk)** |

## Sources

- Existing config analysis: `emacs.d/config.org` lines 1064-1151 (lsp-mode, keybindings), 1553-1583 (TypeScript), 1659-1674 (company), 1181-1194 (flycheck), 1248-1260 (Go reference setup)
- lsp-mode TypeScript configuration: https://emacs-lsp.github.io/lsp-mode/page/lsp-typescript/ — HIGH confidence (official lsp-mode docs)
- typescript-language-server capabilities: https://github.com/typescript-language-server/typescript-language-server — MEDIUM confidence (training data, needs version verification)
- PROJECT.md explicit scope/constraints — HIGH confidence (user-defined)
