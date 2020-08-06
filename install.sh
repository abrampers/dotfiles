#!/bin/bash

# TODO: Create script
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

# .zsh
if [ -L "$HOME/.zsh" ]; then
    unlink $HOME/.zsh
fi
ln -s $SCRIPTPATH/.zsh $HOME/.zsh

# .zshrc
if [ -L "$HOME/.zshrc" ]; then
    unlink $HOME/.zshrc
fi
ln -s $SCRIPTPATH/.zshrc $HOME/.zshrc

# .zshenv
if [ -L "$HOME/.zshenv" ]; then
    unlink $HOME/.zshenv
fi
ln -s $SCRIPTPATH/.zshenv $HOME/.zshenv

# .vim
if [ -L "$HOME/.vim" ]; then
    unlink $HOME/.vim
fi
ln -s $SCRIPTPATH/.vim $HOME/.vim

# .config/nvim/init.vim
if [ -L "$HOME/.config/nvim/init.vim" ]; then
    unlink $HOME/.config/nvim/init.vim
fi
mkdir -p .config/nvim/
ln -s $SCRIPTPATH/.config/nvim/init.vim $HOME/.config/nvim/init.vim

# .tmux.conf
if [ -L "$HOME/.tmux.conf" ]; then
    unlink $HOME/.tmux.conf
fi
ln -s $SCRIPTPATH/.tmux.conf $HOME/.tmux.conf

# .condarc
if [ -L "$HOME/.condarc" ]; then
    unlink $HOME/.condarc
fi
ln -s $SCRIPTPATH/.condarc $HOME/.condarc
