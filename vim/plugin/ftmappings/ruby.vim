autocmd FileType ruby nnoremap <buffer> tT :Rake spec<CR>
autocmd BufEnter */*_spec.rb nnoremap <buffer> tt :Rake<CR>
