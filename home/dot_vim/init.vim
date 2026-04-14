if v:progname == 'vi'
  set noloadplugins
endif

let mapleader=" "
let maplocalleader=","

if has('nvim')
  let g:python3_host_prog = $HOME . '/.pyenv/shims/python3'
  let g:ruby_host_prog = $HOME . '/.rbenv/versions/2.7.1/bin/neovim-ruby-host'
endif

let g:ruby_path = $HOME . '/.rbenv/versions/2.7.1/bin/neovim-ruby-host'

" Extension -> filetype mappings.
let filetype_m='objc'
let filetype_pl='prolog'

" Stark highlighting is enough to see the current match; don't need the
" centering, which can be annoying.
let g:LoupeCenterResults=0

" Would be useful mappings, but they interfere with my default window movement
" bindings (<C-j> and <C-k>).
let g:NERDTreeMapJumpPrevSibling='<Nop>'
let g:NERDTreeMapJumpNextSibling='<Nop>'

let g:NERDTreeCaseSensitiveSort=1

" Turn off most of the features of this plug-in; I really just want the folding.
let g:vim_markdown_override_foldtext=0
let g:vim_markdown_no_default_key_mappings=1
let g:vim_markdown_emphasis_multiline=0
let g:vim_markdown_conceal=0
let g:vim_markdown_frontmatter=1
let g:vim_markdown_new_list_item_indent=0

let s:vimrc_local=$HOME . '/.vim/vimrc.local'
if filereadable(s:vimrc_local)
  execute 'source ' . s:vimrc_local
endif

if has('gui')
  " Turn off scrollbars. (Default on macOS is "egmrL").
  set guioptions-=L
  set guioptions-=R
  set guioptions-=b
  set guioptions-=l
  set guioptions-=r
endif

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-rbenv', { 'for': 'ruby' }

Plug 'vim-scripts/argtextobj.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'chriskempson/base16-vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'shumphrey/fugitive-gitlab.vim'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'
Plug 'junegunn/goyo.vim'
Plug 'morhetz/gruvbox'
Plug 'Yggdroot/indentLine'
Plug 'wincent/loupe'
if len(filter(argv(), 'isdirectory(v:val)')) > 0
  Plug 'preservim/nerdtree'
else
  Plug 'preservim/nerdtree', { 'on': ['NERDTree', 'NERDTreeCWD', 'NERDTreeClose', 'NERDTreeFind', 'NERDTreeFocus', 'NERDTreeFromBookmark', 'NERDTreeMirror', 'NERDTreeToggle'] }
  Plug 'Xuyuanp/nerdtree-git-plugin', { 'on': ['NERDTree', 'NERDTreeCWD', 'NERDTreeClose', 'NERDTreeFind', 'NERDTreeFocus', 'NERDTreeFromBookmark', 'NERDTreeMirror', 'NERDTreeToggle'] }
endif
Plug 'arcticicestudio/nord-vim'
Plug 'wincent/pinnacle'
Plug 'wincent/replay'
Plug 'wincent/scalpel'
Plug 'wincent/terminus'
Plug 'mbbill/undotree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-bundler', { 'for': 'ruby' }
Plug 'wincent/vim-clipper'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch'
Plug 'wincent/vim-docvim'
Plug 'duggiefresh/vim-easydir'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'fatih/vim-go', { 'for': [ 'go', 'gomod' ], 'do': ':GoUpdateBinaries' }
Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }
Plug 'elzr/vim-json', { 'for': 'json' }
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'tpope/vim-projectionist'
Plug 'tpope/vim-rails', { 'for': 'ruby' }
Plug 'tpope/vim-rake', { 'for': 'ruby' }
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'
Plug 'airblade/vim-rooter'
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
Plug 'kshenoy/vim-signature'
Plug 'tpope/vim-surround'
Plug 'vim-test/vim-test', { 'on': ['TestNearest', 'TestFile', 'TestSuite', 'TestLast', 'TestVisit'] }
Plug 'thinca/vim-textobj-comment'
Plug 'nelstrom/vim-textobj-rubyblock', { 'for': 'ruby' }
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-user'
Plug 'chrisbra/vim-zsh'

" Protocol buffers support
Plug 'uarun/vim-protobuf', { 'for': 'proto' }
Plug 'dense-analysis/ale'
Plug 'bufbuild/vim-buf'
call plug#end()

filetype indent plugin on
syntax on

" After this file is sourced, plugin code will be evaluated.
" See ~/.vim/after for files evaluated after that.
" See `:scriptnames` for a list of all scripts, in evaluation order.
" Launch Vim with `vim --startuptime vim.log` for profiling info.
"
" To see all leader mappings, including those from plugins:
"
"   vim -c 'set t_te=' -c 'set t_ti=' -c 'map <space>' -c q | sort
"
