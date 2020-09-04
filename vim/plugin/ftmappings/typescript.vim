autocmd FileType typescript nnoremap <buffer> gt :YcmCompleter GoToType<CR>
" go to i[m]plementation
autocmd FileType typescript nnoremap <buffer> gm :YcmCompleter GoToImplementation<CR>
" Mappings for YouCompleteMe
autocmd FileType typescript nnoremap <buffer> gd :YcmCompleter GoTo<CR>
" go to [r]eferences
autocmd FileType typescript nnoremap <buffer> gr :YcmCompleter GoToReferences<CR>
autocmd FileType typescript nnoremap <buffer> <LocalLeader>r :YcmCompleter RefactorRename<Space>
