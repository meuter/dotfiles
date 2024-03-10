#!/bin/false "This script should be sourced in a shell, not executed directly"

function install_package() {
    local version=0.46.1
    local tarball=fzf-${version}-linux_amd64.tar.gz
    curl -L https://github.com/junegunn/fzf/releases/download/${version}/${tarball} --output /tmp/${tarball}
    tar xvf /tmp/${tarball} -C ${DOTFILES_BIN}
    rm -rf /tmp/${tarball}

    mkdir -pv ${DOTFILES_SHARE}/fzf
    curl -L https://raw.githubusercontent.com/junegunn/fzf/${version}/shell/key-bindings.bash --output ${DOTFILES_SHARE}/fzf/key-bindings.bash
}

function uninstall_package() {
    rm -vf ${DOTFILES_BIN}/fzf ${DOTFILES_SHARE}/fzf/key-bindings.bash
}

function init_package() {
    source ${DOTFILES_SHARE}/fzf/key-bindings.bash
}
