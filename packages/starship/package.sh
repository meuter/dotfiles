#!/bin/false "This script should be sourced in a shell, not executed directly"

STARSHIP_VERSION=1.17.1

function dependencies() {
    echo "stow"
}

function install_package() {
    local tarball=starship-x86_64-unknown-linux-musl.tar.gz
    curl -L https://github.com/starship/starship/releases/download/v${STARSHIP_VERSION}/${tarball} --output /tmp/${tarball}
    pushd . &> /dev/null
        cd ${DOTFILES_BIN}
        tar xvf /tmp/${tarball}
        rm -rf /tmp/${tarball}
    popd &> /dev/null
    cd config && stow -t ${HOME} .
}

function uninstall_package() {
    stow -t ${HOME} -D config
    rm -rf ${DOTFILES_BIN}/starship
}

function init_package() {
    eval "$(starship init bash)"
}

