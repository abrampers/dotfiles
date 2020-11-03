function! ftmappings#typescript#ycm_maps()
  nnoremap <silent> <buffer> gy :YcmCompleter GoToType<CR>
  nnoremap <silent> <buffer> gi :YcmCompleter GoToImplementation<CR>
  nnoremap <silent> <buffer> gd :YcmCompleter GoTo<CR>
  nnoremap <silent> <buffer> gr :YcmCompleter GoToReferences<CR>
  nnoremap <silent> <buffer> <LocalLeader>r :YcmCompleter RefactorRename<Space>
endfunction

autocmd FileType typescript call ftmappings#typescript#ycm_maps()
