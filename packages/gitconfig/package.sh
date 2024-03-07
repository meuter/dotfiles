#!/bin/false "This script should be sourced in a shell, not executed directly"
set -eo pipefail


function dependencies() {
    echo ""
}

function install_package() {
    if [ -f ~/.gitconfig ]; then
        mv -v ~/.gitconfig ~/.gitconfig.bak
    fi
    cd config && stow -t ${HOME} .
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
