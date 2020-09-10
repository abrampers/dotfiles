function! ftmappings#javascript#ycm_maps()
  nnoremap <silent> <buffer> gt :YcmCompleter GoToType<CR>
  nnoremap <silent> <buffer> gm :YcmCompleter GoToImplementation<CR>
  nnoremap <silent> <buffer> gd :YcmCompleter GoTo<CR>
  nnoremap <silent> <buffer> gr :YcmCompleter GoToReferences<CR>
  nnoremap <silent> <buffer> <LocalLeader>r :YcmCompleter RefactorRename<Space>
endfunction

autocmd FileType javascript call ftmappings#javascript#ycm_maps()
