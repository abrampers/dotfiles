autocmd FileType ruby nnoremap <buffer> tT :Rake spec<CR>
autocmd BufEnter */*_spec.rb nnoremap <buffer> tt :Rake<CR>

function! ftmappings#ruby#ycm_maps()
  nnoremap <silent> <buffer> gd :YcmCompleter GoTo<CR>
  nnoremap <silent> <buffer> gr :YcmCompleter GoToReferences<CR>
endfunction

autocmd FileType ruby call ftmappings#ruby#ycm_maps()
