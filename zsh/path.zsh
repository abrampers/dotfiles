SYSTEM_PATH=$PATH
unset PATH

# keep these on separate lines to make changing their order easier
PATH=$HOME/bin
PATH=$PATH:$HOME/.zsh/bin
PATH=$PATH:$HOME/.vim/pack/bundle/opt/vcs-jump/bin

test -n "$N_PREFIX" && PATH=$PATH:$N_PREFIX/bin

# Setup fzf
# ---------
if [[ ! "$PATH" == *$HOME/.fzf/bin* ]]; then
  PATH=${PATH:+${PATH}:}$HOME/.fzf/bin
fi

PATH=$PATH:/usr/local/bin
PATH=$PATH:/usr/local/sbin
PATH=$PATH:/usr/local/opt/srm/bin
PATH=$PATH:$SYSTEM_PATH
PATH=$PATH:$HOME/.local/bin

PATH=$PATH:/Library/Frameworks/Python.framework/Versions/3.6/bin
PATH=$PATH:/Library/Frameworks/Python.framework/Versions/2.7/bin

# Go related stuff
PATH=$PATH:$GOPATH/bin
PATH=$PATH:$HOME/.gvm/bin
PATH=$PATH:$HOME/.gvm/gos/go1.17.6/bin
PATH=$PATH:$HOME/.gvm/pkgsets/go1.17.6/global/overlay/bin


# Ruby related stuff
PATH=$PATH:$HOME/.rbenv/shims

export PATH=$PATH:$PYENV_ROOT/shims

export PATH
