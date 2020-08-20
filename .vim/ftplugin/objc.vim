setlocal shiftwidth=4
setlocal tabstop=4

" Mappings for YouCompleteMe
autocmd FileType objc,objcpp nnoremap <buffer> gd :YcmCompleter GoTo<CR>
" go to [r]eferences
autocmd FileType objc,objcpp nnoremap <buffer> gr :YcmCompleter GoToReferences<CR>

autocmd FileType objc,objcpp nnoremap <buffer> <LocalLeader>r :YcmCompleter RefactorRename 
