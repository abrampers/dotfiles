" go to i[m]plementation
autocmd FileType rust nnoremap <buffer> gm :YcmCompleter GoToImplementation<CR>
" Mappings for YouCompleteMe
autocmd FileType rust nnoremap <buffer> gd :YcmCompleter GoTo<CR>
" go to [r]eferences
autocmd FileType rust nnoremap <buffer> gr :YcmCompleter GoToReferences<CR>

autocmd FileType rust nnoremap <buffer> <LocalLeader>r :YcmCompleter RefactorRename<Space>
