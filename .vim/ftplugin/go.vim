setlocal noexpandtab
setlocal shiftwidth=4
setlocal tabstop=4

" vim-go
let g:go_auto_type_info = 1
let g:go_fmt_command = "goimports"

let g:go_debug_windows = {
      \ 'vars':       'rightbelow 60vnew',
      \ 'stack':      'rightbelow 10new',
\ }

" Mappings for vim-go
autocmd FileType go nnoremap <buffer> tT :GoTest<CR>
autocmd BufEnter */*_test.go nnoremap <buffer> tt :GoTestFunc<CR>
autocmd BufEnter **/*_test.go nnoremap <buffer> td :execute 'GoDebugTest' expand('%:p')<CR>
" [m]ark [b]reakpoint
autocmd FileType go nnoremap <buffer> mb :GoDebugBreakpoint<CR>
" go to [t]ype
autocmd FileType go nnoremap <buffer> gt :YcmCompleter GoToType<CR>
" go to i[m]plementation
autocmd FileType go nnoremap <buffer> gm :YcmCompleter GoToImplementation<CR>
autocmd FileType go nnoremap <buffer> gr :GoReferrers<CR>
" Mappings for YouCompleteMe
autocmd FileType go nnoremap <buffer> gd :YcmCompleter GoTo<CR>
" go to [r]eferences
autocmd FileType go nnoremap <buffer> gr :YcmCompleter GoToReferences<CR>
" Mappings for vim-go
autocmd FileType go nnoremap <buffer> <LocalLeader>a :GoAlternate<CR>
" corresponds to check [t]ype
autocmd FileType go nnoremap <buffer> <LocalLeader>t :YcmCompleter GetType<CR>
autocmd FileType go nnoremap <buffer> <LocalLeader>r :GoRename<CR>
autocmd FileType go nnoremap <buffer> <Leader>c :GoDebugContinue<CR>
