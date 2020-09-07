" Mappings for vim-go
autocmd BufEnter **/*_test.go nnoremap <buffer> td :execute 'GoDebugTest' expand('%:p')<CR>
" [m]ark [b]reakpoint
autocmd FileType go nnoremap <buffer> mb :GoDebugBreakpoint<CR>
" go to [t]ype
autocmd FileType go nnoremap <buffer> gt :YcmCompleter GoToType<CR>
" go to i[m]plementation
autocmd FileType go nnoremap <buffer> gm :YcmCompleter GoToImplementation<CR>
" Mappings for YouCompleteMe
autocmd FileType go nnoremap <buffer> gd :YcmCompleter GoTo<CR>
" go to [r]eferences
autocmd FileType go nnoremap <buffer> gr :YcmCompleter GoToReferences<CR>
" corresponds to check [t]ype
autocmd FileType go nnoremap <buffer> <LocalLeader>t :YcmCompleter GetType<CR>
autocmd FileType go nnoremap <buffer> <LocalLeader>r :GoRename<CR>
autocmd FileType go nnoremap <buffer> <Leader>c :GoDebugContinue<CR>
