#!/bin/false "This script should be sourced in a shell, not executed directly"

function dependencies() {
    echo ""
}

function install_package() {
    local version=0.24.0
    local tarball=bat-v${version}-x86_64-unknown-linux-musl.tar.gz
    curl -L https://github.com/sharkdp/bat/releases/download/v${version}/${tarball} --output /tmp/${tarball}
    tar xvf /tmp/${tarball} -C /tmp
    find /tmp/${tarball%.tar.gz} -name "bat" -type f -exec mv {} ${DOTFILES_BIN}/ \;
    rm -rf /tmp/${tarball}
}

function uninstall_package() {
    rm -fv ${DOTFILES_BIN}/bat
}

function init_package() {
    echo -n
}
