# Requirements: Emacs Next.js/TypeScript LSP Setup

**Defined:** 2026-03-25
**Core Value:** LSP code navigation (gd, gi, gr, gy, ,r) works reliably in .ts and .tsx files inside a Next.js project, matching the Go editing experience.

## v1 Requirements

Requirements for initial release. Each maps to roadmap phases.

### Diagnostics

- [x] **DIAG-01**: Verify actual loaded lsp-mode commit hash matches v9.0.0 tag
- [ ] **DIAG-02**: Fix straight.el lockfile to point to correct lsp-mode v9.0.0 commit
- [x] **DIAG-03**: Verify Node.js version (via nvm) is sufficient for typescript-language-server
- [ ] **DIAG-04**: Install typescript-language-server and typescript as npm global packages and pin versions in the codebase

### Environment

- [ ] **ENV-01**: Emacs inherits nvm-managed Node.js PATH so that LSP servers installed via npm are discoverable
- [ ] **ENV-02**: exec-path-from-shell config updated to ensure nvm shims are on Emacs exec-path

### LSP Navigation

- [ ] **NAV-01**: User can go-to-definition (gd) in .ts and .tsx files
- [ ] **NAV-02**: User can find-references (gr) in .ts and .tsx files
- [ ] **NAV-03**: User can find-implementation (gi) in .ts and .tsx files
- [ ] **NAV-04**: User can find-type-definition (gy) in .ts and .tsx files
- [ ] **NAV-05**: User can rename symbol (,r) in .ts and .tsx files

### Format

- [ ] **FMT-01**: TypeScript files (.ts) auto-format on save via Prettier
- [ ] **FMT-02**: TSX files (.tsx) auto-format on save via Prettier
- [ ] **FMT-03**: Format-on-save is buffer-local (does not affect Go gofmt or other language formatters)

### Code Actions

- [ ] **ACT-01**: Auto-import symbols on completion (lsp-mode auto-import)
- [ ] **ACT-02**: Organize imports code action available

### Regression

- [ ] **REG-01**: Go LSP (gopls) still works after all changes
- [ ] **REG-02**: Other language LSPs (Clojure, etc.) unaffected

## v2 Requirements

Deferred to future release. Tracked but not in current roadmap.

### Format

- **FMT-04**: Async formatting via apheleia (if synchronous Prettier is too slow)

### Navigation

- **NAV-06**: Project-aware test file toggle for TypeScript

### Code Actions

- **ACT-03**: Quick-fix code actions (e.g., add missing return type)

## Out of Scope

Explicitly excluded. Documented to prevent scope creep.

| Feature | Reason |
|---------|--------|
| .js/.jsx file support | TS-only workflow, not needed |
| ESLint LSP integration | Not requested, adds complexity |
| Tailwind CSS LSP | Not requested, focused fix only |
| Neovim TypeScript setup | Emacs only |
| treesit migration (Emacs 29+ built-in) | Would require rewriting all mode hooks, auto-mode-alist, indentation; too disruptive for minimal benefit |
| eglot migration | lsp-mode works for Go and other languages; no reason to switch LSP client |
| web-mode for TSX | typescript-mode + derived typescriptreact-mode already handles TSX; web-mode would conflict |
| rjsx-mode | Already disabled in config; not needed for TS-only workflow |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| DIAG-01 | Phase 1 | Complete |
| DIAG-02 | Phase 2 | Pending |
| DIAG-03 | Phase 1 | Complete |
| DIAG-04 | Phase 2 | Pending |
| ENV-01 | Phase 1 | Pending |
| ENV-02 | Phase 1 | Pending |
| NAV-01 | Phase 2 | Pending |
| NAV-02 | Phase 2 | Pending |
| NAV-03 | Phase 2 | Pending |
| NAV-04 | Phase 2 | Pending |
| NAV-05 | Phase 2 | Pending |
| FMT-01 | Phase 3 | Pending |
| FMT-02 | Phase 3 | Pending |
| FMT-03 | Phase 3 | Pending |
| ACT-01 | Phase 3 | Pending |
| ACT-02 | Phase 3 | Pending |
| REG-01 | Phase 2 | Pending |
| REG-02 | Phase 2 | Pending |

**Coverage:**
- v1 requirements: 18 total
- Mapped to phases: 18 ✓
- Unmapped: 0

---
*Requirements defined: 2026-03-25*
*Last updated: 2026-03-25 after roadmap creation (traceability mapped)*
