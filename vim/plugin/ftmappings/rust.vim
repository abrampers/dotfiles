function! ftmappings#rust#ycm_maps()
  nnoremap <silent> <buffer> gi :YcmCompleter GoToImplementation<CR>
  nnoremap <silent> <buffer> gd :YcmCompleter GoTo<CR>
  nnoremap <silent> <buffer> gr :YcmCompleter GoToReferences<CR>
  nnoremap <silent> <buffer> <LocalLeader>r :YcmCompleter RefactorRename<Space>
endfunction

autocmd FileType rust call ftmappings#rust#ycm_maps()
