setlocal shiftwidth=2
setlocal smartindent
setlocal tabstop=2

if has('nvim')
  let g:ruby_host_prog = '~/.rbenv/versions/2.7.1/bin/neovim-ruby-host'
endif

let g:rails_ctags_arguments = ['--languages=ruby --exclude=.git --exclude=log . $(bundle list --paths)']
