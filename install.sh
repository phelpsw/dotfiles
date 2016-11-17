#!/usr/bin/env bash

echo "Installing tools"
# GPG / Password stuff
sudo apt-get install pass gnupg gnupg-agent

# General file editing
sudo apt-get install vim vim-doc meld exuberant-ctags python-pip virtualenv \
    screen tmux ipython cmake build-essential python-dev python3-dev golang \
    flake8 pylint pylint3
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# AWS
pip install docopt paramiko
sudo apt-get install awscli

# VPN
sudo apt-get install openvpn

# Other
# Weechat: https://github.com/rawdigits/wee-slack
sudo apt-get install weechat weechat-plugins
pip install setuptools wheel
pip install websocket-client

mkdir -p ~/.weechat/python/autoload/
wget -O ~/.weechat/python/autoload/wee_slack.py \
    https://raw.githubusercontent.com/rawdigits/wee-slack/master/wee_slack.py

# Music
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys BBEBDCB318AD50EC6865090613B00F1FD2C19886
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update
sudo apt-get install spotify-client


# Netflix
sudo sh -c 'echo "deb http://artifacts.netflix.com/debian-local nflx main" >> /etc/apt/sources.list.d/netflix.list'
sudo apt-get update
sudo apt-get --allow-unauthenticated install metatron-cli
sudo sed -i 's/deb http/#deb http/g' /etc/apt/sources.list.d/netflix.list
sudo apt-get update
metatron refresh

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
link ~/dotfiles/vimrc ~/.vimrc
link ~/dotfiles/tmux.conf ~/.tmux.conf

# It seems the gnome keyring messes with the ssh-agent.  Uninstalling it helped
# with a linux mint 18 cinnamon install (after restarting)
# sudo apt-get autoremove gnome-keyring
# This screwed up storing of network creds which was really annoying so
# reversed this out...although it seems to have uninstalled something important.
if [ ! -d ~/.ssh ]; then
    mkdir ~/.ssh
    ssh-keygen -b 4096 -o -a 100 -t rsa
    ssh-add
fi
link ~/dotfiles/ssh_config ~/.ssh/config

echo "All done."
echo "Open vim and type :PluginInstall for Vundle to install vim plugins."
echo "After this, complete Python Code Completion installation:"
echo "cd ~/.vim/bundle/YouCompleteMe"
echo "./install.py"
