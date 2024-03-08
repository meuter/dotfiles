#!/bin/false "This script should be sourced in a shell, not executed directly"

function dependencies() {
    echo "rust ripgrep"
}

function install_package() {
    local version=0.9.5
    local tarball=nvim-linux64.tar.gz
    curl -L https://github.com/neovim/neovim/releases/download/v${version}/${tarball} --output /tmp/${tarball}
    pushd . &> /dev/null
        cd ${DOTFILES_PREFIX}
        tar xvf /tmp/${tarball} --strip-components=1
        rm -rf /tmp/${tarball}
    popd &> /dev/null
    # TODO: should be main branch
    git clone -b catpuccin https://github.com/meuter/nvim ${DOTFILES_CONFIG}/nvim
}

function uninstall_package() {
    rm -rf ${DOTFILES_CONFIG}/nvim/
    rm -rf ${DOTFILES_SHARE}/nvim
}

function init_package() {
    alias vim=nvim
}
