#!/bin/false "This script should be sourced in a shell, not executed directly"

function dependencies() {
    echo ""
}

function install_package() {
    local version=0.46.1
    local tarball=fzf-${version}-linux_amd64.tar.gz
    curl -L https://github.com/junegunn/fzf/releases/download/${version}/${tarball} --output /tmp/${tarball}
    mkdir -pv ${DOTFILES_SHARE}/fzf
    curl -L https://raw.githubusercontent.com/junegunn/fzf/${version}/shell/key-bindings.bash --output ${DOTFILES_SHARE}/fzf/key-bindings.bash
    pushd . &> /dev/null
        cd ${DOTFILES_BIN}
        tar xvf /tmp/${tarball}
        rm -rf /tmp/${tarball}
    popd &> /dev/null

}

function uninstall_package() {
    rm -vf ${DOTFILES_BIN}/fzf ${DOTFILES_SHARE}/fzf/key-bindings.bash
}

function init_package() {
    source ${DOTFILES_SHARE}/fzf/key-bindings.bash
}
