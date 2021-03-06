" Leader mappings.

" <Leader><Leader> -- Open last buffer.
nnoremap <Leader><Leader> <C-^>

nnoremap <Leader>o :only<CR>

" <Leader>p -- Show the path of the current file (mnemonic: path; useful when
" you have a lot of splits and the status line gets truncated).
nnoremap <Leader>p :echo expand('%')<CR>

" <Leader>pp -- Like <Leader>p, but additionally yanks the filename and sends it
" off to Clipper.
nnoremap <Leader>pp :let @0=expand('%') <Bar> :Clip<CR> :echo expand('%')<CR>

" re source vimrc
if has("nvim")
  nnoremap <Leader><CR> :so ~/.config/nvim/init.vim<CR>
else
  nnoremap <Leader><CR> :so ~/.vim/vimrc<CR>
endif

nnoremap <Leader>q :qa<CR>
nnoremap <LocalLeader>q :quit<CR>

" <Leader>1 -- Cycle through relativenumber + number, number (only), and no
" numbering (mnemonic: relative).
nnoremap <silent> <Leader># :call wincent#mappings#leader#cycle_numbering()<CR>

nnoremap <LocalLeader>w :write<CR>
nnoremap <Leader>x :xit<CR>

" <Leader>zz -- Zap trailing whitespace in the current buffer.
"
"        As this one is somewhat destructive and relatively close to the
"        oft-used <leader>a mapping, make this one a double key-stroke.
nnoremap <silent> <Leader>zz :call wincent#mappings#leader#zap()<CR>

" <LocalLeader>c -- Fix (most) syntax highlighting problems in current buffer
" (mnemonic: coloring).
nnoremap <silent> <LocalLeader>c :syntax sync fromstart<CR>

" <LocalLeader>d... -- Diff mode bindings:
" - <LocalLeader>dd: show diff view (mnemonic: [d]iff)
" - <LocalLeader>dh: choose hunk from left (mnemonic: [h] = left)
" - <LocalLeader>dl: choose hunk from right (mnemonic: [l] = right)
nnoremap <silent> <Leader>dd :Gvdiff<CR>
nnoremap <silent> <Leader>dh :diffget //2<CR>
nnoremap <silent> <Leader>dl :diffget //3<CR>
nnoremap <silent> <Leader>dp :diffput 1<CR>

" <LocalLeader>e -- Edit file, starting in same directory as current file.
nnoremap <LocalLeader>e :edit <C-R>=expand('%:p:h') . '/'<CR>


" <LocalLeader>p -- [P]rint the syntax highlighting group(s) that apply at the
" current cursor position.
"
" Taken from: http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
nnoremap <LocalLeader>p :echo 'hi<' . synIDattr(synID(line('.'),col('.'),1),'name') . '> trans<'
\ . synIDattr(synID(line('.'),col('.'),0),'name') . '> lo<'
\ . synIDattr(synIDtrans(synID(line('.'),col('.'),1)),'name') . '>'<CR>

" <LocalLeader>x -- Turn references to the word under the cursor to references
" to the WORD under the cursor:
"
" eg. if the cursor is on the first "w":
"
"     [@wincent](https://github.com/wincent)
"
" Can be used to turn all references to "wincent" into links to "@wincent".
"
" (mnemonic: e[X]tract handle)
nnoremap <LocalLeader>x :%s#\v<C-r><c-w>#<C-r><C-a>#gc<CR>

" Stop annoying paren match highlighting from flashing all over the screen,
" or start it.
"
" (mnemonic: [m]atch paren)
nnoremap <silent> <Leader>m :call wincent#mappings#leader#matchparen()<CR>

" Mappings to access buffers (don't use "\p" because a
" delay before pressing "p" would accidentally paste).
" \l       : list buffers
" \b \f \g : go back/forward/last-used
" \1 \2 \3 : go to buffer 1/2/3 etc
nnoremap <LocalLeader>l :ls<CR>
nnoremap <LocalLeader>b :bp<CR>
nnoremap <LocalLeader>f :bn<CR>
nnoremap <LocalLeader>v :e#<CR>
nnoremap <LocalLeader>1 :1b<CR>
nnoremap <LocalLeader>2 :2b<CR>
nnoremap <LocalLeader>3 :3b<CR>
nnoremap <LocalLeader>4 :4b<CR>
nnoremap <LocalLeader>5 :5b<CR>
nnoremap <LocalLeader>6 :6b<CR>
nnoremap <LocalLeader>7 :7b<CR>
nnoremap <LocalLeader>8 :8b<CR>
nnoremap <LocalLeader>9 :9b<CR>
nnoremap <LocalLeader>0 :10b<CR>

" Mappings for projectionist
nnoremap <LocalLeader>a :A<CR>

" Window resizing
nnoremap <silent> <Leader>+ :resize +10<CR>
nnoremap <silent> <Leader>- :resize -10<CR>
