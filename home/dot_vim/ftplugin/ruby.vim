setlocal shiftwidth=2
setlocal smartindent
setlocal tabstop=2

let g:rails_ctags_arguments = ['--languages=ruby --exclude=.git --exclude=log . $(bundle list --paths)']
let g:rubycomplete_buffer_loading = 1 
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1

