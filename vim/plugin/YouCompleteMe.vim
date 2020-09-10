let g:ycm_key_list_select_completion = ['<C-j>', '<Down>', '<Tab>']
let g:ycm_key_list_previous_completion = ['<C-k>', '<Up>']
let g:ycm_key_list_stop_completion = ['<C-y>', '<CR>']

autocmd FileType c,cpp,objc,objcpp,cuda,java,javascript,go,python,typescript,rust let b:ycm_hover = {
    \ 'command': 'GetType',
    \ 'syntax': &filetype
    \ }

let g:ycm_language_server = [
  \   {
  \     'name': 'ruby',
  \     'cmdline': [ expand( $HOME . '/.rbenv/shims/solargraph' ), 'stdio' ],
  \     'filetypes': [ 'ruby' ],
  \   },
  \   {
  \     'name': 'vim',
  \     'filetypes': [ 'vim' ],
  \     'cmdline': [ expand( '/usr/local/bin/vim-language-server' ), '--stdio' ]
  \   },
  \ ]
