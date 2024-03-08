#!/bin/false "This script should be sourced in a shell, not executed directly"

function dependencies() {
    echo "rust git-delta"
}

function install_package() {
    if [ -f ~/.gitconfig ]; then
        mv -v ~/.gitconfig ~/.gitconfig.bak
    fi
    ln -sf ${DOTFILES_ROOT}/gitconfig/.gitconfig ~/.gitconfig
}

function uninstall_package() {
    rm -f ~/.gitconfig
    unalias w
    unalias d
    unalias l
    unalias g
}

function init_package() {
    alias w="git status -s"
    alias d="git diff"
    alias l="git lol"
    alias g="git lolg"
}
