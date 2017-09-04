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
# GPG / Password stuff
sudo pacman --noconfirm -S pass gnupg pcsclite

# General file editing
sudo pacman --noconfirm -S vim meld screen tmux

# Random Development Tools
sudo pacman --noconfirm -S strace lsof nmap whois cmake ntop iperf gnu-netcat \
    python-pyasn1 python-yaml mitmproxy wavemon graphviz unzip openssh htop \
    wireshark-cli

# Python Specific Tools
sudo pacman --noconfirm -S python python2 python-pip python2-pip \
    python2-virtualenv ipython flake8 python2-flake8 python-pylint \
    python2-pylint jupyter python2-ipykernel

# Download Vundle vim package manager and install configured plugins (vimrc)
mkdir -p ~/.vim/bundle/
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# AWS
sudo pacman --noconfirm -S python-paramiko python-docopt
sudo pacman --noconfirm -S aws-cli

# VPN
sudo pacman --noconfirm -S openvpn

# Postgres
sudo pacman --noconfirm -S postgresql

# zsh
sudo pacman --noconfirm -S zsh
chsh -s /bin/zsh
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

# Image / PDF viewing
sudo pacman --noconfirm -S feh zathura-pdf-mupdf maim xclip imagemagick \
    xautolock

# Redshift screen temp adjustment
sudo pacman --noconfirm -S redshift

# golang tools
sudo pacman --noconfirm -S go glide
mkdir -p ~/projects/go

# Install yaourt
if ! [ -x "$(command -v yaourt)" ]; then
    mkdir /tmp/yaourt_install
    pushd /tmp/yaourt_install
    wget https://aur.archlinux.org/cgit/aur.git/snapshot/package-query.tar.gz
    tar xfz package-query.tar.gz
    pushd package-query
    makepkg
    sudo pacman --noconfirm -U package-query*.pkg.tar.xz
    popd

    wget https://aur.archlinux.org/cgit/aur.git/snapshot/yaourt.tar.gz
    tar xzf yaourt.tar.gz
    pushd yaourt
    makepkg
    sudo pacman --noconfirm -U yaourt*.pkg.tar.xz
    popd
    popd
    rm -Rf /tmp/yaourt_install
fi

# Install some basic programs available via yaourt
yaourt --noconfirm -S google-chrome
yaourt --noconfirm -S postman-bin
yaourt --noconfirm -S spotify
yaourt --noconfirm -S dragon-git
yaourt --noconfirm -S mons


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
mkdir -p ~/.config/
backup ~/.config/redshift.conf
backup ~/.config/i3/config
mkdir -p ~/.gnupg/
backup ~/.gnupg/gpg-agent.conf
mkdir -p ~/.local/bin
backup ~/.local/bin/fuzzy_lock.sh
mkdir -p ~/.config/i3status/
backup ~/.config/i3status/config
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
link ~/dotfiles/redshift.conf ~/.config/redshift.conf
link ~/dotfiles/redshift_systemd.conf ~/.config/systemd/user/redshift.service.d/display.conf
link ~/dotfiles/i3_config ~/.config/i3/config
link ~/dotfiles/pam_environment ~/.pam_environment
link ~/dotfiles/gpg-agent.conf ~/.gnupg/gpg-agent.conf
link ~/dotfiles/fuzzy_lock.sh ~/.local/bin/fuzzy_lock.sh
link ~/dotfiles/i3status.conf ~/.config/i3status/config
link ~/dotfiles/ssh-agent.service ~/.config/systemd/user/ssh-agent.service

# Startup redshift now that config files are in place
# https://superuser.com/questions/759759/writing-a-service-that-depends-on-xorg
# Not enabling by default because it isn't setup to start after Xorg is running
# systemctl --user enable redshift
systemctl --user start redshift

# Install Vundle packages and autocompletion vim plugin
yaourt --noconfirm -S vim-colors-zenburn-git
vim +PluginInstall +qall
vim +GoInstallBinaries +qall
pushd ~/.vim/bundle/YouCompleteMe
python ./install.py
popd

if [ ! -d ~/.ssh ]; then
    mkdir ~/.ssh
    ssh-keygen -b 4096 -o -a 100 -t rsa
    ssh-add
fi
link ~/dotfiles/ssh_config ~/.ssh/config

systemctl --user start ssh-agent.service
systemctl --user enable ssh-agent.service

echo "All done."
