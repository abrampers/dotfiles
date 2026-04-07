" NERDTree syntax highlighting
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1

" Show hidden files
let g:NERDTreeShowHidden=1

" Ignore turds left behind by Mercurial.
let g:NERDTreeIgnore=['\.orig']

" The default of 31 is just a little too narrow.
let g:NERDTreeWinSize=40

" Disable display of '?' text and 'Bookmarks' label.
let g:NERDTreeMinimalUI=1

" Let <Leader><Leader> (^#) return from NERDTree window.
let g:NERDTreeCreatePrefix='silent keepalt keepjumps'

" Single-click to toggle directory nodes, double-click to open non-directory
" nodes.
let g:NERDTreeMouseMode=2

if has('autocmd')
  " Close NERDTree if the only window open is NERDTree
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

  augroup WincentNERDTree
    autocmd!
    autocmd User NERDTreeInit call wincent#autocmds#attempt_select_last_file()
  augroup END
endif

if exists('+colorcolumn')
  setlocal colorcolumn=
endif

if has('folding')
  setlocal nofoldenable
endif

setlocal nolist

" NerdTree
nnoremap <silent> <C-n> :NERDTreeToggle<CR>
nnoremap <silent> <C-_> :NERDTreeFind<CR>
