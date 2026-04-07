func! mappings#omnifunc#SetupMappings()
  inoremap <buffer> <expr> <CR>  pumvisible() ? "\<C-y>" : "\<CR>"
  inoremap <buffer> <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
  inoremap <buffer> <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"
  inoremap <buffer> <expr> <C-d> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<C-d>"
  inoremap <buffer> <expr> <C-u> pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<C-u>"
endfunction
