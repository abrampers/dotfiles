# Phase 1: Diagnose & Fix Environment - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md -- this log preserves the alternatives considered.

**Date:** 2026-03-25
**Phase:** 01-diagnose-fix-environment
**Areas discussed:** Emacs PATH strategy, Mode routing for .ts vs .tsx, LSP hook strategy, lsp-mode commit verification approach

---

## Emacs PATH Strategy

### Q1: How should Emacs find nvm-managed Node.js and typescript-language-server?

| Option | Description | Selected |
|--------|-------------|----------|
| Explicit env var copy | Add NVM_DIR and explicit nvm PATH to exec-path-from-shell-copy-envs. Most reliable -- guarantees Node.js is found even if shell init is different for Emacs. Follows the same pattern used for GOPATH. | ✓ |
| Rely on PATH inheritance | Trust that exec-path-from-shell-initialize with -l flag picks up nvm PATH from zshrc. Simpler but fragile. | |
| Hardcode typescript-language-server path | Set lsp-typescript-server-path directly to the nvm-managed binary path. Bypasses PATH entirely but hardcodes the Node version path. | |

**User's choice:** Explicit env var copy
**Notes:** None

### Q2: Which nvm-related environment variables should exec-path-from-shell copy into Emacs?

| Option | Description | Selected |
|--------|-------------|----------|
| NVM_DIR + PATH | Copy NVM_DIR plus let exec-path-from-shell-initialize handle PATH (which includes nvm shims). Minimal change -- just one new copy-env line alongside existing GOPATH. | ✓ |
| NVM_DIR + NVM_BIN + PATH | Copy NVM_DIR, NVM_BIN, and PATH. NVM_BIN points directly to the active Node version's bin directory. Belt-and-suspenders approach. | |
| Copy all shell env vars | Copy all env vars from shell. Broadest coverage but may bring in unwanted side effects. | |

**User's choice:** NVM_DIR + PATH
**Notes:** None

### Q3: While editing exec-path-from-shell, should we also re-enable PYENV_ROOT?

| Option | Description | Selected |
|--------|-------------|----------|
| Also uncomment PYENV_ROOT | Re-enable the commented-out PYENV_ROOT copy while editing the section. | |
| NVM_DIR only | Only add NVM_DIR. Keep changes minimal and focused on TypeScript LSP. | ✓ |

**User's choice:** NVM_DIR only
**Notes:** None

### Q4: How should we verify the PATH fix works?

| Option | Description | Selected |
|--------|-------------|----------|
| Verify in Emacs | Run (executable-find "node") and (executable-find "typescript-language-server") in Emacs to confirm. Matches the phase success criteria. | ✓ |
| Diagnostic elisp script | Write a small elisp script that evaluates checks and outputs results to *Messages*. | |
| You decide | Let the agent decide how to verify. | |

**User's choice:** Verify in Emacs
**Notes:** None

---

## Mode Routing for .ts vs .tsx

### Q1: Should .ts and .tsx files use separate Emacs modes?

| Option | Description | Selected |
|--------|-------------|----------|
| Separate modes | Split into two entries: .ts -> typescript-mode, .tsx -> typescriptreact-mode. Each gets the correct tree-sitter parser. | ✓ |
| Keep unified (current) | Keep both .ts and .tsx in typescriptreact-mode as-is. The tsx tree-sitter parser handles .ts files fine in practice. | |
| You decide | Let the agent decide based on what works best with lsp-mode's typescript-language-server detection. | |

**User's choice:** Separate modes
**Notes:** None

---

## LSP Hook Strategy

### Q1: Should TypeScript LSP hooks use eager (#'lsp) or deferred (#'lsp-deferred) mode?

| Option | Description | Selected |
|--------|-------------|----------|
| Use lsp-deferred | Switch TypeScript hooks to #'lsp-deferred to match Go. With separate modes, each mode gets its own hook calling lsp-deferred once. | ✓ |
| Keep eager #'lsp | Keep #'lsp (eager) for TypeScript. Faster initial LSP connection but may cause startup issues in large Next.js projects. | |
| You decide | Let the agent decide based on what the researcher finds about lsp-mode best practices. | |

**User's choice:** Use lsp-deferred
**Notes:** None

---

## lsp-mode Commit Verification Approach

### Q1: How should we verify the actual loaded lsp-mode version?

| Option | Description | Selected |
|--------|-------------|----------|
| Manual M-x verification | Run M-x lsp-version and (straight--get-recipe 'lsp-mode) in a live Emacs session. Document the actual loaded commit hash and compare to v9.0.0 tag. | ✓ |
| Elisp diagnostic script | Write a small elisp script that evaluates the checks and outputs results to *Messages*. More repeatable but adds implementation overhead. | |
| Git log check on disk | Check the git log of the straight.el repo on disk to verify what commit bdae0f4 corresponds to without launching Emacs. | |

**User's choice:** Manual M-x verification
**Notes:** None

---

## Agent's Discretion

- Exact diagnostic steps ordering (check Node first vs lsp-mode first)
- How to document diagnostic findings (inline notes vs separate file)
- Whether to check `(executable-find "tsc")` in addition to `typescript-language-server`
- Node.js version pinning strategy

## Deferred Ideas

None -- discussion stayed within phase scope.
