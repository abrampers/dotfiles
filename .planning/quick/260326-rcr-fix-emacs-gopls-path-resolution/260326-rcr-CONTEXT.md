# Quick Task 260326-rcr: Fix Emacs gopls path resolution - Context

**Gathered:** 2026-03-26
**Status:** Completed

## Task Boundary

Investigate why `(executable-find "gopls")` in Emacs resolved to an outdated binary even though `GOPATH` already matched the active gvm session, then fix Emacs so Go tooling uses the active-session `gopls`.

## Findings

- `GOPATH` in Emacs already pointed at the active gvm pkgset: `/Users/abram.perdanaputra/.gvm/pkgsets/go1.26.1/global`
- `PATH` still had `/Users/abram.perdanaputra/bin` ahead of `GOPATH/bin`
- `~/bin/gopls` was stale (`v0.16.2`) while the active gvm pkgset had `gopls v0.21.1`
- `lsp-go-gopls-server-path` already derived from `GOPATH`, but `executable-find` and any PATH-based callers still saw the stale binary first

## Fix Direction

- Keep the existing gvm-driven `GOPATH` source of truth
- After `exec-path-from-shell` initializes Emacs environment, prepend the active `GOPATH/bin` to both `exec-path` and `PATH`
- Leave other language LSP setups unchanged

## Verification

- Direct helper invocation in batch Emacs changed `(executable-find "gopls")` from `~/bin/gopls` to the active `GOPATH/bin/gopls`
- The configured `lsp-go-gopls-server-path` continues to point at the active gvm pkgset binary
