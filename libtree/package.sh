#!/bin/false "This script should be sourced in a shell, not executed directly"

function dependencies() {
    echo ""
}

function install_package() {
    local version=3.1.1
    curl -L https://github.com/haampie/libtree/releases/download/v${version}/libtree_x86_64 --output ${DOTFILES_BIN}/libtree
    chmod u+x ${DOTFILES_BIN}/libtree
}

function uninstall_package() {
    rm -fv ${DOTFILES_BIN}/libtree
}

function init_package() {
    echo -n
}
