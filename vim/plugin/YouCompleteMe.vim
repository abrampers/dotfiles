let g:ycm_key_list_select_completion = ['<C-j>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-k>', '<Up>']
let g:ycm_key_list_accept_completion = ['<C-y>']

autocmd FileType c,cpp,objc,objcpp,cuda,java,javascript,go,python,typescript,rust let b:ycm_hover = {
    \ 'command': 'GetType',
    \ 'syntax': &filetype
    \ }
