---
phase: 02-fix-lsp-connection-verify-navigation
plan: 01
subsystem: editor
tags: [lsp-mode, straight.el, typescript-language-server, emacs, evil-mode]

# Dependency graph
requires:
  - phase: 01-diagnose-fix-environment
    provides: "Correct Emacs PATH with nvm Node.js, typescript-mode hooks with lsp-deferred, root cause diagnosis of stale lockfile"
provides:
  - "lsp-mode pinned to 9.0.0 tag commit (a478e03cd1) in straight.el lockfile"
  - "LSP connection working in .ts and .tsx files"
  - "All 5 navigation keybindings (gd/gi/gr/gy/,r) functional in TypeScript"
  - "Go and Clojure LSP regression verified"
affects: [03-format-on-save-code-actions]

# Tech tracking
tech-stack:
  added: []
  patterns: ["straight.el lockfile manual checkout when lockfile update alone insufficient"]

key-files:
  created: []
  modified:
    - emacs.d/straight/versions/default.el

key-decisions:
  - "Manual git checkout of lsp-mode repo required — straight.el did not auto-checkout new lockfile commit on restart"
  - "Cleared compiled .elc files to force rebuild from updated source"

patterns-established:
  - "straight.el lockfile change may require manual repo checkout + .elc cleanup for the change to take effect"

requirements-completed: [DIAG-02, DIAG-04, NAV-01, NAV-02, NAV-03, NAV-04, NAV-05, REG-01, REG-02]

# Metrics
duration: 15min
completed: 2026-03-25
---

# Phase 2: Fix LSP Connection & Verify Navigation Summary

**lsp-mode lockfile updated to 9.0.0 — LSP connects in .ts/.tsx, all 5 navigation keybindings work, Go/Clojure unaffected**

## Performance

- **Duration:** 15 min
- **Started:** 2026-03-25T11:38:00Z
- **Completed:** 2026-03-25T11:53:00Z
- **Tasks:** 2
- **Files modified:** 1

## Accomplishments
- Updated straight.el lockfile from stale 2021 commit (bdae0f406d) to 9.0.0 tag commit (a478e03cd1)
- LSP connects successfully in .ts and .tsx files — no more `--tsserver-path` error
- All 5 keybindings (gd, gi, gr, gy, ,r) work in TypeScript files, matching Go parity
- Go LSP (gopls) and other language LSPs confirmed unaffected

## Task Commits

Each task was committed atomically:

1. **Task 1: Update lsp-mode lockfile to 9.0.0 and verify npm packages** - `bd966d2` (fix)
2. **Task 2: Verify LSP connects and all keybindings work** - Human checkpoint (approved)

## Files Created/Modified
- `emacs.d/straight/versions/default.el` - Updated lsp-mode commit hash from bdae0f406d to a478e03cd1a5dc84ad496234fd57241ff9dca57a

## Decisions Made
- Manual `git checkout` of lsp-mode repo to target commit was required because straight.el did not auto-checkout the new lockfile hash on Emacs restart
- Cleared stale `.elc` compiled files from `~/.emacs.d/straight/build/lsp-mode/` to force rebuild from the updated source

## Deviations from Plan

### Auto-fixed Issues

**1. [Blocking] straight.el did not auto-checkout new lockfile commit**
- **Found during:** Task 2 (human verification)
- **Issue:** After updating lockfile and restarting Emacs, the `--tsserver-path` error persisted. The lsp-mode repo at `~/.emacs.d/straight/repos/lsp-mode/` was still on the stale commit bdae0f406d.
- **Fix:** Manually ran `git checkout a478e03cd1` in the lsp-mode repo and removed all `.elc` files from `~/.emacs.d/straight/build/lsp-mode/`
- **Files modified:** ~/.emacs.d/straight/repos/lsp-mode (HEAD), ~/.emacs.d/straight/build/lsp-mode/*.elc (removed)
- **Verification:** User restarted Emacs, confirmed LSP connects and keybindings work
- **Committed in:** N/A (runtime files outside dotfiles repo)

---

**Total deviations:** 1 auto-fixed (1 blocking)
**Impact on plan:** Essential fix — lockfile alone was insufficient. No scope creep.

## Issues Encountered
- straight.el's lockfile mechanism did not trigger a repo checkout on restart. This may be because the repo was on a detached HEAD or branch state that straight.el didn't reconcile. Manual intervention was required.

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- LSP connection and navigation fully working for TypeScript — ready for Phase 3 (format-on-save and code actions)
- No blockers or concerns

---
*Phase: 02-fix-lsp-connection-verify-navigation*
*Completed: 2026-03-25*
