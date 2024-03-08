#!/bin/false "This script should be sourced in a shell, not executed directly"

function dependencies() {
    echo ""
}

function install_package() {
    if [ -f ~/.inputrc ]; then
        mv -v ~/.inputrc ~/.inputrc.bak
    fi
    ln -sf ${DOTFILES_ROOT}/inputrc/.inputrc ~/.inputrc
}

function uninstall_package() {
    rm -f ~/.inputrc
}

function init_package() {
    bind -f ~/.inputrc
}
