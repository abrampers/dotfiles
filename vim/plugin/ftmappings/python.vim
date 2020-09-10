function! ftmappings#python#ycm_maps()
  nnoremap <silent> <buffer> gd :YcmCompleter GoTo<CR>
  nnoremap <silent> <buffer> gr :YcmCompleter GoToReferences<CR>
endfunction

autocmd FileType python call ftmappings#python#ycm_maps()
