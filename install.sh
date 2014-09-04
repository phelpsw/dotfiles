#!/usr/bin/env bash

echo "Backup the original files"
backup() {
    # backs up the file/folder the first time only
    file="$1"
    if [[ -f $file ]]; then
        if [[ ! -f "$file.old" ]]; then
            mv $file "$file.old"
        fi
    elif [[ -d $file ]]; then
        if [[ ! -d "$file.old" ]]; then
            mv $file "$file.old"
        fi
    fi
}

backup ~/.bashrc
backup ~/.gitconfig
backup ~/.gitignore
backup ~/.screenrc
backup ~/.vim
backup ~/.vimrc

echo "Symlinking files:"
link() {
    from="$1"
    to="$2"
    echo "Linking '$from' to '$to'"
    rm -f "$to"
    ln -s "$from" "$to"
}

link ~/dotfiles/bashrc ~/.bashrc
link ~/dotfiles/gitconfig ~/.gitconfig
link ~/dotfiles/gitignore ~/.gitignore
link ~/dotfiles/screenrc ~/.screenrc
link ~/dotfiles/vim ~/.vim
link ~/dotfiles/vimrc ~/.vimrc

echo "All done."
