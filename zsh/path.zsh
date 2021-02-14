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
PATH=$PATH:$GOPATH/bin

export PATH
