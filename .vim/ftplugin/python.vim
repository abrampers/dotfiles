if has('nvim')
  let g:python3_host_prog = '/usr/local/bin/python3'
endif

" Mappings for YouCompleteMe
autocmd FileType python nnoremap <buffer> gd :YcmCompleter GoTo<CR>
" go to [r]eferences
autocmd FileType python nnoremap <buffer> gr :YcmCompleter GoToReferences<CR>
