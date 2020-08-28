let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6, 'border': 'rounded' } }

" Rg flags
command! -bang -nargs=* Rg call 
  \ fzf#vim#grep(
  \   'rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --follow --glob ".gitignore" --glob ".zshrc" --color "always" '.shellescape(<q-args>), 1, <bang>0)

nnoremap <leader>f :Rg<CR>
nnoremap <C-p> :Files<CR>
nnoremap <leader>l :Lines<CR>
