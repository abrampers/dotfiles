setlocal noexpandtab
setlocal shiftwidth=4
setlocal tabstop=4

let g:go_gopls_enabled = 1

" vim-go
let g:go_fmt_command = "goimports"
let g:go_echo_command_info = 0
let g:go_code_completion_enabled = 1
let g:go_implements_mode = 'gopls'
let g:go_auto_sameids = 1

let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_variable_declarations = 1

let g:go_debug_windows = {
      \ 'vars':       'rightbelow 60vnew',
      \ 'stack':      'rightbelow 10new',
\ }

