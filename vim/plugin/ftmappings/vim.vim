function! ftmappings#vim#ycm_maps()
  nnoremap <silent> <buffer> gd :YcmCompleter GoTo<CR>
  nnoremap <silent> <buffer> gr :YcmCompleter GoToReferences<CR>
endfunction

autocmd FileType vim call ftmappings#vim#ycm_maps()
