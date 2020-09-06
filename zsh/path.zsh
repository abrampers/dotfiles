SYSTEM_PATH=$PATH
unset PATH

# keep these on separate lines to make changing their order easier
PATH=$HOME/bin
PATH=$PATH:$HOME/.zsh/bin
PATH=$PATH:$HOME/.vim/pack/bundle/opt/vcs-jump/bin

test -n "$N_PREFIX" && PATH=$PATH:$N_PREFIX/bin

PATH=$PATH:$HOME/.cargo/bin

if [ -d /usr/local/opt/mysql@5.7 ]; then
  PATH=$PATH:/usr/local/opt/mysql@5.7/bin
fi

# Setup fzf
# ---------
if [[ ! "$PATH" == *$HOME/.fzf/bin* ]]; then
  PATH=${PATH:+${PATH}:}$HOME/.fzf/bin
fi

PATH=$PATH:/usr/local/bin
PATH=$PATH:/usr/local/sbin
PATH=$PATH:/usr/local/opt/srm/bin
PATH=$PATH:$SYSTEM_PATH
PATH=$PATH:$EC2_HOME/bin
PATH=$PATH:$HOME/.local/bin
PATH=$PATH:$HOME/.cabal/bin

PATH=$PATH:/Library/Frameworks/Python.framework/Versions/3.6/bin
PATH=$PATH:/Library/Frameworks/Python.framework/Versions/2.7/bin
PATH=$PATH:/usr/local/opt/rabbitmq/sbin
PATH=$PATH:/Users/abrampers/arcanist/bin/
PATH=$PATH:/usr/local/Cellar/vim/8.2.0050_1/bin/
PATH=$PATH:$M2
PATH=$PATH:$GOPATH/bin
PATH=$PATH:/usr/local/opt/ncurses/bin
PATH=$PATH:/usr/local/opt/sqlite/bin

export PATH
