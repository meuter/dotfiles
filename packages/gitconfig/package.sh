#!/bin/false "This script should be sourced in a shell, not executed directly"

function dependencies() {
    echo ""
}

function install_package() {
    if [ -f ~/.gitconfig ]; then
        mv -v ~/.gitconfig ~/.gitconfig.bak
    fi
    ln -sf ${DOTFILES_ROOT}/gitconfig/.gitconfig ~/.gitconfig
}

function uninstall_package() {
    echo -n
}

function init_package() {
    alias w="git status -s"
    alias d="git diff"
    alias l="git lol"
    alias g="git lolg"
}
