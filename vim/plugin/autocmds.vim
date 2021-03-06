" if has('autocmd')
"   function! s:WincentAutocmds()
"     augroup WincentAutocmds
"       autocmd!
"
"       autocmd VimResized * execute "normal! \<c-w>="
"
"       " http://vim.wikia.com/wiki/Detect_window_creation_with_WinEnter
"       autocmd VimEnter * autocmd WinEnter * let w:created=1
"       autocmd VimEnter * let w:created=1
"
"       " Disable paste mode on leaving insert mode.
"       autocmd InsertLeave * set nopaste
"
"       " Make current window more obvious by turning off/adjusting some features in non-current
"       " windows.
"       if exists('+winhighlight')
"         autocmd BufEnter,FocusGained,VimEnter,WinEnter * set winhighlight=
"         autocmd FocusLost,WinLeave * set winhighlight=CursorLineNr:LineNr,EndOfBuffer:ColorColumn,IncSearch:ColorColumn,Normal:ColorColumn,NormalNC:ColorColumn,SignColumn:ColorColumn
"         if exists('+colorcolumn')
"           autocmd BufEnter,FocusGained,VimEnter,WinEnter * if wincent#autocmds#should_colorcolumn() | let &l:colorcolumn='+' . join(range(0, 254), ',+') | endif
"         endif
"       elseif exists('+colorcolumn')
"         autocmd BufEnter,FocusGained,VimEnter,WinEnter * if wincent#autocmds#should_colorcolumn() | let &l:colorcolumn='+' . join(range(0, 254), ',+') | endif
"         autocmd FocusLost,WinLeave * if wincent#autocmds#should_colorcolumn() | let &l:colorcolumn=join(range(1, 255), ',') | endif
"       endif
"       autocmd InsertLeave,VimEnter,WinEnter * if wincent#autocmds#should_cursorline() | setlocal cursorline | endif
"       autocmd InsertEnter,WinLeave * if wincent#autocmds#should_cursorline() | setlocal nocursorline | endif
"       if has('statusline')
"         " TODO: move this into statusline.vim? or move autocmd stuff in statusline.vim
"         " here?
"         autocmd BufEnter,FocusGained,VimEnter,WinEnter * call wincent#autocmds#focus_statusline()
"         autocmd FocusLost,WinLeave * call wincent#autocmds#blur_statusline()
"       endif
"       autocmd BufEnter,FocusGained,VimEnter,WinEnter * call wincent#autocmds#focus_window()
"       autocmd FocusLost,WinLeave * call wincent#autocmds#blur_window()
"
"       if has('mksession')
"         " Save/restore folds and cursor position.
"         autocmd BufWritePost,BufLeave,WinLeave ?* if wincent#autocmds#should_mkview() | call wincent#autocmds#mkview() | endif
"         if has('folding')
"           autocmd BufWinEnter ?* if wincent#autocmds#should_mkview() | silent! loadview | execute 'silent! ' . line('.') . 'foldopen!' | endif
"         else
"           autocmd BufWinEnter ?* if wincent#autocmds#should_mkview() | silent! loadview | endif
"         endif
"       elseif has('folding')
"         " Like the autocmd described in `:h last-position-jump` but we add `:foldopen!`.
"         autocmd BufWinEnter * if line("'\"") > 1 && line("'\"") <= line('$') | execute "normal! g`\"" | execute 'silent! ' . line("'\"") . 'foldopen!' | endif
"       else
"         autocmd BufWinEnter * if line("'\"") > 1 && line("'\"") <= line('$') | execute "normal! g`\"" | endif
"       endif
"
"       autocmd BufWritePost */spell/*.add silent! :mkspell! %
"
"       autocmd BufWritePost * call wincent#autocmds#encrypt(expand('<afile>:p'))
"
"       " Beware, if no path yet, <aname> will be the filetype (eg. `javascript`).
"       " When we later expand it with ":p", that will make it look like a
"       " file (eg. "javascript") in the current directory. Fortunately, this
"       " serves our purposes adequately.
"       " autocmd FileType * call wincent#autocmds#apply_overrides(expand('<afile>'), expand('<amatch>'))
"     augroup END
"   endfunction
"
"   call s:WincentAutocmds()
"
"   " Wait until idle to run additional "boot" commands.
"   augroup WincentIdleboot
"     autocmd!
"     if has('vim_starting')
"       autocmd CursorHold,CursorHoldI * call wincent#autocmds#idleboot()
"     endif
"   augroup END
" endif
