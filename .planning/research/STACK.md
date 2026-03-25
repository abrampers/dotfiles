# Technology Stack: Emacs TypeScript/Next.js LSP

**Project:** Emacs Next.js/TypeScript LSP Setup
**Researched:** 2026-03-25
**Overall Confidence:** HIGH (verified against official sources)

## Root Cause Analysis

The `error: unknown option '--tsserver-path'` is caused by a version mismatch:

- **lsp-mode v9.0.0** (pinned via `straight.el :tag "v9.0.0"`) passes `--tsserver-path` as a **CLI argument** when starting typescript-language-server.
- **typescript-language-server v4.0.0** (Oct 2023) removed CLI options including `--tsserver-path` in favor of `initializationOptions.tsserver.path`.
- **typescript-language-server v4.1.0** (Nov 2023) explicitly removed deprecated CLI options in [PR #790](https://github.com/typescript-language-server/typescript-language-server/issues/790).
- **lsp-mode master (unreleased 9.0.1)** already fixed this by sending the tsserver path via `initializationOptions` instead of CLI args (see the `:tsserver (:path ...)` in initialization-options lambda in `lsp-javascript.el`).

**Confidence: HIGH** — Verified by reading both the lsp-mode source code (`lsp-javascript.el`) and the typescript-language-server release notes.

---

## Recommended Stack

### Primary Recommendation: Upgrade lsp-mode to master (unpin the tag)

| Technology | Version | Purpose | Why |
|------------|---------|---------|-----|
| **lsp-mode** | master (head) | LSP client | Unpinning from v9.0.0 to master gets the `initializationOptions`-based tsserver path passing, which is compatible with typescript-language-server v4+. There is no v9.0.1 release yet — lsp-mode develops on master with infrequent releases. |
| **typescript-language-server** | v4.4.x (latest v4 stable) | TypeScript LSP server | Actively maintained, 2.4k stars, is the standard TS language server for non-VSCode editors. v4.4.1 is the last v4 release before v5 (which requires Node 20+). |
| **typescript** | ^5.x (project-local) | TypeScript compiler/tsserver | Bundled with your Next.js project. typescript-language-server uses this internally. |
| **typescript-mode** | latest | Emacs major mode for .ts | Already installed. Provides the base major mode. |
| **tree-sitter + tree-sitter-langs** | latest | Syntax highlighting | Already installed. Keep the existing tree-sitter stack — don't switch to built-in treesit yet (see below). |
| **apheleia** | latest | Format-on-save | Use instead of `lsp-format-buffer` because Prettier is the standard formatter for Next.js/TS projects, and apheleia runs it asynchronously without blocking Emacs. |

### LSP Server Choice: typescript-language-server (ts-ls)

**Use typescript-language-server, not vtsls.** Rationale:

1. **lsp-mode has built-in ts-ls client** — `lsp-javascript.el` has a full, mature integration (server-id `ts-ls`) with initialization options, custom settings, inlay hints, code lens, and more. Zero configuration needed beyond installing the npm package.
2. **vtsls has NO built-in lsp-mode client** — you'd have to manually register a client via `lsp-register-client`, configure `initializationOptions`, custom settings, etc. This is significant effort for no clear benefit in this use case.
3. **typescript-language-server is actively maintained** — v5.1.3 released Nov 2025, regular releases, 2.4k stars.
4. **vtsls is Neovim-focused** — editor integrations documented only for Neovim (`nvim-lspconfig`, `nvim-vtsls`). No Emacs integration exists.

**Confidence: HIGH** — Verified by reading lsp-mode source and vtsls README directly.

### Format-on-save: apheleia with Prettier

| Technology | Version | Purpose | Why |
|------------|---------|---------|-----|
| **apheleia** | latest | Async format-on-save | Runs formatters (like Prettier) asynchronously, so Emacs doesn't freeze. Better than `lsp-format-buffer` for TS/Next.js because: (1) Prettier is the standard formatter, not tsserver's built-in formatter; (2) async execution; (3) respects project `.prettierrc` config. |
| **prettier** | project-local | TypeScript/TSX formatter | Already part of any Next.js project. apheleia calls it automatically. |

**Alternatives NOT recommended:**

| Approach | Why Not |
|----------|---------|
| `lsp-format-buffer` / `lsp-format-on-save-mode` | Uses tsserver's built-in formatter, which is inferior to Prettier for Next.js projects. Most Next.js projects use Prettier with project-specific config. |
| `format-all-mode` | Synchronous — blocks Emacs while formatting. apheleia does the same thing but async. |
| `prettier-js-mode` | Abandoned/unmaintained. apheleia subsumes it. |

**Confidence: MEDIUM** — Standard community recommendation for Emacs formatting, but the user could also use `lsp-format-buffer` if they don't use Prettier.

### Tree-sitter: Keep existing tree-sitter (NOT treesit)

| Decision | Rationale |
|----------|-----------|
| Keep `tree-sitter` + `tree-sitter-langs` packages | The user already has a working setup with `tree-sitter-mode`, `tree-sitter-hl-mode`, `tsi.el` for indentation, and the `typescriptreact-mode` derived from `typescript-mode` with tsx parser mapping. |
| Do NOT switch to built-in `treesit` (Emacs 29+) | Switching requires: (1) new major modes (`typescript-ts-mode`, `tsx-ts-mode`); (2) re-wiring all LSP hooks; (3) re-configuring auto-mode-alist; (4) finding a treesit-compatible indentation solution (tsi.el is tree-sitter-specific); (5) verifying tree-sitter grammar availability. This is a significant migration for marginal benefit and is OUT OF SCOPE per PROJECT.md. |

**Confidence: HIGH** — Based on the existing config.org state and the project's "minimal disruption" constraint.

---

## Version Compatibility Matrix

### lsp-mode vs typescript-language-server

| lsp-mode version | ts-ls CLI behavior | Compatible ts-ls versions | Notes |
|------------------|--------------------|---------------------------|-------|
| **v9.0.0** (pinned tag, April 2024) | Passes `--tsserver-path` as CLI arg | **v3.3.x and older ONLY** | v4.0.0+ removed `--tsserver-path` CLI flag |
| **master (unreleased 9.0.1)** | Passes tsserver path via `initializationOptions.tsserver.path` | **v4.0.0+, v5.x** | Fixed. Also supports `lsp-clients-typescript-prefer-use-project-ts-server` and `lsp-clients-typescript-tsserver` plist. |

### typescript-language-server version history (breaking changes)

| Version | Date | Key Change | Node Requirement |
|---------|------|------------|------------------|
| v3.3.2 | Apr 2023 | Last v3 release | Node 14+ |
| **v4.0.0** | Oct 2023 | **BREAKING: require Node 18+**. Removed `--tsserver-path` CLI arg. tsserver path now via `initializationOptions`. | Node 18+ |
| v4.1.0 | Nov 2023 | Explicitly removed deprecated CLI options (#790) | Node 18+ |
| v4.4.1 | Sep 2025 | Last v4 release | Node 18+ |
| **v5.0.0** | Sep 2025 | **BREAKING: require Node 20+** | Node 20+ |
| v5.1.3 | Nov 2025 | Latest release | Node 20+ |

### Recommended version combination

| Component | Version | Constraint |
|-----------|---------|------------|
| lsp-mode | master (unpin tag) | Required for ts-ls v4+ compatibility |
| typescript-language-server | v4.4.x or v5.1.x | v4.4.x if on Node 18; v5.1.x if on Node 20+ |
| typescript | ^5.x | Use project-local TypeScript |
| Node.js | 20+ (via nvm) | v5.0.0+ requires Node 20 |

**Confidence: HIGH** — Version requirements verified from release notes on GitHub.

---

## Installation

### 1. Update lsp-mode (unpin from v9.0.0)

In `config.org`, change the straight.el recipe:

```emacs-lisp
;; BEFORE (broken with ts-ls v4+):
(use-package lsp-mode
  :straight (:host github
             :repo "emacs-lsp/lsp-mode"
             :branch "master"
             :tag "v9.0.0")
  ...)

;; AFTER (tracks master, compatible with ts-ls v4+):
(use-package lsp-mode
  :straight (:host github
             :repo "emacs-lsp/lsp-mode"
             :branch "master")
  ...)
```

### 2. Install typescript-language-server and typescript

```bash
# If using Node 20+ (check with: node --version)
npm install -g typescript-language-server typescript

# If on Node 18, pin to v4 series:
npm install -g typescript-language-server@4 typescript
```

### 3. Install apheleia for format-on-save

```emacs-lisp
(use-package apheleia
  :hook (typescript-mode . apheleia-mode)
  :hook (typescriptreact-mode . apheleia-mode))
```

Apheleia auto-detects Prettier if it's in your project's `node_modules/.bin/`.

### 4. Verify

After restarting Emacs:
1. Open a `.ts` or `.tsx` file in a Next.js project
2. Check `*lsp-log*` buffer for successful ts-ls connection
3. Test `gd` (go-to-definition) on a symbol
4. Test format-on-save by saving a file

---

## Alternatives Considered

| Category | Recommended | Alternative | Why Not Alternative |
|----------|-------------|-------------|---------------------|
| LSP client | lsp-mode (master) | eglot (built-in Emacs 29+) | Would require rewriting all keybindings, losing lsp-ui, lsp-treemacs, lsp-ivy integrations. Massive disruption for a working setup. |
| LSP server | typescript-language-server | vtsls | No lsp-mode client exists. Would need manual `lsp-register-client`. Neovim-focused project. |
| LSP server | typescript-language-server | deno-ls | Only for Deno projects, not Next.js/Node.js TypeScript. |
| Format-on-save | apheleia + prettier | `lsp-format-buffer` | tsserver's formatter is inferior to Prettier for Next.js. Most projects have `.prettierrc`. |
| Format-on-save | apheleia + prettier | format-all-mode | Synchronous — blocks Emacs during formatting. |
| Tree-sitter | tree-sitter pkg | built-in treesit | Major migration effort, breaks existing tsi.el/typescript-mode/typescriptreact-mode setup. |
| lsp-mode version | master (unpin) | Pin to specific commit | lsp-mode doesn't do frequent stable releases. Master is what the community tracks. The alternative is to pin to a specific commit hash after testing. |

---

## What NOT to Use

| Technology | Why Not |
|------------|---------|
| **lsp-mode v9.0.0 (pinned tag)** | Incompatible with typescript-language-server v4+. This IS the bug. |
| **typescript-language-server v3.x** | Downgrading to v3.x would "fix" the error but is a dead end — v3.3.2 was the last release (April 2023), over 2 years old. You'd miss 2+ years of bug fixes, performance improvements, and features. |
| **vtsls** | No lsp-mode integration. Would require significant manual client registration. Primarily targets Neovim. |
| **eglot** | Would require completely rewriting the LSP integration. lsp-mode works fine — the issue is just a version pin. |
| **prettier-js-mode** | Unmaintained. Use apheleia instead. |
| **built-in treesit** | Not worth the migration cost for this project. Keep existing tree-sitter setup. |
| **rjsx-mode** | Already disabled in config.org. Superseded by typescript-mode + tree-sitter tsx parser. |

---

## Risk Assessment

### Upgrading lsp-mode to master

**Risk: LOW-MEDIUM.** lsp-mode master could break something in the Go, Clojure, or other language setups. Mitigation:

1. After updating, test Go LSP (`gopls`) still works — open a `.go` file, verify `gd` works.
2. Test Clojure LSP still works if used.
3. If something breaks, pin to a specific commit hash instead of `master`:
   ```emacs-lisp
   :straight (:host github :repo "emacs-lsp/lsp-mode" :branch "master"
              :commit "SPECIFIC_HASH")
   ```

### Alternative: Pin lsp-mode to a known-good commit

If upgrading to master is too risky, find the specific commit that added the `initializationOptions.tsserver.path` fix and pin to that. This would require git log investigation on the lsp-mode repo.

---

## Sources

| Source | Type | Confidence | URL |
|--------|------|------------|-----|
| lsp-mode CHANGELOG.org | Official | HIGH | https://github.com/emacs-lsp/lsp-mode/blob/master/CHANGELOG.org |
| lsp-mode lsp-javascript.el (master) | Official source | HIGH | https://github.com/emacs-lsp/lsp-mode/blob/master/clients/lsp-javascript.el |
| typescript-language-server releases | Official | HIGH | https://github.com/typescript-language-server/typescript-language-server/releases |
| typescript-language-server v4.0.0 | Official release | HIGH | https://github.com/typescript-language-server/typescript-language-server/releases/tag/v4.0.0 |
| typescript-language-server v4.1.0 (CLI removal) | Official release | HIGH | https://github.com/typescript-language-server/typescript-language-server/releases/tag/v4.1.0 |
| vtsls README | Official | HIGH | https://github.com/yioneko/vtsls |
| lsp-mode releases (v9.0.0 = April 2024) | Official | HIGH | https://github.com/emacs-lsp/lsp-mode/releases |
| User config.org | Primary context | HIGH | emacs.d/config.org |
