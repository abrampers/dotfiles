" Linters
let b:ale_linters = ['buf-lint']
let b:ale_lint_on_text_changed = 'never'
let b:ale_linters_explicit = 1

" Fixers
let b:ale_fixers = ['remove_trailing_lines', 'trim_whitespace']
let b:ale_fix_on_save = 1
