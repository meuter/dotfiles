#!/bin/false "This script should be sourced in a shell, not executed directly"

EXA_VERSION=0.10.1

function dependencies() {
    echo ""
}

function install_package() {
    local zipfile=exa-linux-x86_64-v${EXA_VERSION}.zip
    curl -L https://github.com/ogham/exa/releases/download/v${EXA_VERSION}/${zipfile} --output /tmp/${zipfile}
    pushd . &> /dev/null
        cd ${DOTFILES_PREFIX}
        unzip -o /tmp/${zipfile}
        rm -rf /tmp/${zipfile}
    popd &> /dev/null
}

function uninstall_package() {
    rm -rvf ${DOTFILES_PREFIX}/man/{exa.*,exa_*} ${DOTFILES_PREFIX}/completions/exa.*
    rm -rvf ${DOTFILES_BIN}/exa 
    unalias ls
}

function init_package() {
    alias ls=exa
}
