function! mappings#coc#SetupMappings()
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)
  nmap <silent> <LocalLeader>r <Plug>(coc-rename)
  nmap <silent> <Leader>t <Plug>(coc-refactor)
endfunction
