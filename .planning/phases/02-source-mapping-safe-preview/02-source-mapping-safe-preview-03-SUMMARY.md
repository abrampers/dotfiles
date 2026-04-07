---
phase: 02-source-mapping-safe-preview
plan: 03
subsystem: infra
tags: [chezmoi, migration, xdg, source-import, config]
requires:
  - phase: 02-source-mapping-safe-preview
    provides: bounded home/ source root, import contract, and root/tool imports
provides:
  - approved ~/.config targets imported into home/dot_config as explicit chezmoi source files
  - bounded XDG source mapping without any exact_ ownership markers
  - verified local/private boundaries preserved outside the shared XDG source tree
affects: [phase-2-preview, phase-3-parity, xdg-source-mapping]
tech-stack:
  added: []
  patterns: [explicit home/dot_config target mirroring, file-level XDG imports without --exact, denylist-backed XDG boundary audit]
key-files:
  created: [home/dot_config/alacritty/alacritty.toml, home/dot_config/nvim/init.vim, home/dot_config/skhd/skhdrc, home/dot_config/opencode/opencode.jsonc, home/dot_config/yabai/executable_yabairc]
  modified: []
key-decisions:
  - "Import approved XDG targets into home/dot_config as explicit file mappings instead of claiming broad .config ownership."
  - "Keep XDG cleanup limited to home/ with denylist verification rather than altering legacy repo paths outside the bounded subtree."
patterns-established:
  - "Approved ~/.config targets are mirrored under home/dot_config with chezmoi naming translations like executable_ and private_ only where target semantics require them."
  - "XDG boundary validation is performed against migration/chezmoi-import-targets.txt plus the denylist, and can complete without extra cleanup when the subtree is already clean."
requirements-completed: [LAYO-01, LAYO-03, VERI-04]
duration: 4 min
completed: 2026-04-07
---

# Phase 2 Plan 3: Source Mapping & Safe Preview Summary

**Approved XDG configs now live under home/dot_config as explicit chezmoi-managed files without broad .config ownership or local-only leakage.**

## Performance

- **Duration:** 4 min
- **Started:** 2026-04-07T06:26:42Z
- **Completed:** 2026-04-07T06:30:24Z
- **Tasks:** 2
- **Files modified:** 30

## Accomplishments
- Verified the approved `~/.config/...` import set is present under `home/dot_config/` as regular chezmoi source files.
- Confirmed representative mappings for `nvim`, `alacritty`, `skhd`, `karabiner`, `limelight`, `yabai`, and `coc` resolve into the bounded XDG subtree.
- Audited the XDG subtree against the import contract and denylist and found no extra source entries or leaked local/private targets.

## Task Commits

Each task was committed atomically where a file delta existed:

1. **Task 1: Import every approved `~/.config/...` target into `home/dot_config/`** - `36eddb6` (feat)
2. **Task 2: Enforce XDG boundary cleanliness inside `home/` only** - No additional file changes were required after the audit; the imported subtree already satisfied the task's cleanup criteria.

**Plan metadata:** Pending final docs commit

## Files Created/Modified
- `home/dot_config/alacritty/alacritty.toml` - Imported Alacritty XDG config as bounded chezmoi source.
- `home/dot_config/nvim/init.vim` - Imported Neovim XDG entrypoint that still delegates to `~/.vim/vimrc`.
- `home/dot_config/skhd/skhdrc` - Imported shared skhd config with the existing hyper-key bindings.
- `home/dot_config/opencode/` - Imported approved OpenCode XDG files as regular source content.
- `home/dot_config/coc/` - Imported the approved CoC extension and history files from the reviewed import contract.
- `home/dot_config/private_karabiner/private_karabiner.json` - Imported Karabiner config using chezmoi's target-name translation for private paths.
- `home/dot_config/yabai/executable_yabairc` - Imported yabai config using chezmoi's executable target-name translation.

## Decisions Made
- Imported XDG-managed targets as explicit files inside `home/dot_config/` rather than using any directory-wide exact-sync behavior.
- Accepted chezmoi naming translations such as `private_` and `executable_` where they are required to preserve target names and file modes while still matching the approved target list.
- Treated Task 2 as a bounded audit-only step when no accidental `home/dot_config/` entries or denylisted paths were present.

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered
- Task 1 had already been committed in the repository before this execution reached Plan 03, so it was verified and accepted as the atomic import commit instead of being re-run.
- Task 2 did not require any cleanup edits because the imported XDG subtree already matched the approved contract and denylist boundaries.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness
- Plan 04 can wire preview evidence and mismatch blocking against a fully populated bounded `home/` source tree, including XDG mappings.
- Phase 3 parity work can resolve representative XDG targets directly through `chezmoi source-path` without relying on the legacy repo layout.

## Self-Check: PASSED
- Found summary file: `.planning/phases/02-source-mapping-safe-preview/02-source-mapping-safe-preview-03-SUMMARY.md`
- Verified task commit: `36eddb6`
