function! ftmappings#go#debug_maps()
  nnoremap <buffer> td :execute 'GoDebugTest' expand('%:p')<CR>
  nnoremap <buffer> mb :GoDebugBreakpoint<CR>
  nnoremap <buffer> <Leader>c :GoDebugContinue<CR>
endfunction

function! ftmappings#go#ycm_maps()
  nnoremap <silent> <buffer> gt :YcmCompleter GoToType<CR>
  nnoremap <silent> <buffer> gm :YcmCompleter GoToImplementation<CR>
  nnoremap <silent> <buffer> gd :YcmCompleter GoTo<CR>
  nnoremap <silent> <buffer> gr :YcmCompleter GoToReferences<CR>
  nnoremap <buffer> <LocalLeader>r :YcmCompleter RefactorRename<Space>
  nnoremap <silent> <buffer> <LocalLeader>t :YcmCompleter GetType<CR>
endfunction

function! ftmappings#go#vim_go_maps()
  nnoremap <silent> <buffer> gt :GoDefType<CR>
  nnoremap <silent> <buffer> gd :GoDef<CR>
  nnoremap <silent> <buffer> gr :GoReferrers<CR>
  nnoremap <silent> <buffer> <LocalLeader>t :GoInfo<CR>
  nnoremap <silent> <buffer> gm :GoImplements<CR>
endfunction

autocmd FileType go call ftmappings#go#ycm_maps()
autocmd FileType go call ftmappings#go#debug_maps()
