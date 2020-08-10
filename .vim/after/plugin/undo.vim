" Undo
if has('persistent_undo')
  silent !mkdir ~/.vim/undo > /dev/null 2>&1
  set undodir=~/.vim/undo " where to save undo histories
  set undofile                " Save undos after file closes
  set undolevels=1000         " How many undos
  set undoreload=10000        " number of lines to save for undo
endif
