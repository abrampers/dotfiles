# Roadmap: Chezmoi Migration for Dotfiles Management

## Overview

This roadmap replaces `rcm` with `chezmoi` in a safety-first sequence: first preserve the current deployment path, install `chezmoi`, and capture a trusted baseline without crossing the apply trust boundary; then map the existing repo into bounded `chezmoi` source state with previewable changes; and finally perform a confirmation-gated cutover where real apply can happen from a dedicated playbook or an explicit apply path in `ansible/local_machine.yml`, while still proving parity and preserving day-to-day machine behavior.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [x] **Phase 1: Provisioning Coexistence & Baseline** - Install `chezmoi` into the current Ansible flow, keep apply separate, preserve `rcm`, and record the current managed-file truth.
- [ ] **Phase 2: Source Mapping & Safe Preview** - Create bounded `chezmoi` source state, preserve exclusions, protect local overrides, and make migration changes reviewable before apply.
- [ ] **Phase 3: Confirmation-Gated Cutover & Parity Proof** - Run the first real `chezmoi` apply safely from either an independent playbook or an explicit local-machine apply path, require explicit cleanup confirmation, document the operator flow, and verify parity plus machine stability afterward.

## Phase Details

### Phase 1: Provisioning Coexistence & Baseline
**Goal**: Operator can introduce `chezmoi` through the existing automation without losing the current `rcm` workflow or visibility into the current managed-file set.
**Depends on**: Nothing (first phase)
**Requirements**: PROV-01, PROV-02, PROV-03, PROV-04, VERI-01
**Success Criteria** (what must be TRUE):
  1. Operator can run the existing Ansible/Homebrew setup and get `chezmoi` installed without removing or disabling `rcm`.
  2. Operator can continue using the current `rcm` deployment path while migration work remains unfinished.
  3. Operator can treat `chezmoi` install/dry-run and the first real `chezmoi apply` as separate steps in the migration flow.
  4. Operator can run `ansible/local_machine.yml` and see `chezmoi` preview behavior without that playbook performing the real apply.
  5. Operator can inspect a durable saved baseline of the current `rcm`-managed file set before any non-dry-run `chezmoi apply`.
**Plans**: 2 plans

Plans:
- [x] `01-01-PLAN.md` — Split the dotfiles role into explicit `rcm` and `chezmoi` slices, install `chezmoi`, and preserve the existing `rcup` path.
- [x] `01-02-PLAN.md` — Capture the `rcm` baseline, run preview-only `chezmoi` behavior, and document the operator flow.

### Phase 2: Source Mapping & Safe Preview
**Goal**: Operator can represent the current managed home-state in bounded `chezmoi` source state without accidentally expanding scope or importing the wrong content.
**Depends on**: Phase 1
**Requirements**: LAYO-01, LAYO-02, LAYO-03, VERI-02, VERI-04
**Success Criteria** (what must be TRUE):
  1. Operator can point `chezmoi` at a bounded source layout that maps this repo's intended managed targets without pulling repo-only files into home-state management.
  2. Operator can confirm the current `rcrc` exclusion contract and known local/private override files remain outside the shared managed set.
  3. Operator can import existing managed targets into `chezmoi` and see real file contents preserved instead of back-references to `rcm` symlink artifacts.
  4. Operator can review `chezmoi` dry-run or diff output before the first real apply and understand what would change.
**Plans**: 4 plans

Plans:
- [x] `02-01-PLAN.md` — Define the bounded chezmoi root, explicit ignore/denylist rules, and baseline-derived import contract.
- [x] `02-02-PLAN.md` — Import root and top-level managed targets into `home/` with `chezmoi add --follow`.
- [x] `02-03-PLAN.md` — Import the XDG-managed set into `home/dot_config` without broad `.config` ownership.
- [ ] `02-04-PLAN.md` — Wire repo-backed preview evidence and mismatch blocking into `ansible/local_machine.yml`.

### Phase 3: Confirmation-Gated Cutover & Parity Proof
**Goal**: Operator can switch to `chezmoi` on the live machine without automatic destructive cleanup and with proof that managed-file ownership and machine behavior still match expectations.
**Depends on**: Phase 2
**Requirements**: VERI-03, CUTO-01, CUTO-02, CUTO-03, CUTO-04, CUTO-05, DOCU-01
**Success Criteria** (what must be TRUE):
  1. Operator can perform the first real `chezmoi apply` from a dedicated Ansible playbook independent of `ansible/local_machine.yml`.
  2. Operator can also opt into a real `chezmoi apply` path inside `ansible/local_machine.yml` while the default path remains preview-only.
  3. Operator can perform the first real `chezmoi apply` without automatically triggering legacy `rcm` cleanup.
  4. Operator must explicitly confirm before any destructive cleanup step such as `rcdn` can run.
  5. Operator can compare the post-cutover `chezmoi`-managed target set against the recorded `rcm` baseline and either see parity or a documented list of intentional exceptions.
  6. Operator can verify the local machine still behaves correctly before and after `chezmoi` integration.
  7. Operator can follow `README.org` for the install, dry-run, decision, independent apply, and optional local-machine apply sequence.
**Plans**: TBD

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Provisioning Coexistence & Baseline | 2/2 | Complete | 2026-04-06 |
| 2. Source Mapping & Safe Preview | 3/4 | In Progress | - |
| 3. Confirmation-Gated Cutover & Parity Proof | 0/TBD | Not started | - |
