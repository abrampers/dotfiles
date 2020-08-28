let g:grepper = {}
let g:grepper.tools = ['git', 'rg']
let g:grepper.highlight = 1

command! Todo :Grepper -query '\(TODO\|FIXME\)'

nnoremap <Leader>gr :Grepper<CR>
