# Editor
export EDITOR='nvim'

# GO
export GOPATH=$HOME/.gvm/pkgsets/go1.14.5/global

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"

# Kubernetes Editor
export KUBE_EDITOR="nvim"

# Locale
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# FZF
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"
export FZF_DEFAULT_OPTS="--layout=reverse --inline-info"

# GPG
export GPG_TTY=$(tty)

# Node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
