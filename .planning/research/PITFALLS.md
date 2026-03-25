# Domain Pitfalls

**Domain:** Emacs TypeScript/Next.js LSP setup (brownfield — fixing existing config)
**Researched:** 2026-03-25

## Critical Pitfalls

Mistakes that cause LSP to not start, break other languages, or require config rewrites.

### Pitfall 1: straight.el Tag vs Commit Hash Disconnect

**What goes wrong:** The config specifies `:tag "v9.0.0"` for lsp-mode, but `straight/versions/default.el` pins the actual commit hash `bdae0f4`. straight.el prioritizes the lockfile hash over the `:tag` directive. If the lockfile was frozen before the tag was created, the user may be running code from *before* the tag despite the config saying otherwise. Conversely, if `M-x straight-pull-package` is run without updating the lockfile, the running code diverges from what the lockfile records.

**Why it happens:** straight.el's version pinning system uses two independent mechanisms: (1) the recipe in `use-package` (`:tag`, `:branch`), and (2) the lockfile (`default.el`) which records commit hashes. These can disagree silently. The user's lockfile shows `lsp-mode` pinned to commit `bdae0f4` (a semantic-tokens change), which is a commit on master — the v9.0.0 tag points to commit `a478e03` (created Apr 6, 2024). These are **different commits**.

**Consequences:** The user thinks they're on v9.0.0 but may be on a different commit entirely. The `--tsserver-path` fix (PR #4202, merged Oct 2023) is included in v9.0.0 tag, meaning the tag *should* have the fix. But if straight.el loaded a different commit, the fix may or may not be present depending on the actual commit's position in history.

**Prevention:**
1. Before changing anything, verify which lsp-mode commit is actually loaded: `M-x lsp-version` or check `(straight--get-recipe 'lsp-mode)` in a scratch buffer
2. After updating the `:tag` in config.org, MUST also run `M-x straight-freeze-versions` to update the lockfile hash
3. Alternatively, remove the `:tag` constraint entirely and pin via lockfile only (simpler mental model)

**Detection:** `M-: (straight--get-recipe 'lsp-mode)` shows the resolved recipe. `*Messages*` buffer shows what straight.el actually fetched at startup.

**Confidence:** HIGH — verified from the actual lockfile (`default.el` line 61) and lsp-mode tags page.

**Phase relevance:** Phase 1 (diagnostic) — must verify actual running version before any fix attempt.

---

### Pitfall 2: lsp-mode v9.0.0 Tag DOES Include the tsserver-path Fix — The Bug May Be Elsewhere

**What goes wrong:** Users assume the `--tsserver-path` error means lsp-mode is too old, but the v9.0.0 tag (Apr 2024) includes PR #4202 (merged Oct 2023) and PR #4333 (merged May 2024). The actual v9.0.0 tag already uses `initializationOptions.tsserver.path` instead of `--tsserver-path` CLI arg. If the user's straight.el is actually loading the v9.0.0 tag code correctly, then the error must come from somewhere else — such as the installed `typescript-language-server` binary being too old (pre-v4.0) which expects the old `--tsserver-path` flag.

**Why it happens:** The symptom `unknown option '--tsserver-path'` can come from two directions:
- **lsp-mode too old:** Sends `--tsserver-path` CLI arg to typescript-language-server v4+ which removed that CLI arg
- **typescript-language-server too old:** Running a pre-v4.0 version that doesn't understand the new `initializationOptions` format from modern lsp-mode

Both produce confusing errors. Without checking BOTH versions, the wrong fix gets applied.

**Consequences:** Time wasted upgrading lsp-mode when the real issue is the `typescript-language-server` npm binary version, or vice versa.

**Prevention:**
1. Check `typescript-language-server --version` in shell to confirm installed version
2. Check `M-x lsp-version` or examine which `lsp-javascript.el` code is loaded
3. Match the pair: lsp-mode v9.0.0+ works with typescript-language-server v4.x+. lsp-mode master (2025+) works with v4.x and v5.x
4. The current latest typescript-language-server is v5.1.3 (Nov 2025) — v5.0.0 requires Node.js 20+

**Detection:** In `*lsp-log*` buffer, look for the actual command-line invocation and initialization options sent to the server.

**Confidence:** HIGH — verified from lsp-mode PR #4202 merge date, v9.0.0 tag date, and current `lsp-javascript.el` master source code.

**Phase relevance:** Phase 1 (diagnostic) — must verify both versions before applying any fix.

---

### Pitfall 3: Upgrading lsp-mode Breaks Go/Clojure LSP

**What goes wrong:** Updating lsp-mode to fix TypeScript breaks gopls or clojure-lsp. lsp-mode is a single package containing ALL language clients (Go, Clojure, TypeScript, etc.) in separate files under `clients/`. Upgrading the commit/tag changes all language clients simultaneously. A new lsp-mode version might change gopls initialization options, command-line arguments, or server capability handling.

**Why it happens:** lsp-mode is monolithic — `lsp-go.el`, `lsp-clojure.el`, and `lsp-javascript.el` all ship in the same repo. No way to upgrade just the TypeScript client independently. The user's working Go setup depends on the specific lsp-mode commit in the lockfile.

**Consequences:** Go-to-definition stops working in Go files. Clojure LSP fails to connect. The user now has two broken languages instead of one.

**Prevention:**
1. **Test immediately after upgrade:** Open a `.go` file and verify `gd` still works before committing the config change
2. **Check lsp-mode CHANGELOG** for breaking changes to Go and Clojure clients between the old and new versions
3. **Pin gopls and clojure-lsp versions** explicitly in config via `lsp-go-gopls-server-path` (already done) and `lsp-clojure-server-command` (already done with `'("bash" "-c" "clojure-lsp")`)
4. **Prefer the smallest lsp-mode version jump** that fixes TypeScript — don't jump to bleeding-edge master if v9.0.0 tag already has the fix
5. **Back up the lockfile** before `straight-pull-package`: `cp straight/versions/default.el straight/versions/default.el.bak`

**Detection:** After upgrading, test each language:
- Go: open `.go` file, wait for LSP, try `gd`
- Clojure: open `.clj` file, verify clojure-lsp connects
- TypeScript: open `.ts` file, verify no `--tsserver-path` error

**Confidence:** HIGH — this is a well-documented issue across the Emacs community. The Doom Emacs issue #7540 was exactly this: pinned lsp-mode broke TS while Go worked.

**Phase relevance:** Phase 2 (fix) — the actual upgrade step must include regression testing.

---

### Pitfall 4: Node.js/nvm PATH Not Available to Emacs GUI

**What goes wrong:** `typescript-language-server` binary is installed globally via `npm install -g` but Emacs launched from macOS Dock/Spotlight can't find it. The `exec-path-from-shell` package is supposed to fix this, but it only copies environment variables explicitly listed — and NVM's PATH manipulation requires the login shell (`-l` flag) to work.

**Why it happens:** macOS GUI apps don't inherit the user's shell `PATH`. NVM modifies PATH in `.zshrc`/`.bashrc` which only runs for interactive shells. The user's config already has `exec-path-from-shell` with `("-l")` argument, which should trigger login shell initialization. BUT: `exec-path-from-shell` copies `PATH` and specific env vars. If nvm's PATH is added by `.zshrc` (not `.zprofile`/`.bash_profile`), and the shell is started with `-l` but not `-i`, NVM might not fully initialize.

**Consequences:** `lsp-mode` reports "Server ts-ls not installed" or "Cannot find typescript-language-server" even though `which typescript-language-server` works in the terminal.

**Prevention:**
1. Verify PATH is correct in Emacs: `M-: (getenv "PATH")` — look for the npm global bin directory (typically `~/.nvm/versions/node/vXX.X.X/bin`)
2. If missing, ensure `exec-path-from-shell` is loaded early and copies PATH (already configured)
3. Consider also copying NVM_DIR: add `(exec-path-from-shell-copy-env "NVM_DIR")` after the GOPATH line
4. Alternative: install `typescript-language-server` in a fixed path (e.g., via Homebrew's node, not nvm) to avoid PATH complexity
5. typescript-language-server v5.0.0+ requires Node.js 20+ — ensure nvm's default is set to Node 20+

**Detection:** `M-x shell` and type `which typescript-language-server` — if it works there but not from `M-x lsp`, the PATH is wrong at Emacs startup time (before shell-mode re-initializes PATH).

**Confidence:** HIGH — the user's config already has `exec-path-from-shell` but only copies GOPATH. This is a known macOS Emacs issue.

**Phase relevance:** Phase 1 (diagnostic/prerequisite) — must confirm binary is findable before debugging LSP protocol errors.

## Moderate Pitfalls

### Pitfall 5: Both `lsp` and `lsp-deferred` Hooks Causing Double Server Starts

**What goes wrong:** The user's config hooks `typescript-mode-hook` and `typescriptreact-mode-hook` to `#'lsp` (eager start), while Go uses `lsp-deferred` (lazy start). Additionally, `js-mode` has `lsp-deferred` hooked in the main lsp-mode config (line 1080: `(js-mode . lsp-deferred)`). Since `typescriptreact-mode` is derived from `typescript-mode`, opening a `.tsx` file triggers BOTH `typescript-mode-hook` and `typescriptreact-mode-hook` — calling `lsp` twice. This won't crash but wastes time and may cause race conditions during initialization.

**Prevention:**
1. Use `#'lsp-deferred` (not `#'lsp`) for TypeScript hooks — matches the Go pattern and avoids blocking Emacs startup
2. Only hook `typescriptreact-mode-hook` since that's what actually activates via `auto-mode-alist`. The `typescript-mode-hook` will fire anyway (parent mode), but since `typescriptreact-mode` is used for ALL `.ts` and `.tsx` files (per the regex `"\\.tsx?\\'"`), hooking only `typescriptreact-mode-hook` is sufficient
3. Remove the `js-mode` hook from lsp-mode's main config unless JS LSP is actually needed

**Detection:** Open `*lsp-log*` and look for duplicate "Starting ts-ls" messages when opening a TypeScript file.

**Confidence:** MEDIUM — the double-hook on derived modes is a known Emacs pattern issue. Actual impact is usually minor (lsp-mode deduplicates server starts), but it's confusing.

**Phase relevance:** Phase 2 (fix) — clean up hooks as part of the config update.

---

### Pitfall 6: `auto-mode-alist` Regex Maps ALL `.ts` Files to TSX Mode

**What goes wrong:** The regex `"\\.tsx?\\'"` matches both `.ts` and `.tsx` files, routing them all to `typescriptreact-mode`. This means pure `.ts` files get the TSX tree-sitter parser (via `tree-sitter-major-mode-language-alist` mapping `typescriptreact-mode → tsx`). For LSP, this works fine — `typescript-language-server` handles both. But the TSX tree-sitter grammar is a superset parser; using it for plain `.ts` files adds unnecessary parsing overhead and may produce slightly different syntax highlighting.

**Why it happens:** The tutorial the user followed intentionally does this to ensure the TSX parser handles JSX syntax in `.tsx` files. It's a pragmatic trade-off, not a bug.

**Consequences:** Minor — syntax highlighting may differ slightly in pure `.ts` files (the TSX parser handles all TS syntax correctly, just with extra JSX production rules). No functional LSP impact.

**Prevention:**
1. If precision matters, use separate regex entries: `'("\\.tsx\\'" . typescriptreact-mode)` and `'("\\.ts\\'" . typescript-mode)`
2. For the user's case (Next.js project), keeping the current regex is fine — most files will have JSX anyway
3. Don't change this unless there are visible highlighting issues in `.ts` files

**Detection:** Open a `.ts` file, run `M-x describe-mode` — if it says "TypeScript TSX" for a pure `.ts` file, this is the cause.

**Confidence:** MEDIUM — tree-sitter TSX parser is a superset; the difference is cosmetic.

**Phase relevance:** Phase 3 (polish) — only address if highlighting issues appear.

---

### Pitfall 7: tree-sitter (elisp package) vs treesit (Emacs 29+ built-in) Confusion

**What goes wrong:** Emacs 29+ includes built-in tree-sitter support via the `treesit` module (with `typescript-ts-mode`, `tsx-ts-mode`). The user's config uses the *external* `tree-sitter` and `tree-sitter-langs` elisp packages (the older approach). These are two COMPLETELY DIFFERENT systems that happen to share a name. If the user upgrades to Emacs 29+ and some package or config snippet adds `typescript-ts-mode`, both systems may try to provide syntax highlighting, causing conflicts.

**Why it happens:** The Emacs ecosystem went through a tree-sitter transition: external package (2020-2023) → built-in treesit (Emacs 29, late 2023). Many tutorials and configs still reference the old packages. They can coexist but should not both be active for the same language.

**Consequences:**
- Doubled/garbled syntax highlighting
- `auto-mode-alist` conflicts (which mode opens `.ts` files?)
- `tsi.el` indentation package only works with the external `tree-sitter`, not built-in `treesit`
- If migrating to `treesit`, lsp-mode's `activation-fn` (`lsp-typescript-javascript-tsx-jsx-activate-p`) already checks for `typescript-ts-mode` — so LSP will activate, but the hooks may not fire

**Prevention:**
1. **Do NOT mix systems.** Stick with the current external `tree-sitter` package approach — it works and the config is built around it
2. If migrating to Emacs 29+ built-in treesit later, that's a separate project — don't attempt it while fixing LSP
3. Ensure no package pulls in `typescript-ts-mode` as a dependency
4. The current `lsp-typescript-javascript-tsx-jsx-activate-p` function in modern lsp-mode already handles both `typescript-mode` and `typescript-ts-mode` — so LSP will work either way, but hooks and tree-sitter config need to be consistent

**Detection:** `M-x describe-function RET treesit-available-p` — if this returns `t`, the built-in system exists but may not be configured. Check `auto-mode-alist` for any `*-ts-mode` entries.

**Confidence:** HIGH — verified from current `lsp-javascript.el` master source showing `typescript-ts-mode` in the `activation-fn`.

**Phase relevance:** Phase 3 (polish) or out-of-scope — don't migrate tree-sitter systems during this fix.

---

### Pitfall 8: Next.js Monorepo Project Root Detection

**What goes wrong:** In a Next.js monorepo (e.g., `packages/web/`, `packages/api/`), `projectile` and `lsp-mode` detect the project root at the git root (where `.git/` lives), not at the Next.js app root (where `tsconfig.json` lives). The TypeScript language server needs `tsconfig.json` at the root to resolve imports correctly. If the root is wrong, go-to-definition follows imports to wrong files, or auto-imports generate incorrect paths.

**Why it happens:** `lsp-mode` uses `projectile-project-root` or `lsp-workspace-root` to determine the workspace folder sent to the LSP server. For most projects, git root = project root. In monorepos, they differ.

**Consequences:** LSP reports "Cannot find module" for cross-package imports, go-to-definition lands in `node_modules` instead of source, completions miss project-specific types.

**Prevention:**
1. Add a `.dir-locals.el` at the Next.js app root setting `lsp-workspace-folders-add`
2. Or use `lsp-workspace-folders-add` interactively per session
3. Or configure `lsp-clients-typescript-prefer-use-project-ts-server` to `t` to use the project-local TypeScript
4. Verify: `M-x lsp-describe-session` shows the correct root folder for the TS workspace
5. For typical single-app Next.js projects (not monorepos), this is a non-issue — `tsconfig.json` is at the git root

**Detection:** After LSP connects, `M-x lsp-describe-session` — check "Workspace Folders" matches where `tsconfig.json` lives.

**Confidence:** MEDIUM — depends on the user's specific project structure. Single Next.js apps work fine; monorepos need attention.

**Phase relevance:** Phase 3 (polish) — only matters if the user has a monorepo.

---

### Pitfall 9: Format-on-Save Conflicts and Performance

**What goes wrong:** Adding LSP format-on-save (via `lsp-format-buffer` in `before-save-hook`) for TypeScript can conflict with existing format-on-save for Go (`gofmt-before-save` on `go-mode-hook`). If `lsp-format-buffer` is added globally to `before-save-hook`, it runs in Go buffers too — potentially double-formatting Go files (once via `gofmt`, once via `gopls`'s LSP formatter).

**Why it happens:** `before-save-hook` is buffer-local when added with the local flag, but global when added without it. If `lsp-format-buffer` is added globally, it fires in every buffer, not just TypeScript.

**Consequences:**
- Go files double-formatted (gofmt + gopls LSP format — they may disagree on style)
- Slow saves in large TypeScript files (LSP formatting can take 1-3 seconds)
- Save failures if LSP server hasn't initialized yet (early save in a new buffer)

**Prevention:**
1. Add format-on-save as buffer-local hook, ONLY for TypeScript modes:
   ```elisp
   (add-hook 'typescriptreact-mode-hook
     (lambda () (add-hook 'before-save-hook #'lsp-format-buffer nil t)))
   ```
   The `nil t` makes it buffer-local
2. Or use `lsp-format-on-save-mode` (available in modern lsp-mode) which handles this correctly
3. Do NOT use `(add-hook 'before-save-hook #'lsp-format-buffer)` globally
4. Consider using Prettier via an external formatter instead of LSP's built-in formatter for TypeScript — it's faster and more widely used in the Next.js ecosystem

**Detection:** Save a Go file, check if it takes unusually long or if formatting changes unexpectedly.

**Confidence:** HIGH — standard Emacs hook scoping issue; well-documented pattern.

**Phase relevance:** Phase 2 (fix) — format-on-save is a stated requirement.

## Minor Pitfalls

### Pitfall 10: `tsi.el` Stale/Unmaintained

**What goes wrong:** The `tsi.el` package (tree-sitter indentation) is pulled from GitHub (`orzechowskid/tsi.el`) and appears to be infrequently maintained. It depends on the external `tree-sitter` package. If tree-sitter grammars update or the package breaks, indentation falls back to `typescript-mode`'s default indentation, which is less accurate for JSX.

**Prevention:** Accept `tsi.el` as-is for now. If indentation breaks, the fallback (typescript-mode's built-in indent) is usable. This is a polish concern, not a blocker.

**Confidence:** LOW — haven't verified tsi.el's current maintenance status.

**Phase relevance:** Out of scope — not related to the LSP fix.

---

### Pitfall 11: typescript-language-server v5.0.0 Requires Node.js 20+

**What goes wrong:** If the user runs `npm install -g typescript-language-server` without specifying a version, they'll get v5.1.3 (latest), which requires Node.js 20+. If their nvm default is Node 18 or lower, the server binary will fail to start with a cryptic error.

**Prevention:**
1. Check Node.js version first: `node --version` (must be 20+)
2. If on Node 18, either upgrade or install v4.x: `npm install -g typescript-language-server@4`
3. v4.4.1 is the latest 4.x release (Sep 2025) — works with Node 18

**Detection:** `typescript-language-server --version` fails or shows nothing. Check `*lsp-log*` for startup errors.

**Confidence:** HIGH — verified from typescript-language-server v5.0.0 release notes (Sep 15, 2025): "require at least node 20".

**Phase relevance:** Phase 1 (prerequisite check) — must verify Node version before installing.

## Phase-Specific Warnings

| Phase Topic | Likely Pitfall | Mitigation |
|-------------|---------------|------------|
| Diagnostics (Phase 1) | Pitfall 1: Assuming tag = actual loaded code | Verify actual loaded commit via `lsp-version` or straight recipe inspection |
| Diagnostics (Phase 1) | Pitfall 2: Wrong direction of version mismatch | Check BOTH lsp-mode version AND typescript-language-server version |
| Diagnostics (Phase 1) | Pitfall 4: Binary not found due to PATH | Verify `typescript-language-server` is in Emacs's exec-path |
| Diagnostics (Phase 1) | Pitfall 11: Node.js version too low | Check `node --version` ≥ 20 before installing latest typescript-language-server |
| Fix (Phase 2) | Pitfall 3: Upgrading lsp-mode breaks Go/Clojure | Test all language servers immediately after any lsp-mode version change |
| Fix (Phase 2) | Pitfall 5: Double LSP start hooks | Clean up hook assignments during config edit |
| Fix (Phase 2) | Pitfall 9: Global format-on-save breaks Go | Use buffer-local hooks for TypeScript formatting |
| Polish (Phase 3) | Pitfall 6: All .ts files get TSX parser | Only fix if highlighting issues are visible |
| Polish (Phase 3) | Pitfall 7: tree-sitter vs treesit confusion | Don't migrate during this fix; out of scope |
| Polish (Phase 3) | Pitfall 8: Monorepo root detection | Only matters for multi-package repos |

## Sources

- lsp-mode GitHub tags page: https://github.com/emacs-lsp/lsp-mode/tags — v9.0.0 is the only tag since v8.0.0 (Sept 2021), created Apr 6, 2024 [HIGH confidence]
- lsp-mode PR #4202: https://github.com/emacs-lsp/lsp-mode/pull/4202 — tsserver-path fix, merged Oct 26, 2023 [HIGH confidence]
- lsp-mode PR #4333: https://github.com/emacs-lsp/lsp-mode/pull/4333 — node_modules resolution fix, merged May 26, 2024 [HIGH confidence]
- lsp-javascript.el master source: https://github.com/emacs-lsp/lsp-mode/blob/master/clients/lsp-javascript.el — uses `initializationOptions.tsserver.path` [HIGH confidence]
- typescript-language-server releases: https://github.com/typescript-language-server/typescript-language-server/releases — v5.1.3 latest, v5.0.0 requires Node 20+ [HIGH confidence]
- User's straight.el lockfile: `emacs.d/straight/versions/default.el` line 61 — lsp-mode pinned to commit `bdae0f4` [HIGH confidence]
- User's config.org: lines 1072-1088 (lsp-mode), lines 1555-1563 (typescript-mode), lines 287-296 (exec-path-from-shell) [HIGH confidence]
- Doom Emacs issue #7540: https://github.com/doomemacs/doomemacs/issues/7540 — same tsserver-path problem caused by pinned lsp-mode version [MEDIUM confidence]
