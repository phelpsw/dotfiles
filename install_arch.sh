#!/usr/bin/env bash

# Update pacman
sudo pacman -Syu

echo "Installing tools"
# GPG / Password stuff
sudo pacman -S pass gnupg

# General file editing
sudo pacman -S vim meld python python2 python-pip python2-virtualenv \
    screen tmux ipython cmake go flake8 python2-flake8 python-pylint \
    python2-pylint

# Download Vundle vim package manager and install configured plugins (vimrc)
mkdir -p ~/.vim/bundle/
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# AWS
sudo pip install docopt paramiko
sudo pacman -S aws-cli

# VPN
sudo pacman -S openvpn

# zsh
sudo pacman -S zsh
chsh -s /bin/zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# Image / PDF viewing
sudo pacman -S feh zathura-pdf-mupdf

# Weechat: https://github.com/rawdigits/wee-slack
sudo pacman -S weechat
sudo pip install setuptools wheel
sudo pip install websocket-client
mkdir -p ~/.weechat/python/autoload/
wget -O ~/.weechat/python/autoload/wee_slack.py \
    https://raw.githubusercontent.com/rawdigits/wee-slack/master/wee_slack.py

# Redshift screen temp adjustment
sudo pacman -S redshift

# TODO: Install yaourt here

yaourt -S postman-bin

# Metatron
sudo pacman -S jq curl jre8-openjdk
sudo curl -o /usr/local/bin/metatron https://artifacts.netflix.com/libs-releases-local/netflix/metatron-cli/1.65.0/metatron-cli-launcher-1.65.0.sh
sudo chmod +x /usr/local/bin/metatron

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

backup ~/.aliases
backup ~/.gitconfig
backup ~/.gitignore
backup ~/.screenrc
backup ~/.vimrc
backup ~/.tmux.conf
backup ~/.zshrc
backup ~/.ssh/config
mkdir -p ~/.config/
backup ~/.config/redshift.conf
backup ~/.config/i3/config
mkdir -p ~/.gnupg/
backup ~/.gnupg/gpg-agent.conf
backup ~/.pam_environment

echo "Symlinking files:"
link() {
    from="$1"
    to="$2"
    echo "Linking '$from' to '$to'"
    rm -f "$to"
    ln -s "$from" "$to"
}

link ~/dotfiles/aliases ~/.aliases
link ~/dotfiles/gitconfig ~/.gitconfig
link ~/dotfiles/gitignore ~/.gitignore
link ~/dotfiles/screenrc ~/.screenrc
link ~/dotfiles/vimrc ~/.vimrc
link ~/dotfiles/tmux.conf ~/.tmux.conf
link ~/dotfiles/zshrc ~/.zshrc
link ~/dotfiles/redshift.conf ~/.config/redshift.conf
link ~/dotfiles/i3_config ~/.config/i3/config
link ~/dotfiles/gpg-agent.conf ~/.gnupg/gpg-agent.conf
link ~/dotfiles/pam_environment ~/.pam_environment

# Install Vundle packages and autocompletion vim plugin
yaourt -S vim-colors-zenburn-git
vim +PluginInstall +qall
pushd ~/.vim/bundle/YouCompleteMe
python ./install.py
popd

if [ ! -d ~/.ssh ]; then
    mkdir ~/.ssh
    ssh-keygen -b 4096 -o -a 100 -t rsa
    ssh-add
fi
link ~/dotfiles/ssh_config ~/.ssh/config

echo "All done."
