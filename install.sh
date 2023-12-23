#!/usr/bin/env bash

# This script is now configured for supporting Manjaro Sway edition
# https://github.com/manjaro-sway/manjaro-sway

# Determine environment specifics
NETFLIX=false
echo "Install Netflix tools (requires Netflix network)?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) NETFLIX=true; break;;
        No ) break;;
    esac
done

# Update pacman
sudo pacman -Syu

echo "Installing tools"

# GPG / Password stuff
sudo pacman --noconfirm -S pass pwgen

# General file editing
sudo pacman --noconfirm -S neovim meld screen
 
# Random Development Tools
sudo pacman --noconfirm -S strace whois wireshark-qt wireshark-cli bind-tools \
    httpie bat prettyping the_silver_searcher fd tldr github-cli

# AWS
sudo pacman --noconfirm -S aws-cli

# Docker
sudo pacman --noconfirm -S docker
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo gpasswd -a $USER docker

# Install some basic programs available via yay
yay --noconfirm -S google-chrome spotify

# IDE
yay --noconfirm -S visual-studio-code-bin

# vscode plugins
code --install-extension ms-python.python
code --install-extension Tanh.hjson-formatter
code --install-extension laktak.hjson
code --install-extension ms-azuretools.vscode-docker
code --install-extension ms-vscode-remote.vscode-remote-extensionpack

# Pulse Secure VPN
sudo pacman --noconfirm -S gtkmm3 webkit2gtk
yay --noconfirm -S pulse-secure
sudo systemctl start pulsesecure
sudo systemctl enable pulsesecure
sudo /opt/pulsesecure/bin/setup_cef.sh install

# Netflix Specific Utilities
if [ "$NETFLIX" = true ] ; then
    # Metatron
    curl -q -sL 'https://go.prod.netflix.net/metatron-install' | bash

    # Newt
    curl -q -sL 'https://go.prod.netflix.net/newt-install' | bash
fi

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

# Removing this file fixes a vscode wayland issue
backup ~/.config/code-flags.conf
#backup ~/.aliases
backup ~/.gitconfig
backup ~/.gitignore
backup ~/.screenrc
backup ~/.vimrc
backup ~/.tmux.conf
backup ~/.zshrc
backup ~/.pam_environment
backup ~/.ssh/config
mkdir -p ~/.gnupg/
backup ~/.gnupg/gpg-agent.conf
mkdir -p ~/.local/bin # Xorg
backup ~/.local/bin/fuzzy_lock.sh # Xorg
mkdir -p ~/.config/i3status/ # Xorg
backup ~/.config/i3status/config # Xorg
mkdir -p ~/.config/systemd/user
backup ~/.config/systemd/user/ssh-agent.service

echo "Symlinking files:"
link() {
    from="$1"
    to="$2"
    echo "Linking '$from' to '$to'"
    rm -f "$to"
    ln -s "$from" "$to"
}

link $PWD/sway/customconf.conf ~/.config/sway/config.d/customconf.conf
link $PWD/sway/customdefs.conf ~/.config/sway/definitions.d/customdefs.conf
link $PWD/sway/waybar_config.jsonc ~/.config/waybar/config.jsonc
link $PWD/aliases ~/.config/zsh/config.d/other_aliases
link ~/dotfiles/gitconfig ~/.gitconfig
link ~/dotfiles/gitignore ~/.gitignore
link ~/dotfiles/screenrc ~/.screenrc
link ~/dotfiles/vimrc ~/.vimrc
link ~/dotfiles/tmux.conf ~/.tmux.conf
link ~/dotfiles/zshrc ~/.zshrc
link ~/dotfiles/pam_environment ~/.pam_environment
link ~/dotfiles/gpg-agent.conf ~/.gnupg/gpg-agent.conf
link ~/dotfiles/ssh-agent.service ~/.config/systemd/user/ssh-agent.service

mkdir -p ~/.ssh/
if [ ! -f ~/.ssh/id_rsa.pub ]; then
    mkdir ~/.ssh
    ssh-keygen -b 4096 -o -a 100 -t rsa
    #ssh-add # Not clear whether this is needed or not 6/1/2020
fi
link ~/dotfiles/ssh_config ~/.ssh/config

systemctl --user start ssh-agent.service
systemctl --user enable ssh-agent.service

echo "All done."
