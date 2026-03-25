# Architecture Patterns

**Domain:** Emacs TypeScript/Next.js LSP Configuration
**Researched:** 2026-03-25

## Recommended Architecture

The config change is a surgical modification to an existing literate Emacs config (`emacs.d/config.org`). There are **three config blocks** that interact to produce a working TypeScript LSP setup, plus **one system dependency** that must be installed externally.

### High-Level Data Flow

```
 ┌──────────────────────────────────────────────────────────────────┐
 │  User opens .ts or .tsx file                                     │
 │                                                                  │
 │  auto-mode-alist: "\\.tsx?\\'" → typescriptreact-mode            │
 │  (typescriptreact-mode is derived from typescript-mode)          │
 └──────────────┬───────────────────────────────────────────────────┘
                │
                ▼
 ┌──────────────────────────────────────────────────────────────────┐
 │  Mode hooks fire:                                                │
 │  1. typescriptreact-mode-hook → calls (lsp)                     │
 │  2. typescript-mode-hook → also fires (parent mode)             │
 │  3. tree-sitter enables tsx parser via language-alist            │
 │  4. tsi-typescript-mode enables tree-sitter indentation          │
 └──────────────┬───────────────────────────────────────────────────┘
                │
                ▼
 ┌──────────────────────────────────────────────────────────────────┐
 │  lsp-mode activation:                                            │
 │  1. lsp-mode checks registered clients via activation-fn        │
 │  2. lsp-typescript-javascript-tsx-jsx-activate-p runs:           │
 │     - filename matches "\\.tsx?\\'" → YES                        │
 │     - OR derived-mode-p 'typescript-mode → YES                  │
 │  3. Client priority selects ts-ls (priority -2)                 │
 │     over jsts-ls (priority -3, deprecated)                      │
 └──────────────┬───────────────────────────────────────────────────┘
                │
                ▼
 ┌──────────────────────────────────────────────────────────────────┐
 │  ts-ls client starts:                                            │
 │  1. Spawns: typescript-language-server --stdio                   │
 │  2. Sends initializationOptions with tsserver path              │
 │  3. typescript-language-server spawns tsserver internally        │
 └──────────────┬───────────────────────────────────────────────────┘
                │
                ▼
 ┌──────────────────────────────────────────────────────────────────┐
 │  lsp-mode hooks fire:                                            │
 │  1. abram/lsp-mode-setup → configures breadcrumbs, lens, etc.  │
 │  2. abram/evil-lsp-keybindings → gd, gi, gr, gy, ,r            │
 │  3. lsp-ui-mode → UI enhancements                               │
 │  4. company-mode → completion                                    │
 │  5. lsp-origami-try-enable → folding                            │
 └──────────────────────────────────────────────────────────────────┘
                │
                ▼
 ┌──────────────────────────────────────────────────────────────────┐
 │  On save (new — needs adding):                                   │
 │  before-save-hook → lsp-format-buffer                            │
 │  (buffer-local, only in typescript/typescriptreact buffers)      │
 └──────────────────────────────────────────────────────────────────┘
```

### Component Boundaries

| Component | Location in config.org | Responsibility | Communicates With |
|-----------|----------------------|---------------|-------------------|
| **lsp-mode core** | Lines 1062–1088 (`** LSP` / `*** lsp-mode`) | Package install, global LSP settings, hook registration | All LSP client files, lsp-ui, lsp-ivy, company |
| **Evil LSP keybindings** | Lines 1145–1151 (`*** Code navigations & refactor using LSP`) | gd/gi/gr/gy/,r bindings auto-applied to any lsp-mode buffer | lsp-mode (via `lsp-mode-hook`) |
| **TypeScript block** | Lines 1531–1593 (`*** TypeScript`) | typescript-mode, typescriptreact-mode, auto-mode-alist, tree-sitter, LSP hooks, format-on-save | lsp-mode (via `#'lsp` hook), tree-sitter |
| **lsp-javascript.el** (internal) | `~/.emacs.d/straight/repos/lsp-mode/clients/lsp-javascript.el` | ts-ls client registration, activation-fn, server command construction | typescript-language-server binary (via stdio) |
| **tree-sitter** | Lines 1537–1545 (within TypeScript section) | Syntax highlighting with tsx parser | typescriptreact-mode (via language-alist) |
| **tsi.el** | Lines 1569–1582 (within TypeScript section) | Tree-sitter-based indentation | typescript-mode-hook |
| **Company mode** | Lines 1655–1672 (`** Company Mode`) | Completion UI | lsp-mode (via `lsp-mode-hook`) |
| **lsp-ui** | Lines 1096–1103 (`*** lsp-ui`) | Hover, sideline, doc UI | lsp-mode (via `lsp-mode-hook`) |
| **System: typescript-language-server** | Installed via `npm install -g` | LSP server binary, speaks LSP over stdio | tsserver (bundled with typescript npm package) |
| **System: typescript** | Installed via `npm install -g` | tsserver, type checking engine | typescript-language-server |

## The Core Problem and Fix

### What's Broken

The installed lsp-mode is at an **old commit** (bdae0f4, approximately 7.0.1-era) despite config.org specifying `:tag "v9.0.0"`. At this old version, the `ts-ls` client in `lsp-javascript.el` constructs the server command as:

```elisp
;; OLD (current installed, ~7.0.1-era):
`(,(lsp-package-path 'typescript-language-server)
  "--tsserver-path"                          ;; <-- THE PROBLEM
  ,(lsp-package-path 'typescript)
  ,@lsp-clients-typescript-server-args)
```

The `--tsserver-path` CLI argument was **removed in typescript-language-server v4.0.0** (released 2023). Any typescript-language-server v4.x+ installed via npm will reject this flag with `unknown option '--tsserver-path'`.

### What v9.0.0 Fixes

At tag `v9.0.0` (commit a478e03), the `ts-ls` client registration was updated:

```elisp
;; NEW (at v9.0.0 tag):
`(,(lsp-package-path 'typescript-language-server)
  ,@lsp-clients-typescript-server-args)      ;; No --tsserver-path!
```

The tsserver path is now passed via `initializationOptions`:

```elisp
:initialization-options (lambda ()
  (append
    ...
    `(:tsserver (:path ,(lsp-clients-typescript-server-path)
                 ,@lsp-clients-typescript-tsserver))))
```

This is compatible with typescript-language-server v4.x which expects tsserver location via initialization options, not CLI flags.

### Root Cause

straight.el was likely installed before the v9.0.0 tag existed, or the tag wasn't fetched. The `:tag` directive in straight.el only checks out the tag if it exists locally — it doesn't force a re-fetch. So the repo stayed at whatever commit it was originally cloned at.

## Patterns to Follow

### Pattern 1: Mode Hook for Format-on-Save (Buffer-Local)

**What:** Add `lsp-format-buffer` to `before-save-hook` buffer-locally in TypeScript mode hooks.

**When:** For any language where you want LSP-driven formatting on save.

**Why this pattern:** The Go config uses `gofmt-before-save` (a Go-specific formatter, not LSP-based). For TypeScript, we should use `lsp-format-buffer` directly since the LSP server (typescript-language-server → tsserver) provides the formatter. This matches the commented-out code in the disabled JavaScript block (line 1518).

**Example (recommended):**
```elisp
(use-package typescript-mode
  :after tree-sitter
  :config
  (define-derived-mode typescriptreact-mode typescript-mode "TypeScript TSX")
  (add-to-list 'auto-mode-alist '("\\.tsx?\\'" . typescriptreact-mode))
  (add-to-list 'tree-sitter-major-mode-language-alist '(typescriptreact-mode . tsx))
  :init
  (add-hook 'typescript-mode-hook #'lsp)
  (add-hook 'typescriptreact-mode-hook #'lsp)
  ;; Format-on-save via LSP
  (defun abram/lsp-format-on-save ()
    (add-hook 'before-save-hook #'lsp-format-buffer nil t))  ;; 't' = buffer-local
  (add-hook 'typescript-mode-hook #'abram/lsp-format-on-save)
  (add-hook 'typescriptreact-mode-hook #'abram/lsp-format-on-save))
```

**Why buffer-local:** The `t` argument to `add-hook` makes it buffer-local, so `lsp-format-buffer` only runs in TypeScript buffers, not globally. This prevents interfering with Go (which uses gofmt), Clojure (which uses cider-format), etc.

**Important note on hook inheritance:** `typescriptreact-mode` is derived from `typescript-mode`, so `typescript-mode-hook` fires for **both** .ts and .tsx files. However, explicitly adding both hooks is safer — it documents intent and avoids subtle issues if the hook registration order changes.

### Pattern 2: Keybindings Auto-Apply via lsp-mode-hook

**What:** The existing `abram/evil-lsp-keybindings` function is hooked into `lsp-mode-hook` (line 1079).

**When:** This pattern means **zero configuration needed** for keybindings when adding new LSP-enabled languages.

**Why this works:** When `(lsp)` or `(lsp-deferred)` activates in a TypeScript buffer, `lsp-mode-hook` fires, which calls `abram/evil-lsp-keybindings`, which sets `evil-local-set-key` for gd/gi/gr/gy/,r. No language-specific keybinding config needed.

**Implication:** The TypeScript block does NOT need any keybinding changes. Just getting LSP to activate properly means keybindings work automatically.

### Pattern 3: straight.el Tag Pinning with Force Rebuild

**What:** Update lsp-mode to actually use the v9.0.0 tag, not the stale checkout.

**When:** When a `:tag` directive in straight.el doesn't reflect what's installed.

**How:** After fixing the config.org, run in Emacs:
```
M-x straight-pull-package RET lsp-mode RET
M-x straight-rebuild-package RET lsp-mode RET
```
Or delete `~/.emacs.d/straight/repos/lsp-mode` and `~/.emacs.d/straight/build/lsp-mode` and restart Emacs.

## Anti-Patterns to Avoid

### Anti-Pattern 1: Global before-save-hook for lsp-format-buffer

**What:** Adding `(add-hook 'before-save-hook #'lsp-format-buffer)` without the buffer-local `t` flag.

**Why bad:** This would make every save in every buffer attempt `lsp-format-buffer`, which fails in non-LSP buffers (Org, Markdown, etc.) and could interfere with language-specific formatters (Go uses gofmt, not LSP format).

**Instead:** Always use buffer-local hooks: `(add-hook 'before-save-hook #'lsp-format-buffer nil t)`.

### Anti-Pattern 2: Separate auto-mode-alist for .ts vs .tsx

**What:** Mapping `.ts` to `typescript-mode` and `.tsx` to `typescriptreact-mode` separately.

**Why bad:** The current config intentionally maps **both** `.ts` and `.tsx` to `typescriptreact-mode` via `"\\.tsx?\\'"`. This is deliberate — `typescriptreact-mode` inherits everything from `typescript-mode`, and the tree-sitter tsx parser handles both syntaxes. Splitting them would create two code paths to maintain.

**Instead:** Keep the single `"\\.tsx?\\'"` → `typescriptreact-mode` mapping. It works for both.

### Anti-Pattern 3: Using lsp-deferred Instead of lsp for TypeScript

**What:** Changing `#'lsp` to `#'lsp-deferred` in TypeScript hooks.

**Why tempting but risky for this fix:** `lsp-deferred` delays LSP start until the buffer becomes visible. While this is fine for Go (which is what the Go block uses), during the **fix phase** it's better to use `#'lsp` (as currently configured) to get immediate feedback on whether the server starts correctly. Switch to `lsp-deferred` later if startup time matters.

### Anti-Pattern 4: Registering a Custom lsp-register-client for TypeScript

**What:** Adding a new `lsp-register-client` call in config.org to override the built-in ts-ls.

**Why bad:** The built-in ts-ls in lsp-mode v9.0.0 already works correctly. Adding a custom registration creates a maintenance burden and conflicts with future lsp-mode updates.

**Instead:** Update lsp-mode to v9.0.0 (which fixes the `--tsserver-path` issue) and use the built-in client.

## Config.org Block Modification Map

### Blocks That Need Changing

| Block | Lines | What to Change | Priority |
|-------|-------|---------------|----------|
| `*** lsp-mode` | 1062–1088 | Possibly update tag or remove `:tag` to use latest. Ensure straight.el fetches v9.0.0. | **P0 — Root cause fix** |
| `*** TypeScript` | 1553–1565 | Add format-on-save hook. Possibly switch `#'lsp` to `#'lsp-deferred` later. | **P1 — Feature addition** |

### Blocks That Must NOT Change

| Block | Lines | Why |
|-------|-------|-----|
| `*** Code navigations & refactor using LSP` | 1143–1152 | Keybindings auto-apply via lsp-mode-hook. No changes needed. |
| `*** lsp-ui` | 1096–1103 | Works for any LSP buffer. No changes needed. |
| `*** lsp-ivy` | 1134–1138 | Works for any LSP buffer. No changes needed. |
| `**** =go-mode=` | 1246–1265 | Must not break. Uses `lsp-deferred` and `gofmt-before-save`. |
| `*** Clojure` | 1396+ | Must not break. Uses lsp-mode independently. |
| `** Company Mode` | 1655–1672 | Works for any LSP buffer. No changes needed. |
| tree-sitter blocks | 1537–1545, 1569–1582 | Already correct for tsx syntax. No changes needed. |

### System Changes (Outside config.org)

| Action | What | Why |
|--------|------|-----|
| `npm install -g typescript-language-server typescript` | Install LSP server + tsserver | Required for lsp-mode ts-ls client to start |
| Verify correct binary resolves | `which typescript-language-server` should find the npm global binary | nvm may affect PATH; Emacs must see the same PATH |
| Rebuild lsp-mode in straight.el | `M-x straight-pull-package` or delete & re-clone | Get actual v9.0.0 code, not stale checkout |

## Suggested Implementation Order

Based on the architecture, the implementation order should be:

### Step 1: Fix lsp-mode version (root cause)

Update straight.el to actually use the v9.0.0 tag. This fixes the `--tsserver-path` error. All other changes are pointless without this.

**What to verify:** After rebuild, `lsp-javascript.el` should NOT contain `"--tsserver-path"` in the ts-ls command construction.

### Step 2: Install system dependencies

Install `typescript-language-server` and `typescript` globally via npm. Verify they're on Emacs's PATH (especially with nvm).

**What to verify:** `(executable-find "typescript-language-server")` returns a path in Emacs.

### Step 3: Test LSP activation

Open a `.ts` or `.tsx` file. lsp-mode should auto-activate, start `typescript-language-server`, and keybindings (gd, gi, gr, gy, ,r) should work.

**What to verify:** `M-x lsp-describe-session` shows an active ts-ls workspace.

### Step 4: Add format-on-save

Modify the TypeScript block to add `lsp-format-buffer` on `before-save-hook` (buffer-local). This is the only functional config.org edit beyond fixing the lsp-mode version.

**What to verify:** Save a TypeScript file → it gets formatted by the LSP server.

### Ordering Rationale

- Step 1 must come first — it's the root cause. Without v9.0.0, the server won't start.
- Step 2 must precede Step 3 — can't test what isn't installed.
- Step 3 must precede Step 4 — format-on-save depends on a working LSP connection.
- Steps 1 and 2 are **independent** and could be done in parallel.

## Scalability Considerations

| Concern | Current State | Future State |
|---------|--------------|-------------|
| Additional TS project types | typescriptreact-mode handles .ts + .tsx | If .mts/.cts needed, extend auto-mode-alist regex |
| Multiple LSP servers (e.g., eslint + ts) | Only ts-ls active | lsp-mode supports multiple servers per buffer; add eslint-ls later if needed |
| Prettier instead of tsserver formatter | tsserver built-in formatter | Would require switching to `prettier` via `apheleia` or `format-all`; out of scope |
| Emacs 29+ built-in tree-sitter | Currently uses external `tree-sitter` package | Emacs 29 has `typescript-ts-mode`; migration possible but separate effort |

## Sources

- **config.org** (lines 1054–1088, 1141–1151, 1505–1593): Direct examination of existing config — HIGH confidence
- **lsp-javascript.el at HEAD** (bdae0f4): Current installed version showing `--tsserver-path` in command — HIGH confidence
- **lsp-javascript.el at v9.0.0 tag** (a478e03): Shows fix removing `--tsserver-path` — HIGH confidence
- **lsp-mode.el at v9.0.0**: `lsp-format-buffer` implementation, `before-save-hook` integration — HIGH confidence
- **Git tag analysis**: `git describe --tags HEAD` → 7.0.1-658, confirming version mismatch — HIGH confidence
- **typescript-language-server v4.x changelog**: `--tsserver-path` removal (training data, verified by lsp-mode v9.0.0 changes) — MEDIUM confidence
