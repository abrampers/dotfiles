autocmd FileType ruby nnoremap <buffer> tT :Rake spec<CR>
autocmd BufEnter */*_spec.rb nnoremap <buffer> tt :Rake<CR>
autocmd FileType ruby call mappings#coc#SetupMappings()
autocmd FileType ruby call mappings#omnifunc#SetupMappings()
autocmd FileType ruby inoremap <buffer> "." .<C-x><C-o>
autocmd FileType ruby inoremap <buffer> "::" .<C-x><C-o>

