#!/usr/bin/env bash

echo "Installing tools"
# GPG / Password stuff
sudo apt-get install pass gnupg gnupg-agent

# General file editing
sudo apt-get install vim vim-doc meld exuberant-ctags python-pip virtualenv

# VPN
sudo apt-get install openvpn

# Music
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update
sudo apt-get install spotify-client


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

# It seems the gnome keyring messes with the ssh-agent.  Uninstalling it helped
# with a linux mint 18 cinnamon install (after restarting)
# sudo apt-get autoremove gnome-keyring
if [ ! -d ~/.ssh ]; then
    mkdir ~/.ssh
    ssh-keygen -b 4096 -o -a 100 -t rsa
    ssh-add
fi
link ~/dotfiles/ssh_config ~/.ssh/config

echo "All done."
