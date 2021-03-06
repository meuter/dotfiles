#! /bin/bash -e

source ./colors.sh

info "Installing neovim..."
sudo apt-add-repository -y ppa:neovim-ppa/stable
sudo apt -y update
sudo apt -y install neovim

info "Configuring NeoVIM as default editor..."
sudo update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
sudo update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60

info "Installing nvim config..."
mkdir -p ~/.config/nvim/
ln -s ~/.devbox/nvim/init.vim ~/.config/nvim/init.vim

sudo apt install -y silversearcher-ag clang python3-pip
sudo pip install neovim jedi --upgrade
sudo pip3 install neovim jedi --upgrade
vim +'PlugInstall' +qa

success "Done!"
