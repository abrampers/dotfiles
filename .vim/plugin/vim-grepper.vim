let g:grepper = {}
let g:grepper.tools = ['git', 'rg']
let g:grepper.highlight = 1

command! Todo :Grepper -tool ag -query '\(TODO\|FIXME\)'

nnoremap <Leader>g :Grepper<CR>
