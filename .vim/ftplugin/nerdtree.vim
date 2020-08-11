if exists('+colorcolumn')
  setlocal colorcolumn=
endif

if has('folding')
  setlocal nofoldenable
endif

setlocal nolist

" Move up a directory using "-" like vim-vinegar (usually "u" does this).
nmap <buffer> <expr> - g:NERDTreeMapUpdir

" Close NERDTree if the only window open is NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
