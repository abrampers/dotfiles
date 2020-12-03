function! ftmappings#vim#mappings()
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)
endfunction

autocmd FileType vim call ftmappings#vim#mappings()
