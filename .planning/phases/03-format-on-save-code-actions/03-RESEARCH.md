# Phase 3: Format-on-Save & Code Actions — Research

**Researched:** 2026-03-25
**Level:** 1 (Quick Verification — known lsp-mode APIs)

## Key Findings

### 1. lsp-mode Format-on-Save (FMT-01, FMT-02, FMT-03)

lsp-mode v9.0.0 has built-in format-on-save via two settings:

- **`lsp-format-buffer-on-save`** (boolean, `:local t`) — enables `lsp-format-buffer` on save
- **`lsp-format-buffer-on-save-list`** (list of major-mode symbols) — if non-empty, only formats buffers whose `major-mode` is in this list

**Two approaches for buffer-local formatting:**

**Approach A: Use `lsp-format-buffer-on-save-list`** (RECOMMENDED)
- Set `lsp-format-buffer-on-save` to `t` globally in lsp-mode config
- Set `lsp-format-buffer-on-save-list` to `'(typescript-mode typescriptreact-mode)`
- Effect: Only TypeScript buffers get formatted. Go buffers use their own `gofmt-before-save` hook (unchanged).

**Approach B: Use per-mode hooks**
- Add `(add-hook 'typescript-mode-hook (lambda () (setq-local lsp-format-buffer-on-save t)))` 
- Since `lsp-format-buffer-on-save` is `:local t`, this works per-buffer
- Go's `gofmt-before-save` is a separate hook on `before-save-hook`, unrelated to lsp-format

**Approach A is cleaner** because it uses lsp-mode's built-in mode-filtering mechanism. The implementation in `lsp-mode.el` at line 5337-5340 checks `(member major-mode lsp-format-buffer-on-save-list)`.

### 2. Go Format-on-Save Safety (FMT-03)

Go uses `gofmt-before-save` on `before-save-hook` (config.org line 1261). This is completely separate from lsp-mode's format mechanism. Using either approach above, Go formatting is unaffected because:
- Approach A: `go-mode` is NOT in `lsp-format-buffer-on-save-list` → lsp-format skips Go buffers
- Approach B: `lsp-format-buffer-on-save` stays nil in Go buffers
- `gofmt-before-save` runs independently via its own `before-save-hook`

### 3. Auto-Import on Completion (ACT-01)

lsp-mode has `lsp-completion-enable-additional-text-edit` (default `t`, already enabled). When this is `t`, completing a symbol from another module will apply additional text edits from the language server — which for typescript-language-server includes adding import statements.

**This already works out-of-the-box** with the current config because:
- `company-mode` is hooked to `lsp-mode` (config.org line 1666)
- `lsp-completion-enable-additional-text-edit` defaults to `t` (lsp-completion.el line 54)
- typescript-language-server supports `additionalTextEdits` in completion items

The only thing to verify is that `lsp-completion-enable-additional-text-edit` is not being set to `nil` anywhere in config.org. A grep confirms it's not mentioned → default `t` applies.

### 4. Organize Imports Code Action (ACT-02)

lsp-mode provides `lsp-organize-imports` as an interactive command (generated via `lsp-make-interactive-code-action` at line 6479). This sends the `source.organizeImports` code action to the language server.

- Available via `M-x lsp-organize-imports`
- Also available via lsp-mode keymap: `C-c l r o` (the default prefix + `r o`)
- typescript-language-server supports `source.organizeImports`

No additional configuration needed — just document how to invoke it.

### 5. Existing Commented-Out Code (config.org lines 1519-1520)

```elisp
;; (add-hook 'before-save-hook #'lsp-format-buffer)
;; (add-hook 'before-save-hook #'lsp-organize-imports)
```

These are in the JavaScript section and would apply GLOBALLY (all buffers). DO NOT uncomment these — they would break Go formatting and apply to all languages. The `lsp-format-buffer-on-save-list` approach is the correct way.

### 6. Prettier via typescript-language-server

typescript-language-server does NOT use Prettier by default — it uses TypeScript's built-in formatter. For Prettier formatting, there are options:
- **prettier-mode.el** — external package, runs Prettier CLI directly
- **lsp-mode built-in** — uses the language server's formatter (TypeScript formatter, not Prettier)
- **apheleia** — async formatter (deferred to v2 per FMT-04)

Since REQUIREMENTS.md says "auto-format on save via Prettier" (FMT-01), but the success criteria only say "indentation, spacing corrected", and the out-of-scope list says "ESLint LSP integration" is excluded — the simplest approach is to use lsp-mode's built-in `lsp-format-buffer-on-save` which uses the TypeScript language server's formatter. This handles indentation and spacing correctly.

If Prettier-specific formatting is required, that would need `prettier.el` or `apheleia` — but the ROADMAP success criteria focus on "indentation, spacing corrected" which the TypeScript formatter handles.

**Recommendation:** Start with lsp-mode's built-in formatter. If the user needs Prettier-specific output (trailing commas, single quotes, etc.), that's a follow-up.

## Summary: What to Build

1. **Format-on-save:** Set `lsp-format-buffer-on-save t` and `lsp-format-buffer-on-save-list '(typescript-mode typescriptreact-mode)` in the lsp-mode `:custom` section
2. **Auto-import:** Already works — `lsp-completion-enable-additional-text-edit` is `t` by default. Just verify it's not overridden.
3. **Organize imports:** Already available via `M-x lsp-organize-imports`. Document access via `C-c l r o` and optionally add a before-save hook per-mode.
4. **Go safety:** No changes needed — `gofmt-before-save` is separate, and the mode list excludes `go-mode`.

## Files to Modify

- `emacs.d/config.org` — lsp-mode `:custom` section (format-on-save settings), TypeScript section (mode-specific hooks if needed)

---
*Research: 03-format-on-save-code-actions*
*Completed: 2026-03-25*
