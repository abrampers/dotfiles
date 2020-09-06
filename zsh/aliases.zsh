# Unix
alias tlf="tail -f"
alias ln='ln -v'
alias mkdir='mkdir -p'
alias ...='../..'
alias -g G='| grep'
alias -g M='| less'
alias -g ONE="| awk '{ print \$1}'"
alias e="$EDITOR"
alias v="$VISUAL"
# because typing is hard
alias ls='ls -G'
alias grep='grep --color'

alias cat='bat'

# Vim
alias vim="$(brew --prefix)/bin/vim"
alias :w="echo this isn\'t vim 🌟"
alias :q='exit'

# ctags
alias ctags="$(brew --prefix)/bin/ctags"

# Aliases for gcc
alias gcc='gcc-8'
alias cc='gcc-8'
alias g++='g++-8'
alias c++='g++-8'