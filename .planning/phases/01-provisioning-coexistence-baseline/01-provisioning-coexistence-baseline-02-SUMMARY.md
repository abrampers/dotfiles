---
phase: 01-provisioning-coexistence-baseline
plan: 02
subsystem: infra
tags: [ansible, chezmoi, rcm, migration, documentation]
requires:
  - phase-1-plan-1
provides:
  - durable rcm baseline capture in operator-local migration state
  - preview-only chezmoi initialization and dry-run behavior in the dotfiles role
  - operator documentation for the Phase 1 preview-first migration flow
affects: [phase-2-source-mapping, migration-safety, operator-flow]
tech-stack:
  added: []
  patterns: [create-once migration baseline, preview-only chezmoi execution, operator-visible trust boundary]
key-files:
  created: []
  modified: [ansible/roles/dotfiles/tasks/chezmoi.yml, README.org]
key-decisions:
  - "Stored the first lsrc-derived rcm baseline under ~/.local/state/dotfiles-migration so later cutover checks can compare against a durable pre-apply snapshot."
  - "Kept ansible/local_machine.yml on chezmoi init plus apply --dry-run --verbose only, leaving real apply outside the default Phase 1 path."
patterns-established:
  - "Migration-state artifacts live outside the repo under ~/.local/state/dotfiles-migration to avoid git noise while preserving trust-boundary evidence."
  - "Check-mode-safe Ansible tasks use preview debug messages instead of hard availability assertions when an install step is intentionally skipped."
requirements-completed: [PROV-03, PROV-04, VERI-01]
duration: 4 min
completed: 2026-04-06
---

# Phase 1 Plan 2: Provisioning Coexistence & Baseline Summary

**Phase 1 now saves the first `rcm` managed-file baseline, initializes an empty chezmoi source only when needed, and keeps the default provisioning flow on `chezmoi apply --dry-run --verbose` with matching operator docs.**

## Performance

- **Duration:** 4 min
- **Started:** 2026-04-06T08:53:35Z
- **Completed:** 2026-04-06T08:57:35Z
- **Tasks:** 2
- **Files modified:** 2

## Accomplishments
- Added create-once baseline capture from `dotfiles_lsrc_state.stdout` into `~/.local/state/dotfiles-migration/rcm-managed-files.txt`.
- Extended the dotfiles chezmoi role to initialize the default source directory safely and run `chezmoi apply --dry-run --verbose` instead of any real apply path.
- Updated `README.org` so the documented Phase 1 operator flow matches the preview-only implementation and baseline location.

## Task Commits

Each task was committed atomically:

1. **Task 1: Capture the pre-cutover rcm baseline and run preview-only chezmoi behavior** - `58afb44` (feat)
2. **Task 2: Document the Phase 1 operator flow and baseline artifact** - `2d3f9c1` (docs)

**Plan metadata:** Pending final docs commit

## Files Created/Modified
- `ansible/roles/dotfiles/tasks/chezmoi.yml` - Added migration state directory creation, create-once baseline capture, check-mode-safe verification, conditional `chezmoi init`, and dry-run-only preview execution.
- `README.org` - Documented the default `ansible/local_machine.yml` migration flow, the saved baseline artifact, and the explicit opt-in boundary for real apply.

## Decisions Made
- Stored the baseline in `~/.local/state/dotfiles-migration` so the first trusted `rcm` snapshot survives future reruns without adding repo-tracked noise.
- Treated `chezmoi` verification as check-mode-aware so `ansible-playbook --check` can validate the preview contract without failing on a skipped install step.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Fixed check-mode verification for chezmoi preview tasks**
- **Found during:** Task 1 (Capture the pre-cutover rcm baseline and run preview-only chezmoi behavior)
- **Issue:** `ansible-playbook --check --tags dotfiles --diff` skipped the Homebrew install and then failed immediately on `which chezmoi`, blocking the required verification path.
- **Fix:** Limited binary/version assertions to non-check mode and added a preview debug step so check mode still validates the intended flow.
- **Files modified:** `ansible/roles/dotfiles/tasks/chezmoi.yml`
- **Verification:** `ANSIBLE_CONFIG=ansible/ansible.cfg ansible-playbook ansible/local_machine.yml --check --tags dotfiles --diff` and `ANSIBLE_CONFIG=ansible/ansible.cfg ansible-playbook ansible/local_machine.yml --syntax-check`
- **Committed in:** `58afb44`

---

**Total deviations:** 1 auto-fixed (1 blocking)
**Impact on plan:** The auto-fix preserved the planned behavior and made the required Ansible verification path pass without widening scope.

## Issues Encountered
- None.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness
- The migration now has a durable pre-cutover `rcm` baseline plus a safe preview-only `chezmoi` contract in the main provisioning path.
- Phase 2 can focus on bounded source mapping and exclusion parity without reopening the Phase 1 trust boundary.

## Self-Check: PASSED
- Found summary file: `.planning/phases/01-provisioning-coexistence-baseline/01-provisioning-coexistence-baseline-02-SUMMARY.md`
- Verified task commits: `58afb44`, `2d3f9c1`

---
*Phase: 01-provisioning-coexistence-baseline*
*Completed: 2026-04-06*
