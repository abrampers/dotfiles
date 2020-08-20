" go to [t]ype
autocmd FileType java nnoremap <buffer> gt :YcmCompleter GoToType<CR>
" go to i[m]plementation
autocmd FileType java nnoremap <buffer> gm :YcmCompleter GoToImplementation<CR>
" Mappings for YouCompleteMe
autocmd FileType java nnoremap <buffer> gd :YcmCompleter GoTo<CR>
" go to [r]eferences
autocmd FileType java nnoremap <buffer> gr :YcmCompleter GoToReferences<CR>

autocmd FileType java nnoremap <buffer> <LocalLeader>r :YcmCompleter RefactorRename 
