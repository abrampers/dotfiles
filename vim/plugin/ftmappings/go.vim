" Mappings for vim-go
autocmd BufEnter **/*_test.go nnoremap <buffer> td :execute 'GoDebugTest' expand('%:p')<CR>
autocmd FileType go nnoremap <buffer> mb :GoDebugBreakpoint<CR>
autocmd FileType go nnoremap <silent> <buffer> <LocalLeader>r :GoRename<CR>
autocmd FileType go nnoremap <buffer> <Leader>c :GoDebugContinue<CR>

function! YCMGoMaps()
  nnoremap <silent> <buffer> gt :YcmCompleter GoToType<CR>
  nnoremap <silent> <buffer> gm :YcmCompleter GoToImplementation<CR>
  nnoremap <silent> <buffer> gd :YcmCompleter GoTo<CR>
  nnoremap <silent> <buffer> gr :YcmCompleter GoToReferences<CR>
  nnoremap <silent> <buffer> <LocalLeader>t :YcmCompleter GetType<CR>
endfunction

function! VimGoMaps()
  nnoremap <silent> <buffer> gt :GoDefType<CR>
  nnoremap <silent> <buffer> gd :GoDef<CR>
  nnoremap <silent> <buffer> gr :GoReferrers<CR>
  nnoremap <silent> <buffer> <LocalLeader>t :GoInfo<CR>
  nnoremap <silent> <buffer> gm :GoImplements<CR>
endfunction

autocmd FileType go call YCMGoMaps()
