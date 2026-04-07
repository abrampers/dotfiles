# Requirements: Chezmoi Migration for Dotfiles Management

**Defined:** 2026-04-02
**Core Value:** Replace `rcm` with `chezmoi` without changing the working local-machine experience or losing confidence in which files are managed.

## v1 Requirements

Requirements for initial release. Each maps to roadmap phases.

### Provisioning

- [x] **PROV-01**: Operator can install `chezmoi` through the existing Ansible Homebrew workflow without removing `rcm`.
- [x] **PROV-02**: Operator can run the migration workflow while `rcm` remains available as the current deployment path until cutover is verified.
- [x] **PROV-03**: Operator can treat `chezmoi` installation and the first real `chezmoi apply` as separate workflow steps rather than a single automation action.
- [x] **PROV-04**: Operator can run `ansible/local_machine.yml` so it executes `chezmoi` dry-run/preview behavior and then leaves the real apply decision to the operator.

### Source Layout

- [x] **LAYO-01**: Operator can store managed home-state in a bounded `chezmoi` source layout that fits this repository's existing structure.
- [x] **LAYO-02**: Operator can preserve the current `rcrc` exclusion contract in the new `chezmoi` configuration so previously excluded files do not become managed accidentally.
- [x] **LAYO-03**: Operator can import existing `rcm`-managed targets into `chezmoi` without importing symlink artifacts instead of real file contents.

### Verification

- [x] **VERI-01**: Operator can capture a durable baseline of the current `rcm`-managed file set before the first non-dry-run `chezmoi apply`.
- [ ] **VERI-02**: Operator can review `chezmoi` dry-run or diff output before the first real apply.
- [ ] **VERI-03**: Operator can verify after cutover that the `chezmoi`-managed target set matches the recorded `rcm` baseline or documents intentional exceptions.
- [x] **VERI-04**: Operator can keep local/private override files out of the shared managed set during migration.

### Cutover

- [ ] **CUTO-01**: Operator can perform the first real `chezmoi apply` without making cleanup of legacy `rcm` links an automatic side effect.
- [ ] **CUTO-02**: Operator must explicitly confirm before any destructive cleanup step such as `rcdn`.
- [ ] **CUTO-03**: Operator can prove the local machine still works before and after `chezmoi` integration.
- [ ] **CUTO-04**: Operator can run the first real `chezmoi apply` from a separate Ansible playbook independently of `ansible/local_machine.yml`.
- [ ] **CUTO-05**: Operator can also opt into running the real `chezmoi apply` from `ansible/local_machine.yml` without losing the default preview-only, decide-first behavior.

### Documentation

- [ ] **DOCU-01**: Operator can follow `README.org` to understand the separate `chezmoi` install, dry-run, decision point, independent apply playbook, and optional local-machine apply path in the migration workflow.

## v2 Requirements

Deferred to future release. Tracked but not in current roadmap.

### Migration Ergonomics

- **ERGO-01**: Operator can enforce a minimum supported `chezmoi` version through `.chezmoiversion`.
- **ERGO-02**: Operator can run `chezmoi doctor` as a standard preflight check before cutover.
- **ERGO-03**: Operator can generate a machine-readable parity report that highlights matches, intentional exceptions, and unexpected drift.
- **ERGO-04**: Operator can audit unmanaged files after cutover to confirm ownership boundaries explicitly.

### Advanced Chezmoi Features

- **ADVC-01**: Operator can use targeted templates only for files that truly need machine-specific behavior.
- **ADVC-02**: Operator can migrate portable symlinks with template-backed path handling where absolute links need normalization.
- **ADVC-03**: Operator can introduce secret-management support for managed files without storing secrets in plaintext.
- **ADVC-04**: Operator can adopt narrow `chezmoi --exact` or `--create` semantics only after ownership boundaries are proven stable.

## Out of Scope

| Feature | Reason |
|---------|--------|
| Rewriting unrelated shell, editor, tmux, or window-manager configs | The migration focuses on deployment ownership, not config redesign |
| Immediate removal of `rcm` with no coexistence period | Rollback and trust would be too fragile during first cutover |
| Broad platform support beyond current macOS and Homebrew workflow | The repository remains intentionally macOS-first |
| Broad repo/layout cleanup beyond what `chezmoi` needs | Too many variables change at once and parity becomes hard to judge |
| Blanket templating across the repo | Adds migration risk without helping the first behavior-preserving cutover |
| Plaintext secret migration during first cutover | Expands risk surface during a safety-critical migration |
| Broad recursive exact-sync ownership of high-level directories | Could unintentionally remove or claim files outside the intended managed set |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| PROV-01 | Phase 1 | Complete |
| PROV-02 | Phase 1 | Complete |
| PROV-03 | Phase 1 | Complete |
| PROV-04 | Phase 1 | Complete |
| LAYO-01 | Phase 2 | Complete |
| LAYO-02 | Phase 2 | Complete |
| LAYO-03 | Phase 2 | Complete |
| VERI-01 | Phase 1 | Complete |
| VERI-02 | Phase 2 | Pending |
| VERI-03 | Phase 3 | Pending |
| VERI-04 | Phase 2 | Complete |
| CUTO-01 | Phase 3 | Pending |
| CUTO-02 | Phase 3 | Pending |
| CUTO-03 | Phase 3 | Pending |
| CUTO-04 | Phase 3 | Pending |
| CUTO-05 | Phase 3 | Pending |
| DOCU-01 | Phase 3 | Pending |

**Coverage:**
- v1 requirements: 17 total
- Mapped to phases: 17
- Unmapped: 0 ✓

---
*Requirements defined: 2026-04-02*
*Last updated: 2026-04-06 after clarifying independent and local-machine apply paths*
