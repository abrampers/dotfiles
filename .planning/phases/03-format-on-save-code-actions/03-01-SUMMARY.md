---
phase: 03-format-on-save-code-actions
plan: 01
subsystem: editor
tags: [emacs, lsp-mode, typescript, eslint, prettier, format-on-save, organize-imports, auto-import]

# Dependency graph
requires:
  - phase: 02-fix-lsp-connection-verify-navigation
    provides: "Working LSP connection in .ts and .tsx files via lsp-mode 9.0.0 + typescript-language-server"
provides:
  - "Format-on-save for TypeScript/TSX via lsp-eslint-auto-fix-on-save (ESLint + Prettier)"
  - "Buffer-local organize-imports before-save hook for TypeScript/TSX"
  - "Auto-import on completion (default lsp-mode behavior, no config needed)"
  - "typescript-indent-level set to 2 for TypeScript buffers"
affects: []

# Tech tracking
tech-stack:
  added: []
  patterns:
    - "lsp-eslint-auto-fix-on-save for format-on-save (delegates to ESLint which invokes Prettier via eslint-plugin-prettier)"
    - "Buffer-local before-save-hook pattern with (add-hook ... nil t) for mode-specific save actions"
    - "setq-local in mode hooks for buffer-scoped lsp settings"

key-files:
  created: []
  modified:
    - "emacs.d/config.org"

key-decisions:
  - "Switched from lsp-format-buffer-on-save to lsp-eslint-auto-fix-on-save because user's project uses ESLint+Prettier pipeline"
  - "Set typescript-indent-level to 2 to match project's Prettier tabWidth setting"
  - "Removed unused JavaScript section (tangle no block) to avoid void-function errors from abrampers/set-eslint-config"

patterns-established:
  - "ESLint auto-fix on save: use setq-local lsp-eslint-auto-fix-on-save in mode hooks for per-language formatting"
  - "Organize imports: buffer-local before-save-hook with lsp-organize-imports and LOCAL=t flag"

requirements-completed: [FMT-01, FMT-02, FMT-03, ACT-01, ACT-02]

# Metrics
duration: 45min
completed: 2026-03-25
---

# Phase 3 Plan 01: Format-on-Save & Code Actions Summary

**Format-on-save via ESLint+Prettier (lsp-eslint-auto-fix-on-save) with buffer-local organize-imports and auto-import for TypeScript/TSX, Go formatting unaffected**

## Performance

- **Duration:** ~45 min (including checkpoint verification)
- **Started:** 2026-03-25T12:14:00Z
- **Completed:** 2026-03-25T12:29:00Z (continuation)
- **Tasks:** 2
- **Files modified:** 1

## Accomplishments
- Format-on-save for .ts and .tsx files using lsp-eslint-auto-fix-on-save (ESLint invokes Prettier via eslint-plugin-prettier, respecting .prettierrc.json tabWidth: 2)
- Buffer-local organize-imports before-save hook on both typescript-mode and typescriptreact-mode
- Auto-import on completion works out of the box (lsp-completion-enable-additional-text-edit defaults to t)
- Go format-on-save (gofmt-before-save) completely unaffected
- typescript-indent-level set to 2 for proper Emacs-side indentation

## Task Commits

Each task was committed atomically:

1. **Task 1: Add format-on-save and organize-imports settings to config.org** - `4137f7b` (feat)
2. **Task 1 refinement: Switch to eslint-auto-fix, set indent-level, remove unused JS section** - `72c7989` (fix)
3. **Task 2: Verify format-on-save, auto-import, and organize-imports in live Emacs** - checkpoint approved, no commit needed

**Plan metadata:** (pending)

## Files Created/Modified
- `emacs.d/config.org` - Added lsp-eslint-auto-fix-on-save hooks for typescript-mode and typescriptreact-mode, buffer-local organize-imports before-save hooks, typescript-indent-level 2, updated TypeScript section prose, removed unused JavaScript section

## Decisions Made

1. **Switched from lsp-format-buffer-on-save to lsp-eslint-auto-fix-on-save** - User's Next.js project uses ESLint with eslint-plugin-prettier. The `lsp-format-buffer-on-save` mechanism would use typescript-language-server's built-in formatter, which doesn't respect the project's `.prettierrc.json`. ESLint auto-fix runs `eslint --fix` which invokes Prettier through the plugin, using the correct config including `tabWidth: 2`.

2. **Set typescript-indent-level to 2** - Matches the project's Prettier tabWidth setting. Without this, Emacs default indentation (4 spaces) would conflict with the 2-space formatting that Prettier applies on save.

3. **Removed JavaScript section (`:tangle no` block)** - The unused JavaScript section contained `abrampers/set-eslint-config` function definition. Even though it was in a `:tangle no` block (not tangled to init.el), removing it prevents confusion and eliminates the risk of someone accidentally enabling it.

## Deviations from Plan

### Checkpoint-driven Changes

**1. [Checkpoint Feedback] Switched format-on-save mechanism from lsp-format-buffer-on-save to lsp-eslint-auto-fix-on-save**
- **Found during:** Task 2 checkpoint verification
- **Issue:** Plan specified `lsp-format-buffer-on-save` with `lsp-format-buffer-on-save-list`, but user's project uses ESLint+Prettier pipeline. The LSP formatter doesn't respect `.prettierrc.json` settings.
- **Fix:** Removed `lsp-format-buffer-on-save` and `lsp-format-buffer-on-save-list` from lsp-mode `:custom`. Added buffer-local `lsp-eslint-auto-fix-on-save t` via `setq-local` in typescript-mode-hook and typescriptreact-mode-hook lambdas.
- **Files modified:** emacs.d/config.org
- **Committed in:** `72c7989`

**2. [Checkpoint Feedback] Added typescript-indent-level 2**
- **Found during:** Task 2 checkpoint verification
- **Issue:** Not in original plan. Emacs default typescript-indent-level is 4, but project uses 2-space indentation.
- **Fix:** Added `:custom (typescript-indent-level 2)` to typescript-mode use-package block.
- **Files modified:** emacs.d/config.org
- **Committed in:** `72c7989`

**3. [Rule 1 - Bug] Removed unused JavaScript section to prevent void-function error**
- **Found during:** Task 2 checkpoint verification
- **Issue:** The JavaScript section (`:tangle no`) contained `abrampers/set-eslint-config` which would cause a void-function error if referenced. Removed entire unused section.
- **Fix:** Deleted the JavaScript `:tangle no` block.
- **Files modified:** emacs.d/config.org
- **Committed in:** `72c7989`

---

**Total deviations:** 3 (2 checkpoint-driven refinements, 1 auto-fix bug)
**Impact on plan:** All changes improve correctness. The ESLint auto-fix approach is more appropriate for the user's project than the originally planned lsp-format-buffer-on-save.

## Issues Encountered
None - both the initial implementation and the refinements worked correctly after checkpoint feedback.

## Known Stubs
None - all features are fully wired and verified in live Emacs.

## User Setup Required
None - no external service configuration required. All changes are in emacs.d/config.org.

## Next Phase Readiness
- This is the final phase of the project. All 3 phases complete.
- Core value delivered: LSP navigation + format-on-save + code actions for TypeScript in Emacs
- All v1 requirements for Phase 3 (FMT-01, FMT-02, FMT-03, ACT-01, ACT-02) verified

## Self-Check: PASSED

- [x] `03-01-SUMMARY.md` exists
- [x] Commit `4137f7b` (Task 1) found
- [x] Commit `72c7989` (Task 1 refinement) found
- [x] `emacs.d/config.org` exists

---
*Phase: 03-format-on-save-code-actions*
*Completed: 2026-03-25*
