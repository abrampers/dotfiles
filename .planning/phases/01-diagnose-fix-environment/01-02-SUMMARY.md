---
phase: 01-diagnose-fix-environment
plan: 02
subsystem: environment
tags: [exec-path-from-shell, nvm, typescript-mode, typescriptreact-mode, lsp-deferred, auto-mode-alist, tree-sitter]

# Dependency graph
requires:
  - phase: 01-01
    provides: "Ground truth: exec-path-from-shell works for PATH, NVM_DIR copy still needed, lsp hooks use eager #'lsp"
provides:
  - "Emacs GUI has NVM_DIR env var available via exec-path-from-shell-copy-env"
  - "Split mode routing: .ts -> typescript-mode, .tsx -> typescriptreact-mode"
  - "Both typescript hooks use lsp-deferred (matching go-mode pattern)"
  - "Tree-sitter parser mapping: typescript-mode -> typescript, typescriptreact-mode -> tsx"
affects: [phase-02]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "lsp-deferred hook pattern for TypeScript modes (matching Go)"
    - "Separate auto-mode-alist entries for .ts and .tsx"

key-files:
  created: []
  modified:
    - "emacs.d/config.org"

key-decisions:
  - "Added NVM_DIR copy to exec-path-from-shell alongside existing GOPATH — ensures tools referencing NVM_DIR directly work in Emacs GUI"
  - "Split .tsx?\\' regex into separate .ts and .tsx auto-mode-alist entries — ensures correct mode per file type"
  - "Switched both typescript hooks from #'lsp to #'lsp-deferred — matches go-mode pattern, prevents eager LSP startup"

patterns-established:
  - "TypeScript mode routing: .ts -> typescript-mode, .tsx -> typescriptreact-mode (separate entries, not unified regex)"
  - "All language mode hooks use lsp-deferred, not lsp (Go, TypeScript, TSX)"

requirements-completed: [ENV-01, ENV-02]

# Metrics
duration: 8min
completed: 2026-03-25
---

# Phase 1 Plan 02: Fix exec-path-from-shell PATH and TypeScript Mode Routing Summary

**Added NVM_DIR env var copy to exec-path-from-shell and split .ts/.tsx into separate modes with lsp-deferred hooks matching go-mode pattern**

## Performance

- **Duration:** 8 min
- **Started:** 2026-03-25T11:12:08Z
- **Completed:** 2026-03-25T11:20:56Z
- **Tasks:** 3 (2 auto + 1 human-verify checkpoint)
- **Files modified:** 1

## Accomplishments
- Added `(exec-path-from-shell-copy-env "NVM_DIR")` so Emacs GUI has the NVM_DIR variable available for tools that reference it directly
- Split the unified `.tsx?` regex into separate `.ts` → `typescript-mode` and `.tsx` → `typescriptreact-mode` auto-mode-alist entries
- Added `(typescript-mode . typescript)` tree-sitter parser mapping for plain .ts files
- Switched both TypeScript hooks from eager `#'lsp` to `#'lsp-deferred`, matching the proven go-mode pattern
- Updated config.org prose to reflect the new separate mode routing

## Task Commits

Each task was committed atomically:

1. **Task 1: Add NVM_DIR to exec-path-from-shell config** - `35e4106` (feat)
2. **Task 2: Split auto-mode-alist and switch hooks to lsp-deferred** - `dba9eed` (feat)
3. **Task 3: Verify Emacs finds nvm Node.js after config changes** - checkpoint:human-verify (approved)

**Plan metadata:** TBD (docs: complete plan)

## Files Created/Modified
- `emacs.d/config.org` — exec-path-from-shell block (added NVM_DIR copy) and typescript-mode block (split routing, lsp-deferred hooks, tree-sitter mapping, updated prose)

## Decisions Made
- **NVM_DIR alongside GOPATH:** Added copy on the line after GOPATH, keeping the same pattern. exec-path-from-shell already copies the full PATH (including nvm), but NVM_DIR is needed as an env var for tools that reference it directly.
- **Split over unified regex:** Replaced `"\\.tsx?\\'"` with separate `"\\.tsx\\'"` and `"\\.ts\\'"` entries. This ensures each file type routes to the correct major mode, enabling proper tree-sitter parser selection and modeline display.
- **lsp-deferred not lsp:** Matches the go-mode pattern exactly. Prevents double-fire and ensures LSP doesn't start before buffer is ready.

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

None during plan execution.

## Known Issue for Phase 2

During human verification, the user confirmed all Phase 1 goals work correctly but observed the expected `--tsserver-path` error:
```
error: unknown option '--tsserver-path'
Process ts-ls stderr finished
```
This is the **root cause** that Phase 2 will fix — the stale lsp-mode (2021 commit pinned by straight.el lockfile) passes `--tsserver-path` to typescript-language-server v4.x which no longer accepts that flag. This was already identified in Plan 01's diagnostics and is NOT a Phase 1 concern.

## User Setup Required

None - changes take effect on Emacs restart. User verified all changes work correctly.

## Next Phase Readiness
- **Phase 1 complete:** All environment diagnostics gathered (Plan 01) and PATH/mode fixes applied (Plan 02)
- **Phase 2 input established:** lsp-mode needs updating from 2021 commit to modern version that doesn't pass `--tsserver-path`
- **No blockers:** Emacs finds nvm Node.js, modes route correctly, hooks use lsp-deferred
- **Key context for Phase 2:** The only remaining issue is the stale lsp-mode lockfile commit — updating it (or switching LSP server config) will resolve the `--tsserver-path` error

## Self-Check: PASSED

All files, commits, and content verified:
- `emacs.d/config.org` exists with NVM_DIR, lsp-deferred, split .ts/.tsx entries
- Commits `35e4106` (Task 1) and `dba9eed` (Task 2) exist in git history
- SUMMARY.md created at expected path

---
*Phase: 01-diagnose-fix-environment*
*Completed: 2026-03-25*
