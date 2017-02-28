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
