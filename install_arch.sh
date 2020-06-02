#!/usr/bin/env bash

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

# Fonts
sudo pacman --noconfirm -S ttf-droid ttf-roboto noto-fonts ttf-liberation \
    ttf-ubuntu-font-family ttf-fira-code adobe-source-code-pro-fonts \
    ttf-freefont noto-fonts-cjk adobe-source-han-sans-otc-fonts \
    noto-fonts-emoji
# Check out https://www.reddit.com/r/archlinux/comments/5r5ep8/make_your_arch_fonts_beautiful_easily/

# GPG / Password stuff
sudo pacman --noconfirm -S pass gnupg pcsclite pwgen

# General file editing
sudo pacman --noconfirm -S vi vim meld screen tmux

# Random Development Tools
sudo pacman --noconfirm -S strace lsof nmap whois cmake ntop iperf gnu-netcat \
    python-pyasn1 python-yaml mitmproxy wavemon graphviz unzip openssh htop \
    wireshark-cli bind-tools httpie bat prettyping fzy the_silver_searcher fd \
    bc wget man-db tldr

# Python Specific Tools
sudo pacman --noconfirm -S python python-pip ipython flake8 python-pylint \
    jupyter

# Download Vundle vim package manager and install configured plugins (vimrc)
mkdir -p ~/.vim/bundle/
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# AWS
sudo pacman --noconfirm -S python-paramiko python-docopt
sudo pacman --noconfirm -S aws-cli

# Docker
sudo pacman --noconfirm -S docker
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo gpasswd -a phelps docker

# zsh
sudo pacman --noconfirm -S zsh
chsh -s /bin/zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -) --unattended"

# Browser
sudo pacman --noconfirm -S firefox

# Image / PDF viewing
#sudo pacman --noconfirm -S feh zathura-pdf-mupdf maim xclip imagemagick \
#    xautolock

# Install yay
if ! [ -x "$(command -v yay)" ]; then
    echo "Installing yay"
    sudo pacman --noconfirm -S go
    mkdir /tmp/yay_install
    pushd /tmp/yay_install
    git clone https://aur.archlinux.org/yay.git
    pushd yay
    makepkg -si --noconfirm
    popd
    popd
    rm -Rf /tmp/yay_install
fi

# Install some basic programs available via yay
yay --noconfirm -S google-chrome
yay --noconfirm -S spotify
yay --noconfirm -S dragon-drag-and-drop-git
yay --noconfirm -S slack-desktop
yay --noconfirm -S find-the-command
yay --noconfirm -S thefuck
yay --noconfirm -S vlc-git
yay --noconfirm -S libreoffice-fresh
yay --noconfirm -S gitkraken
yay --noconfirm -S j4-dmenu-desktop
yay --noconfirm -S dropbox

# IDE
yay --noconfirm -S vscodium-bin pycharm-professional goland

# vscode plugins
#vscodium --install-extension ms-python.python

# VPN
sudo pacman --noconfirm -S openvpn
yay --noconfirm -S openvpn-update-resolv-conf
#yaourt --noconfirm -S pulse-secure
#yaourt --noconfirm -S webkitgtk


# Netflix Specific Utilities
if [ "$NETFLIX" = true ] ; then
    # Metatron
    sudo pacman --noconfirm -S jq curl jre8-openjdk
    curl -sL https://go.netflix.com/metatron-install | bash

    # Newt
    curl -q -sL 'https://go.netflix.com/newt-install' | bash
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

backup ~/.aliases
backup ~/.gitconfig
backup ~/.gitignore
backup ~/.screenrc
backup ~/.vimrc
backup ~/.tmux.conf
backup ~/.zshrc
backup ~/.pam_environment
backup ~/.ssh/config
#mkdir -p ~/.config/
#backup ~/.config/i3/config
mkdir -p ~/.config/sway/
backup ~/.config/sway/config
mkdir -p ~/.gnupg/
backup ~/.gnupg/gpg-agent.conf
#mkdir -p ~/.local/bin
#backup ~/.local/bin/fuzzy_lock.sh
#mkdir -p ~/.config/i3status/
#backup ~/.config/i3status/config
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

link ~/dotfiles/aliases ~/.aliases
link ~/dotfiles/gitconfig ~/.gitconfig
link ~/dotfiles/gitignore ~/.gitignore
link ~/dotfiles/screenrc ~/.screenrc
link ~/dotfiles/vimrc ~/.vimrc
link ~/dotfiles/tmux.conf ~/.tmux.conf
link ~/dotfiles/zshrc ~/.zshrc
#link ~/dotfiles/redshift.conf ~/.config/redshift.conf
#link ~/dotfiles/i3_config ~/.config/i3/config
link ~/dotfiles/sway_config ~/.config/sway/config
link ~/dotfiles/pam_environment ~/.pam_environment
link ~/dotfiles/gpg-agent.conf ~/.gnupg/gpg-agent.conf
#link ~/dotfiles/fuzzy_lock.sh ~/.local/bin/fuzzy_lock.sh
#link ~/dotfiles/i3status.conf ~/.config/i3status/config
link ~/dotfiles/ssh-agent.service ~/.config/systemd/user/ssh-agent.service

# Install Vundle packages and autocompletion vim plugin
yay --noconfirm -S vim-colors-zenburn-git
vim +PluginInstall +qall
vim +GoInstallBinaries +qall
pushd ~/.vim/bundle/YouCompleteMe
python ./install.py
popd

mkdir -p ~/.ssh/
if [ ! -f ~/.ssh/id_rsa.pub ]; then
    mkdir ~/.ssh
    ssh-keygen -b 4096 -o -a 100 -t rsa
    #ssh-add # Not clear whether this is needed or not 6/1/2020
fi
link ~/dotfiles/ssh_config ~/.ssh/config

systemctl --user start ssh-agent.service
systemctl --user enable ssh-agent.service

# Setting sudo timeout period to 60min and allowing cross tty sudo cred caching
echo "Please run 'visudo' as root and add the following line:"
echo "Defaults timestamp_timeout=60,!tty_tickets"
echo ""
echo "Setup local gpg keys"
echo ""
echo "Create file called vpncreds.txt with vpn creds at ~/.config/vpncreds.txt"
echo "containing vpn username and pass on two lines."
echo ""
echo "gpg --encrypt -r phelps@williamslabs.com ~/.config/vpncreds.txt"
echo "rm ~/.config/vpncreds.txt"
echo "sudo mkdir /etc/openvpn/creds/"
echo "chown $USER:$USER /etc/openvpn/creds"
echo ""
echo "Setup dropbox by running 'dropbox' and entering creds"
echo ""

echo "All done."
