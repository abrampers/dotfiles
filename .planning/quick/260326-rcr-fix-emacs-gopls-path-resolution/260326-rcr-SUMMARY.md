# Quick Task 260326-rcr Summary

Emacs now prefers the active gvm session's `GOPATH/bin` ahead of stale personal binaries, so `executable-find` resolves the same `gopls` that the active Go session expects.

## Root Cause

- `exec-path-from-shell` imported the correct `GOPATH`
- `PATH` ordering still left `~/bin` before `GOPATH/bin`
- `~/bin/gopls` was outdated (`v0.16.2`), so `(executable-find "gopls")` returned the wrong binary

## Changes

- Added `abram/prepend-path-entry`
- Added `abram/prefer-gopath-bin`
- Ran the new helper after `exec-path-from-shell-initialize`
- Kept `lsp-go-gopls-server-path` unchanged so existing Go LSP wiring stays stable

## Verification

- Shell environment: `GOPATH=/Users/abram.perdanaputra/.gvm/pkgsets/go1.26.1/global`
- Old resolution: `/Users/abram.perdanaputra/bin/gopls`
- Active-session binary: `/Users/abram.perdanaputra/.gvm/pkgsets/go1.26.1/global/bin/gopls`
- Version comparison: `~/bin/gopls` = `v0.16.2`, active gvm `gopls` = `v0.21.1`
- Batch Emacs helper check: `(executable-find "gopls")` resolved to `/Users/abram.perdanaputra/.gvm/pkgsets/go1.26.1/global/bin/gopls` after `abram/prefer-gopath-bin`

## Files

- `emacs.d/config.org`
- `.planning/quick/260326-rcr-fix-emacs-gopls-path-resolution/260326-rcr-CONTEXT.md`
- `.planning/quick/260326-rcr-fix-emacs-gopls-path-resolution/260326-rcr-SUMMARY.md`
