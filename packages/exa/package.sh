#!/bin/false "This script should be sourced in a shell, not executed directly"
set -eo pipefail

EXA_VERSION=0.10.1

function dependencies() {
    echo ""
}

function install_package() {
    local zipfile=exa-linux-x86_64-v${EXA_VERSION}.zip
    curl -L https://github.com/ogham/exa/releases/download/v${EXA_VERSION}/${zipfile} --output /tmp/${zipfile}
    pushd .
        cd ~/.local
        unzip -o /tmp/${zipfile}
        rm -rf /tmp/${zipfile}
    popd
}

function uninstall_package() {
    :;
}

function init_package() {
    alias ls=exa
}
