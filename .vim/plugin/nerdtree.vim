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

" If any of the args are a directory, load NERDTree eagerly to prevent netrw
" from being used.
if len(filter(argv(), 'isdirectory(v:val)')) > 0
  call wincent#plugin#packadd('nerdtree', 'NERD_tree.vim')
  nnoremap <C-_> :NERDTreeFind<CR>
else
  call wincent#plugin#lazy({
        \   'pack': 'nerdtree',
        \   'plugin': 'NERD_tree.vim',
        \   'commands': {
        \     'NERDTree': '-n=? -complete=dir -bar',
        \     'NERDTreeCWD': '-n=0 -bar',
        \     'NERDTreeClose': '-n=0 -bar',
        \     'NERDTreeFind': '-n=0 -bar',
        \     'NERDTreeFocus': '-n=0 -bar',
        \     'NERDTreeFromBookmark': '-n=1 -bar',
        \     'NERDTreeMirror': '-n=0 -bar',
        \     'NERDTreeToggle': '-n=? -complete=dir -bar',
        \   },
        \   'nnoremap': {
        \     '<C-_>': ':NERDTreeFind<CR>'
        \   }
        \ })
endif

if exists('+colorcolumn')
  setlocal colorcolumn=
endif

if has('folding')
  setlocal nofoldenable
endif

setlocal nolist

" " Move up a directory using "-" like vim-vinegar (usually "u" does this).
" nmap <buffer> <expr> - g:NERDTreeMapUpdir

" NerdTree
nnoremap <C-n> :NERDTreeToggle<CR>
