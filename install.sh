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
sudo pacman --noconfirm -S neovim screen tmux
 
# Random Development Tools
sudo pacman --noconfirm -S strace whois wireshark-qt wireshark-cli bind-tools \
    httpie bat prettyping the_silver_searcher fd tldr github-cli meld

# AWS
sudo pacman --noconfirm -S aws-cli

# Docker
sudo pacman --noconfirm -S docker docker-compose
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo gpasswd -a $USER docker

# Install some basic programs available via yay
yay --noconfirm -S google-chrome spotify joplin-desktop

# IDE
yay --noconfirm -S visual-studio-code-bin

# vscode plugins
code --install-extension ms-python.python
code --install-extension Tanh.hjson-formatter
code --install-extension laktak.hjson
code --install-extension ms-azuretools.vscode-docker
code --install-extension ms-vscode-remote.vscode-remote-extensionpack
code --install-extension GitHub.copilot
code --install-extension GitHub.copilot-chat

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

# Removing code-flags.conf fixes a vscode wayland issue
backup ~/.config/code-flags.conf

backup ~/.config/sway/config
backup ~/.screenrc
backup ~/.tmux.conf

echo "Symlinking files:"
link() {
    from="$1"
    to="$2"
    echo "Linking '$from' to '$to'"
    rm -f "$to"
    ln -s "$from" "$to"
}

link $PWD/sway/config ~/.config/sway/config
link $PWD/sway/config.d/myconfig.conf ~/.config/sway/config.d/additional_config.conf
link $PWD/sway/definitions.d/mydefs.conf ~/.config/sway/definitions.d/additional_defs.conf
link $PWD/sway/modes ~/.config/sway/modes
link $PWD/sway/waybar_config.jsonc ~/.config/waybar/config.jsonc
link $PWD/aliases ~/.config/zsh/config.d/other_aliases
link ~/dotfiles/screenrc ~/.screenrc
link ~/dotfiles/tmux.conf ~/.tmux.conf

mkdir -p ~/.ssh/
if [ ! -f ~/.ssh/id_ed25519 ]; then
    mkdir -p ~/.ssh
    ssh-keygen
fi

git config user.name "Phelps Williams"
git config user.email "phelps@netflix.com"

echo "\nPlace background image at ~/Pictures/background.jpg\n"
echo "All done."
