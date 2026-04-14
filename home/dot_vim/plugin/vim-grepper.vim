nmap gs  <plug>(GrepperOperator)
xmap gs  <plug>(GrepperOperator)
command! Todo :Grepper -tool rg -query '\(TODO\|FIXME\)'<CR>

let g:grepper = {}
let g:grepper.side = 1
let g:grepper.tools = ['rg', 'git']
