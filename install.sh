#! /bin/bash
set -euo pipefail

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
    local tarball=stow-${version}.tar.gz
    curl -L http://ftp.gnu.org/gnu/stow/${tarball} --output /tmp/${tarball}
    tar xvf /tmp/${tarball} -C ${SRC}/
    pushd .
        cd ${SRC}/stow-${version}/
        ./configure --prefix ~/.local/ && make install
        rm -rf /tmp/${tarball}
    popd
    initrc 'export PERL5LIB=~/.local/share/perl/'
    initrc 'export PATH=~/.local/bin:$PATH'
}

function configure_git() {
    banner "Configuring git"
    if [ -f ~/.gitconfig ]; then
        mv -v ~/.gitconfig ~/.gitconfig.bak
    fi
    stow git
    initrc 'alias w="git status -s"'
    initrc 'alias d="git diff"'
    initrc 'alias l="git lol"'
    initrc 'alias g="git lolg"'
}

function install_libtree() {
    banner "Installing libtree"
    local version=${1-v2.0.0}
    curl -L https://github.com/haampie/libtree/releases/download/${version}/libtree_x86_64 --output ${BIN}/libtree
    chmod u+x ${BIN}/libtree
    initrc 'export PATH=~/.local/bin:$PATH'
}

function install_exa() {
    banner "Installing exa"
    local version=${1-v0.10.1}
    local zipfile=exa-linux-x86_64-${version}.zip
    curl -L https://github.com/ogham/exa/releases/download/${version}/${zipfile} --output /tmp/${zipfile}
    pushd .
        cd ~/.local
        unzip -o /tmp/${zipfile}
        rm -rf ${zipfile}
    popd
    initrc 'export PATH=~/.local/bin:$PATH'
    initrc 'alias ls="exa --icons"'
}

function install_bat() {
    banner "Installing bat"
    local version=${1-v0.18.3}
    local tarball=bat-${version}-x86_64-unknown-linux-musl.tar.gz
    curl -L https://github.com/sharkdp/bat/releases/download/${version}/${tarball} --output /tmp/${tarball}
    pushd .
        cd /tmp
        tar xvf /tmp/${tarball}
        find /tmp/${tarball%.tar.gz} -name "bat" -type f -exec mv {} ~/.local/bin/ \;
#        rm -rf ${tarball}
    popd
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
    echo
}

install_gnu_stow
configure_git
install_libtree
install_exa
install_bat
install_neovim
