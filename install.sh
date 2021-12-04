#! /bin/bash

# sane defaults
set -euo pipefail
export PATH=~/.local/bin:$PATH

BIN=~/.local/bin
SRC=~/.local/src

mkdir -p ${BIN} ${SRC}

function banner() {
    local white_on_green="\e[97m\e[102m"
    local normal="\e[0m"
    echo 
    printf "${white_on_green}------------------------------------------------------------${normal}\n"
    printf "${white_on_green}------------------------------------------------------------${normal}\r"
    printf "${white_on_green}-- ${1} ${normal}\n" 
    printf "${white_on_green}------------------------------------------------------------${normal}\n"
    echo 
}

function add_line_to_file() {
    local file=${1}
    local line=${*:2}
    if ! grep "${line}" "${file}" &>/dev/null; then
        echo "${line}" >>${file}
    fi
}

function initrc() {
    local initrc=~/.bashrc
    add_line_to_file ${initrc} ${1}
    source ${initrc} 
}

function install_gnu_stow() {
    banner "Installing GNU/Stow"
    local version=${1-2.3.1}
    curl -L http://ftp.gnu.org/gnu/stow/stow-${version}.tar.gz --output /tmp/stow-${version}.tar.gz
    tar xvf /tmp/stow-${version}.tar.gz -C ${SRC}/
    pushd .
        cd ${SRC}/stow-${version}/
        ./configure --prefix ~/.local/ && make install
        rm -rf /tmp/stow-${version}.tar.gz
    popd
    initrc 'export PERL5LIB=~/.local/share/perl/'
    initrc 'export PATH=~/.local/bin:$PATH'
}

function install_libtree() {
    banner "Installing libtree"
    local version=${1-v2.0.0}
    curl -L https://github.com/haampie/libtree/releases/download/${version}/libtree_x86_64 --output ${BIN}/libtree
    chmod u+x ${BIN}/libtree
    initrc 'export PATH=~/.local/bin:$PATH'
}

function install_neovim() {
    banner "Installing NeoVIM"
    local version=${1-v0.6.0}
    curl -L https://github.com/neovim/neovim/releases/download/${version}/nvim.appimage --output ${BIN}/nvim
    chmod u+x ${BIN}/nvim
    stow neovim
    initrc 'export PATH=~/.local/bin:$PATH'
    initrc 'alias vim=nvim'
    local packer=~/.local/share/nvim/site/pack/packer/start/packer.nvim
    rm -rf ${packer}
    git clone --depth 1 https://github.com/wbthomason/packer.nvim ${packer}
    nvim --headless -c 'autocmd User PackerComplete quitall' -c "PackerCompile" -c 'PackerSync'
}

install_gnu_stow
install_libtree
install_neovim
