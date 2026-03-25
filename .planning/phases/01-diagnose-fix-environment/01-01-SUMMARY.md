---
phase: 01-diagnose-fix-environment
plan: 01
subsystem: diagnostics
tags: [lsp-mode, typescript-language-server, nvm, exec-path-from-shell, straight.el]

# Dependency graph
requires:
  - phase: none
    provides: "First plan — no prior dependencies"
provides:
  - "Ground truth: lsp-mode lockfile commit bdae0f406d is from 2021, not v9.0.0"
  - "Ground truth: Node v22.9.0 in terminal, v18.20.5 in Emacs GUI (nvm default mismatch)"
  - "Ground truth: typescript-language-server v4.3.3 installed under v22 nvm path"
  - "Ground truth: exec-path-from-shell works — nvm paths present in Emacs"
  - "Ground truth: lsp-version command broken (nil package-desc) — stale lsp-mode confirmed"
affects: [01-02-PLAN, phase-02]

# Tech tracking
tech-stack:
  added: []
  patterns: []

key-files:
  created:
    - ".planning/phases/01-diagnose-fix-environment/01-01-diagnostic-findings.md"
  modified: []

key-decisions:
  - "lsp-mode lockfile commit bdae0f406d is from 2021-07-11, NOT v9.0.0 — straight.el lockfile overrides :tag in config.org"
  - "Node version mismatch: Emacs GUI sees v18.20.5, terminal sees v22.9.0 — exec-path-from-shell captures PATH at Emacs launch time"
  - "typescript-language-server v4.3.3 installed under v22 path but Emacs runs with v18 node — fragile but functional"

patterns-established:
  - "Diagnostic-first approach: gather ground truth before making config changes"

requirements-completed: [DIAG-01, DIAG-03]

# Metrics
duration: 15min
completed: 2026-03-25
---

# Phase 1 Plan 01: Diagnose lsp-mode + Node.js Environment Summary

**lsp-mode lockfile pins a 2021 commit (not v9.0.0), Emacs GUI uses Node v18.20.5 while terminal has v22.9.0, and lsp-version is broken with nil package-desc**

## Performance

- **Duration:** 15 min
- **Started:** 2026-03-25T10:53:48Z
- **Completed:** 2026-03-25T11:09:43Z
- **Tasks:** 2
- **Files modified:** 1

## Accomplishments
- Established that lsp-mode lockfile commit `bdae0f406d` is from July 2021, not the v9.0.0 release — straight.el lockfile overrides the `:tag` declaration in config.org
- Confirmed Node.js v22.9.0 in terminal with typescript-language-server v4.3.3 already installed
- Discovered Node version mismatch: Emacs GUI sees v18.20.5 (the nvm default at launch time) while terminal defaults to v22.9.0
- Confirmed exec-path-from-shell is working — nvm paths are present in Emacs GUI PATH
- Confirmed lsp-mode is broken in current state: `M-x lsp-version` returns `Wrong type argument: package-desc, nil`

## Task Commits

Each task was committed atomically:

1. **Task 1: Check lsp-mode commit and Node.js version from terminal** - `a33e947` (chore)
2. **Task 2: Verify lsp-mode version in live Emacs GUI session** - `d93d2bc` (chore)

**Plan metadata:** TBD (docs: complete plan)

## Files Created/Modified
- `.planning/phases/01-diagnose-fix-environment/01-01-diagnostic-findings.md` - Comprehensive diagnostic findings with terminal and GUI results

## Decisions Made
- **lsp-mode is fundamentally stale:** The lockfile commit is from 2021, not v9.0.0. Plan 02 must update the lockfile to a modern lsp-mode commit.
- **Node version mismatch is cosmetic for now:** exec-path-from-shell captures PATH at Emacs launch time. The v18 vs v22 mismatch should be addressed in Plan 02 but isn't blocking since typescript-language-server binary is findable regardless.
- **exec-path-from-shell works for PATH:** No changes needed to make nvm paths visible — they're already in Emacs. The earlier concern (from STATE.md) that "exec-path-from-shell only copies GOPATH" was incorrect — it copies the full PATH including nvm.

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
- `straight--get-recipe` is not available at runtime — it's internal to straight.el's build process. This means we can't inspect the recipe from a running Emacs session. Not a blocker; the lockfile commit hash is sufficient for diagnosis.
- Emacs batch mode showed v22.9.0 for node while GUI showed v18.20.5 — this is because batch mode runs a fresh login shell (picking up current nvm default) while the GUI inherited the PATH from when Emacs was launched (when nvm default was v18).

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness
- **Plan 02 has clear action items:** Update lsp-mode lockfile to modern commit, potentially address Node version consistency
- **No blockers:** All diagnostic data gathered successfully
- **Key input for Plan 02:** The root cause is confirmed — lsp-mode is pinned to a 2021 commit that passes `--tsserver-path` to typescript-language-server v4.x which no longer accepts that flag

---
*Phase: 01-diagnose-fix-environment*
*Completed: 2026-03-25*
