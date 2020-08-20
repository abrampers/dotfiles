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

# nvim
if [ -L "$HOME/.config/nvim" ]; then
    unlink $HOME/.config/nvim
fi
ln -s $SCRIPTPATH/.vim $HOME/.config/nvim

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

# .fzf
if [ -L "$HOME/.fzf" ]; then
    unlink $HOME/.fzf
fi
ln -s $SCRIPTPATH/.fzf $HOME/.fzf

# bat
if [ -L "$HOME/.config/bat" ]; then
    unlink $HOME/.config/bat
fi
ln -s $SCRIPTPATH/.config/bat $HOME/.config/bat
