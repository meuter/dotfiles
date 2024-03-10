#!/bin/false "This script should be sourced in a shell, not executed directly"

function install_package() {
    curl https://storage.googleapis.com/git-repo-downloads/repo > ${DOTFILES_BIN}/repo
    chmod a+rx ${DOTFILES_BIN}/repo
}

function uninstall_package() {
    rm -fv ${DOTFILES_BIN}/repo
}

function init_package() {
    echo -n
}
