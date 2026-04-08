---
phase: quick
plan: 260408-eo0
subsystem: infra
tags: [chezmoi, migration, docs, parity]
requires:
  - phase: 02-source-mapping-safe-preview
    provides: bounded home/ source root and reviewed import contracts
provides:
  - explicit chezmoi ignore coverage for repo-only README.org
  - removal of ~/.README.org from managed source and migration contracts
affects: [chezmoi-managed-state, parity-review, quick-tasks]
tech-stack:
  added: []
  patterns: [explicit ignore entries for repo-only home exclusions, migration contracts stay aligned with live chezmoi source state]
key-files:
  created: [.planning/quick/260408-eo0-exclude-readme-org-from-chezmoi-home-sta/260408-eo0-SUMMARY.md]
  modified: [home/.chezmoiignore, migration/chezmoi-import-targets.txt, migration/chezmoi-target-map.md, .planning/STATE.md]
key-decisions:
  - "Add an explicit .README.org ignore entry instead of relying on the existing *.md rule because the repo documentation file is Org-based."
  - "Treat the reviewed migration contract files as the source of truth for removing ~/.README.org from approved chezmoi output."
patterns-established:
  - "Repo-only documentation can be kept out of home state with explicit chezmoi ignore entries when filename extensions fall outside the rcrc-style markdown exclusions."
requirements-completed: []
duration: 6 min
completed: 2026-04-08
---

# Phase quick Plan 260408-eo0: Exclude README.org Summary

**Chezmoi now ignores `.README.org`, removes its home source file, and keeps the reviewed migration contracts aligned with that repo-only documentation boundary.**

## Performance

- **Duration:** 6 min
- **Started:** 2026-04-08T03:31:42Z
- **Completed:** 2026-04-08T03:37:42Z
- **Tasks:** 2
- **Files modified:** 4

## Accomplishments
- Added an explicit `.README.org` ignore rule to `home/.chezmoiignore` with parity-focused rationale.
- Removed `home/dot_README.org` so chezmoi no longer emits `~/.README.org` from source state.
- Deleted the `~/.README.org` target from both reviewed migration contract files.

## Task Commits

Each task was committed atomically:

1. **Task 1: Exclude `~/.README.org` from chezmoi state** - `6ff8f54` (fix)
2. **Task 2: Remove `README.org` from migration import/parity contracts** - `f355eae` (fix)

## Files Created/Modified
- `home/.chezmoiignore` - Adds an explicit Org-file ignore so repo-only docs stay out of home state.
- `home/dot_README.org` - Removed from chezmoi source so `~/.README.org` is no longer managed output.
- `migration/chezmoi-import-targets.txt` - Removes the reviewed import-contract entry for `~/.README.org`.
- `migration/chezmoi-target-map.md` - Removes the root-dotfile mapping entry for `~/.README.org`.

## Decisions Made
- Added an explicit `.README.org` ignore entry because the existing `*.md` exclusion does not cover the Org-formatted repo README.
- Kept the migration contract files in sync with the live chezmoi source tree so parity review will not expect a removed target.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Force-added planning artifacts for the metadata commit**
- **Found during:** Final documentation commit
- **Issue:** Local `.gitignore` rules ignored `.planning/`, which blocked staging the required quick-task summary and state update.
- **Fix:** Used `git add -f` for `.planning/quick/260408-eo0-exclude-readme-org-from-chezmoi-home-sta/260408-eo0-SUMMARY.md` and `.planning/STATE.md` only, then retried the docs commit.
- **Files modified:** `.planning/quick/260408-eo0-exclude-readme-org-from-chezmoi-home-sta/260408-eo0-SUMMARY.md`, `.planning/STATE.md`
- **Verification:** The final docs commit completed successfully and the summary file is tracked in git.
- **Committed in:** `68249de`

---

**Total deviations:** 1 auto-fixed (1 blocking)
**Impact on plan:** The fix only unblocked the required planning-artifact commit and did not change task scope.

## Issues Encountered

None.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness
- Future parity checks will no longer treat `~/.README.org` as approved chezmoi-managed output.
- The repo README remains documentation-only while the managed target set stays aligned with the reviewed contracts.

## Self-Check: PASSED
- Found summary file: `.planning/quick/260408-eo0-exclude-readme-org-from-chezmoi-home-sta/260408-eo0-SUMMARY.md`
- Verified task commits: `6ff8f54`, `f355eae`

---
*Phase: quick*
*Completed: 2026-04-08*
