#!/usr/bin/env bash

echo "Installing tools"
# GPG / Password stuff
sudo apt-get install pass gnupg gnupg-agent

# General file editing
sudo apt-get install vim vim-doc meld exuberant-ctags


echo "Backup the original files"
backup() {
    # backs up the file/folder the first time only
    file="$1"
    if [[ -f $file ]]; then
        mv $file "$file.old_`date +%Y_%m_%d_%H_%M_%S`"
    elif [[ -d $file ]]; then
        mv $file "$file.old_`date +%Y_%m_%d_%H_%M_%S`"
    fi
}

backup ~/.bash_aliases
backup ~/.gitconfig
backup ~/.gitignore
backup ~/.screenrc
backup ~/.vim
backup ~/.vimrc
backup ~/.tmux.conf

echo "Symlinking files:"
link() {
    from="$1"
    to="$2"
    echo "Linking '$from' to '$to'"
    rm -f "$to"
    ln -s "$from" "$to"
}

link ~/dotfiles/bash_aliases ~/.bash_aliases
link ~/dotfiles/gitconfig ~/.gitconfig
link ~/dotfiles/gitignore ~/.gitignore
link ~/dotfiles/screenrc ~/.screenrc
link ~/dotfiles/vim ~/.vim
link ~/dotfiles/vimrc ~/.vimrc
link ~/dotfiles/tmux.conf ~/.tmux.conf

echo "All done."
