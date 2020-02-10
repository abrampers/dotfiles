set nocompatible " Set compatibility to Vim only.

filetype off " Helps force plug-ins to load correctly when it is turned back on below.

syntax on " Turn on syntax highlighting.

filetype plugin indent on " For plug-ins to load correctly.

set modelines=0 " Turn off modelines

set wrap " Automatic     wrap text that extends beyond the screen length.

" Vim's auto indentation feature does not work properly with text copied from outside of Vim. Press the <F2> key to toggle paste mode on/off.
nnoremap <F2> :set invpaste paste?<CR>
imap <F2> <C-O>:set invpaste paste?<CR>
set pastetoggle=<F2>

set formatoptions=tcqrn1
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set noshiftround
set scrolloff=5 " Display 5 lines above/below the cursor when scrolling with a mouse.
set backspace=indent,eol,start " Fixes common backspace problems
set ttyfast " Speed up scrolling in Vim
set laststatus=2 " Status bar

" Display options
set showmode
set showcmd

" Menu tab options
set wildmode=longest,full
set wildmenu

set matchpairs+=<:> " Highlight matching pairs of brackets. Use the '%' character to jump between them.

" Display different types of white spaces.
set list
set listchars=tab:›\ ,trail:•,extends:#,nbsp:.

set number " Show line numbers
set encoding=utf-8 " Encoding
set hlsearch " Highlight matching search patterns
set incsearch " Enable incremental search
set ignorecase " Include matching uppercase words with lowercase search term
set smartcase " Include only uppercase words with uppercase search term
set viminfo='100,<9999,s100 " Store info from no more than 100 files at a time, 9999 lines of text, 100kb of data. Useful for copying large amounts of data between files.

" Timeout settings (to timeout the key codes)
set ttimeout
set ttimeoutlen=100
set timeoutlen=3000

" Change cursor to line in insert mode
" TODO: Configure to tmux if tmux is used
if $TERM_PROGRAM =~ "iTerm"
    let &t_SI = "\<Esc>]50;CursorShape=1\x7" " Vertical bar in insert mode
    let &t_SR = "\<Esc>]50;CursorShape=2\x7" " Underscore in replace mode
    let &t_EI = "\<Esc>]50;CursorShape=0\x7" " Block in normal mode
endif

" Highlight line in insert mode
autocmd InsertEnter,InsertLeave * set cul!

" Set starting foldlevel to 1
set foldlevelstart=1

" Map the <Space> key to toggle a selected fold opened/closed.
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

" [KEY MAPPINGS]
" Ctrl+n to toggle NERDTree
map <C-n> :NERDTreeToggle<CR>

" Split movement
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Automatically save and load folds
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview"


" [vimrc]
" Call the .vimrc.plug file
if filereadable(expand("~/.vimrc.plug"))
    source ~/.vimrc.plug
endif


" [Colorscheme setup]
" Seti colorscheme
colorscheme seti
hi NonText ctermbg=NONE


" [NERDTree]
" Close NERDTree if the only window open is NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

let g:NERDTreeShowHidden = 1

" NERDTree syntax highlighting
" [vim-nerdtree-syntax-highlight]
" Mitigating lag issues
let g:NERDTreeLimitedSyntax = 1

" [vim-cpp-enchanced-highlight setup]
" Highlighting class scope
let g:cpp_class_scope_highlight = 1

" Hightighting member variables
let g:cpp_member_variable_highlight = 1

" Highlighting class names
let g:cpp_class_decl_highlight = 1


" [airline setup]
" Enable powerline fonts
let g:airline_powerline_fonts = 1

" Enable airline tab bar
let g:airline#extensions#tabline#enabled = 1

" Set airline theme
let g:airline_theme='deus'

" [ctrlp vim]
" Enable hidden files
let g:ctrlp_show_hidden = 1


" [devicons]
" adding to vim-airline's tabline
let g:webdevicons_enable_airline_tabline = 1
" adding to vim-airline's statusline
let g:webdevicons_enable_airline_statusline = 1
" ctrlp glyphs
let g:webdevicons_enable_ctrlp = 1