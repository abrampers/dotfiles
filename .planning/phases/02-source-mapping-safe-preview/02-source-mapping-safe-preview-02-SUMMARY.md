---
phase: 02-source-mapping-safe-preview
plan: 02
subsystem: infra
tags: [chezmoi, migration, source-import, zsh, vim, emacs]
requires:
  - phase: 02-source-mapping-safe-preview
    provides: bounded home/ source root, import contract, and denylist rules
provides:
  - root-level managed dotfiles imported into home/ as regular chezmoi source files
  - shared .zsh, .vim, and .emacs.d trees imported with real file contents via add --follow
  - preserved local override hooks without importing local-only override files
affects: [phase-2-preview, phase-2-xdg-imports, phase-3-parity]
tech-stack:
  added: []
  patterns: [chezmoi add --follow imports from deployed home state, regular-file source imports for shared tool trees]
key-files:
  created: [home/dot_README.org, home/dot_ideavimrc, home/dot_rcrc, home/dot_tigrc, home/dot_tmux.conf, home/dot_zshenv, home/dot_zshrc, home/dot_zsh/aliases.zsh, home/dot_vim/vimrc, home/dot_emacs.d/init.el]
  modified: []
key-decisions:
  - "Treat the approved import contract as the only source for root and tool-tree imports instead of rediscovering files from the repo."
  - "Re-import shared tool trees from deployed home paths with chezmoi add --follow so home/ stores real contents instead of placeholder symlink artifacts."
patterns-established:
  - "Root-level non-XDG targets land directly under home/ as dot_* files mapped from live home-state."
  - "Top-level tool trees are imported from live deployed paths, preserving loader hooks while denylist rules keep local overrides unmanaged."
requirements-completed: [LAYO-01, LAYO-03]
duration: 6 min
completed: 2026-04-07
---

# Phase 2 Plan 2: Source Mapping & Safe Preview Summary

**Root dotfiles plus shared zsh, vim, and emacs trees imported into home/ as real chezmoi-managed source content with local override hooks preserved.**

## Performance

- **Duration:** 6 min
- **Started:** 2026-04-07T06:18:37Z
- **Completed:** 2026-04-07T06:24:19Z
- **Tasks:** 2
- **Files modified:** 298

## Accomplishments
- Verified the approved root-level import set exists in `home/` as regular chezmoi source files.
- Imported the approved `.zsh`, `.vim`, and `.emacs.d` trees into `home/` using `chezmoi add --follow`.
- Preserved local/private loader hooks while keeping denylisted overrides outside shared source state.

## Task Commits

Each task was committed atomically:

1. **Task 1: Import all approved root-level dotfiles into `home/` with `add --follow`** - `00a4c98` (feat)
2. **Task 2: Import the `zsh`, `vim`, and `emacs.d` trees as real source content** - `bd8eb7a` (feat)

## Files Created/Modified
- `home/dot_zshrc` - Chezmoi-managed source for `~/.zshrc` imported from the deployed home file.
- `home/dot_zshenv` - Chezmoi-managed source for `~/.zshenv`.
- `home/dot_tmux.conf` - Shared tmux config source with local tmux override hook preserved.
- `home/dot_rcrc` - Imported `rcm` exclusion contract for parity reference.
- `home/dot_zsh/` - Shared zsh tree imported as real file contents.
- `home/dot_vim/` - Shared vim tree imported as real file contents including `vimrc`.
- `home/dot_emacs.d/` - Shared emacs tree imported as real file contents including `init.el` and `config.org`.

## Decisions Made
- Used `migration/chezmoi-import-targets.txt` as the single approved import contract for both root files and top-level tool trees.
- Preserved denylisted local/private files by relying on the reviewed Phase 2 denylist instead of broad recursive imports.
- Re-imported the tool trees after detecting placeholder `symlink_*` artifacts so `home/` now contains regular files that satisfy `LAYO-03`.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Replaced placeholder symlink artifacts with real imported tool-tree files**
- **Found during:** Task 2 (Import the `zsh`, `vim`, and `emacs.d` trees as real source content)
- **Issue:** The existing `home/dot_zsh` and `home/dot_vim` tree contained `symlink_*` placeholder files instead of the expected regular imported files, which would fail the plan's real-content requirement.
- **Fix:** Re-ran `chezmoi -S "$PWD" add --follow` for every approved `.zsh`, `.vim`, and `.emacs.d` target from the import contract so the source tree now stores real file contents.
- **Files modified:** `home/dot_zsh/`, `home/dot_vim/`, `home/dot_emacs.d/`
- **Verification:** Confirmed `home/dot_zsh/aliases.zsh`, `home/dot_vim/vimrc`, and `home/dot_emacs.d/init.el` are regular files; verified local hook strings remained present and denylisted overrides were still absent.
- **Committed in:** `bd8eb7a`

---

**Total deviations:** 1 auto-fixed (1 bug)
**Impact on plan:** The fix brought the imported source tree back in line with the plan's required real-content import behavior without widening scope.

## Issues Encountered
- Task 1 had already been committed in the repository before this execution resumed, so it was verified and accepted as the atomic root-import task commit instead of being redone.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness
- Plan 03 can now import the approved XDG subset into `home/dot_config` from the same reviewed contract.
- Preview and parity work can rely on `home/` as the source of truth for root and top-level non-XDG targets.

## Known Stubs
- `home/dot_zsh/zsh-autosuggestions/spec/integrations/zle_input_stack_spec.rb:12` - Upstream vendored test file contains a TODO comment; imported as-is from the managed shared plugin source.
- `home/dot_zsh/bin/executable_diff-highlight:105` - Imported script contains an existing TODO comment; not a Phase 2 placeholder.
- `home/dot_zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh:115` - Imported upstream plugin source contains existing TODO comments; preserved verbatim.
- `home/dot_vim/plugin/commands.vim:1` - Existing shared vim config includes TODO comments; imported verbatim from current managed content.
- `home/dot_vim/autoload/wincent/commands.vim:4` - Existing shared vim autoload code includes TODO comments; imported verbatim from current managed content.

## Self-Check: PASSED
- Found summary file: `.planning/phases/02-source-mapping-safe-preview/02-source-mapping-safe-preview-02-SUMMARY.md`
- Verified task commits: `00a4c98`, `bd8eb7a`

---
*Phase: 02-source-mapping-safe-preview*
*Completed: 2026-04-07*
