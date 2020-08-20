" Mappings for YouCompleteMe
autocmd FileType c,cpp nnoremap <buffer> gd :YcmCompleter GoTo<CR>
" go to [r]eferences
autocmd FileType c,cpp nnoremap <buffer> gr :YcmCompleter GoToReferences<CR>

autocmd FileType c,cpp nnoremap <buffer> <LocalLeader>r :YcmCompleter RefactorRename 
