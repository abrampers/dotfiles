if exists('+colorcolumn')
  setlocal colorcolumn=
endif

if has('folding')
  setlocal nofoldenable
endif

setlocal nolist

" Move up a directory using "-" like vim-vinegar (usually "u" does this).
nmap <buffer> <expr> - g:NERDTreeMapUpdir

" Open NERDTree every vim startup
autocmd vimenter * NERDTree

" Open NERDTree even if no files were specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && v:this_session == "" && !exists("s:std_in") | NERDTree | endif

" Open NERDTree when vim starts up on opening a directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif

" Close NERDTree if the only window open is NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
