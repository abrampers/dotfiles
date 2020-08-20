" go to [t]ype
autocmd FileType javascript nnoremap <buffer> gt :YcmCompleter GoToType<CR>
" go to i[m]plementation
autocmd FileType javascript nnoremap <buffer> gm :YcmCompleter GoToImplementation<CR>
" Mappings for YouCompleteMe
autocmd FileType javascript nnoremap <buffer> gd :YcmCompleter GoTo<CR>
" go to [r]eferences
autocmd FileType javascript nnoremap <buffer> gr :YcmCompleter GoToReferences<CR>

autocmd FileType javascript nnoremap <buffer> <LocalLeader>r :YcmCompleter RefactorRename 
