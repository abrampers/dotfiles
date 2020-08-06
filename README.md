# My Terminal Cheatsheet

![Terminal](assets/tmux.png "Terminal") ![Vim](assets/vim.png "Vim")

## What's included
### zsh
* autodotenv
* base16-shell
* color
* git-aliases
* plugin-osx
* zsh-autosuggestions
* zsh-history-substring-search
* zsh-syntax-highlighting

### Vim
Includes:
* NerdTree
* vim-airline
* vim-pathogen
* YouCompleteMe

For keybindings cheatsheet, go [here](vim-cheatsheet.md)

### tmux
With everything it includes. For keybindings cheatsheet, go [here](tmux-cheatsheet.md)

## Prerequisites
1. [Homebrew](https://brew.sh)
2. [miniconda](https://docs.conda.io/en/latest/miniconda.html)

## Build Instructions
### Clone
```sh-session
git clone --recursive https://github.com/abrampers/dotfiles
```

### Install symlink
```sh-session
./install.sh
```

### Install Neovim
```sh-session
brew install neovim
conda env create -f env/neovim.yml
```

### Setup YouCompleteMe
```sh-session
brew install cmake go mono nodejs
cd ~/.vim/pack/bundle/opt/YouCompleteMe/
python install.py --all
```

### Install tmux
```sh-session
brew install tmux
```

### Restart terminal
Don't forget to restart your terminal to apply changes!

## Update Packages
```sh-session
git submodule update --remote --recursive
```

## References
This setup is my modification of [Greg Hurell](https://github.com/wincent)'s dotfiles setup. Check it out [here](https://github.com/wincent/wincent)
