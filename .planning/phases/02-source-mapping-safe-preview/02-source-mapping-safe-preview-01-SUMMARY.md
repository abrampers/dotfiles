---
phase: 02-source-mapping-safe-preview
plan: 01
subsystem: infra
tags: [chezmoi, migration, rcm, source-layout, parity]
requires:
  - phase: 01-provisioning-coexistence-baseline
    provides: durable saved rcm baseline for phase 2 mapping
provides:
  - bounded chezmoi source root redirected into home/
  - explicit ignore denylist and parity exception migration policy files
  - baseline-derived approved import target contract with grouped operator map
affects: [phase-2-imports, phase-2-preview, phase-3-parity]
tech-stack:
  added: []
  patterns: [bounded chezmoi source root, explicit local-only denylist, baseline-derived import contract]
key-files:
  created: [.chezmoiroot, home/.chezmoiversion, home/.chezmoiignore, migration/chezmoi-local-denylist.txt, migration/chezmoi-parity-exceptions.txt, migration/chezmoi-import-targets.txt, migration/chezmoi-target-map.md]
  modified: []
key-decisions:
  - "Redirect chezmoi source state into repo-local home/ so repo root stays outside managed home-state."
  - "Derive import targets from the saved rcm baseline after denylist and exception filtering instead of rediscovering from the repo tree."
patterns-established:
  - "Migration policy lives in tracked artifacts: ignore rules, denylist, parity exceptions, and import contract are separate review surfaces."
  - "Operator-readable mapping reports summarize grouped targets while the raw import file remains the exact machine-facing contract."
requirements-completed: [LAYO-01, LAYO-02, VERI-04]
duration: 58 min
completed: 2026-04-06
---

# Phase 2 Plan 1: Source Mapping & Safe Preview Summary

**Bounded chezmoi home/ source mapping with explicit exclusion policy and a baseline-filtered import contract for all approved managed targets.**

## Performance

- **Duration:** 58 min
- **Started:** 2026-04-06T10:25:54Z
- **Completed:** 2026-04-06T11:23:48Z
- **Tasks:** 2
- **Files modified:** 11

## Accomplishments
- Added a bounded `home/` chezmoi source root with version pinning and reviewed ignore rules translated from `rcrc`.
- Tracked the local-only boundary and intentional parity quirks in dedicated denylist and exception artifacts.
- Derived a full approved Phase 2 import contract from the saved `rcm` baseline and summarized it in a grouped target map for later import plans.

## Task Commits

Each task was committed atomically:

1. **Task 1: Create the bounded chezmoi root and explicit boundary policy** - `ba01db4` (feat)
2. **Task 2: Derive the approved import set and human-readable target map from the saved baseline** - `dcfe933` (feat)

**Plan metadata:** `013e136` (docs)

## Files Created/Modified
- `.chezmoiroot` - Redirects chezmoi source state into the bounded `home/` subtree.
- `home/.chezmoiversion` - Pins the required chezmoi version inside the redirected source root.
- `home/.chezmoiignore` - Carries forward `rcrc` exclusions and explicit local/private target ignores.
- `migration/chezmoi-local-denylist.txt` - Lists local-only targets that must remain outside shared management.
- `migration/chezmoi-parity-exceptions.txt` - Documents intentional non-surviving parity quirks separately from code comments.
- `migration/chezmoi-import-targets.txt` - Captures the exact absolute target set approved for later `chezmoi add --follow` imports.
- `migration/chezmoi-target-map.md` - Groups approved targets into root, tool, and XDG sections for operator review and later plan handoff.

## Decisions Made
- Redirected chezmoi source state into `home/` so the repo root itself cannot be mistaken for managed home-state.
- Kept migration policy split across dedicated artifacts so exclusions, denylisted local files, parity exceptions, and import approvals stay reviewable independently.
- Excluded `.migration/*` entries from the approved import set even when they appeared in the saved baseline because they are Phase 2 repo-only scaffolding, not shared dotfile targets.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Recreated the missing saved baseline before generating import artifacts**
- **Found during:** Task 2 (Derive the approved import set and human-readable target map from the saved baseline)
- **Issue:** `~/.local/state/dotfiles-migration/rcm-managed-files.txt` was missing, which blocked the plan's required baseline-derived import contract.
- **Fix:** Re-ran `ansible/local_machine.yml --tags dotfiles` to recreate the saved baseline through the existing Phase 1 automation path, then restored an unrelated `zshrc` side effect before continuing.
- **Files modified:** external migration state only; tracked outputs in `migration/chezmoi-import-targets.txt`, `migration/chezmoi-target-map.md`
- **Verification:** Re-read `~/.local/state/dotfiles-migration/rcm-managed-files.txt` and completed the task verification checks against the generated import artifacts.
- **Committed in:** `dcfe933`

---

**Total deviations:** 1 auto-fixed (1 blocking)
**Impact on plan:** The auto-fix preserved the plan's baseline-first requirement and avoided inventing targets or widening scope.

## Issues Encountered
- Recreating the baseline via Ansible appended an unrelated local PATH line to `zshrc`; it was restored immediately and excluded from task commits.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness
- Plans 02 and 03 can import approved root/tool and XDG targets directly from `migration/chezmoi-import-targets.txt`.
- Preview wiring can consume the new policy artifacts and grouped mapping report without rediscovering exclusions or local-only boundaries.

## Self-Check: PASSED
- Found summary file: `.planning/phases/02-source-mapping-safe-preview/02-source-mapping-safe-preview-01-SUMMARY.md`
- Verified task commits: `ba01db4`, `dcfe933`

---
*Phase: 02-source-mapping-safe-preview*
*Completed: 2026-04-06*
