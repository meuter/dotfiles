#!/bin/false "This script should be sourced in a shell, not executed directly"

function dependencies() {
    echo ""
}

function install_package() {
    ln -sf ${DOTFILES_ROOT}/inputrc/.inputrc ~/.inputrc
}

function uninstall_package() {
    rm -fv ~/.inputrc
}

function init_package() {
    bind -f ~/.inputrc
}
