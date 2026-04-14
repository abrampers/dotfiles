function! ftmappings#go#debug_maps()
  nnoremap <buffer> td :execute 'GoDebugTest' expand('%:p')<CR>
  nnoremap <buffer> mb :GoDebugBreakpoint<CR>
  nnoremap <buffer> <Leader>c :GoDebugContinue<CR>
endfunction

function! ftmappings#go#vim_go_maps()
  nnoremap <silent> <buffer> gy :GoDefType<CR>
  nnoremap <silent> <buffer> gi :GoImplements<CR>
  nnoremap <silent> <buffer> gd :GoDef<CR>
  nnoremap <silent> <buffer> gr :GoReferrers<CR>
  nnoremap <silent> <buffer> <LocalLeader>t :GoInfo<CR>
  nnoremap <silent> <buffer> ,r :GoRename<CR>
endfunction

autocmd FileType go call ftmappings#go#vim_go_maps()
autocmd FileType go call ftmappings#go#debug_maps()
autocmd FileType go call mappings#omnifunc#SetupMappings()
autocmd FileType go inoremap <buffer> . .<C-x><C-o>
