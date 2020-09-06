setlocal shiftwidth=2
setlocal smartindent
setlocal tabstop=2

let g:rails_ctags_arguments = ['--languages=ruby --exclude=.git --exclude=log . $(bundle list --paths)']
