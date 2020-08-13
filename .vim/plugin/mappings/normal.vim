" Normal mode mappings.

" Toggle fold at current position.
nnoremap = za

" Avoid unintentional switches to Ex mode.
nnoremap Q <nop>

" Multi-mode mappings (Normal, Visual, Operating-pending modes).
noremap Y y$

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Repurpose cursor keys (accessible near homerow via "SpaceFN" layout) for one
" of my most oft-use key sequences.
nnoremap <silent> <Up> :cprevious<CR>
nnoremap <silent> <Down> :cnext<CR>
nnoremap <silent> <Left> :cpfile<CR>
nnoremap <silent> <Right> :cnfile<CR>

nnoremap <silent> <S-Up> :lprevious<CR>
nnoremap <silent> <S-Down> :lnext<CR>
nnoremap <silent> <S-Left> :lpfile<CR>
nnoremap <silent> <S-Right> :lnfile<CR>

" Store relative line number jumps in the jumplist if they exceed a threshold.
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : '') . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : '') . 'j'

" NerdTree
nnoremap <C-n> :NERDTreeToggle<CR>

" Dispatch
nnoremap <C-c> :AbortDispatch<CR>

" Mappings for YouCompleteMe
autocmd FileType c,cpp,objc,objcpp,cuda,cs,go,java,javascript,python,rust,typescript nnoremap <buffer> gd :YcmCompleter GoTo<CR>
" go to [r]eferences
autocmd FileType c,cpp,objc,objcpp,cuda,go,java,javascript,python,typescript,rust nnoremap <buffer> gr :YcmCompleter GoToReferences<CR>
autocmd FileType go nnoremap <buffer> gr :GoReferrers<CR>
" go to i[m]plementation
autocmd FileType cs,go,java,rust,typescript,javascript nnoremap <buffer> gm :YcmCompleter GoToImplementation<CR>
" go to [t]ype
autocmd FileType go,java,typescript,javascript nnoremap <buffer> gt :YcmCompleter GoToType<CR>

" Mappings for vim-go
autocmd FileType go nnoremap <buffer> tT :GoTest<CR>
autocmd BufEnter **/*_test.go nnoremap <buffer> tt :GoTestFunc<CR>
autocmd BufEnter **/*_test.go nnoremap <buffer> td :execute 'GoDebugTest' expand('%:p')<CR>
" [m]ark [b]reakpoint
autocmd FileType go nnoremap <buffer> mb :GoDebugBreakpoint<CR>
