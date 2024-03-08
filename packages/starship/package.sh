#!/bin/false "This script should be sourced in a shell, not executed directly"


function dependencies() {
    echo ""
}

function install_package() {
    local version=1.17.1
    local tarball=starship-x86_64-unknown-linux-musl.tar.gz
    curl -L https://github.com/starship/starship/releases/download/v${version}/${tarball} --output /tmp/${tarball}
    pushd . &> /dev/null
        cd ${DOTFILES_BIN}
        tar xvf /tmp/${tarball}
        rm -rf /tmp/${tarball}
    popd &> /dev/null
    ln -fs ${DOTFILES_ROOT}/starship/starship.toml ${DOTFILES_CONFIG}/
}

function uninstall_package() {
    rm ${DOTFILES_CONFIG}/starship.toml
    rm -rf ${DOTFILES_BIN}/starship
}

function init_package() {
    eval "$(starship init bash)"
}

