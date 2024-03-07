#! /usr/bin/env bash
set -eo pipefail

VERSION=1.17.1
BIN=~/.local/bin
SRC=~/.local/src
SHARE=~/.local/share

function install() {
    echo
    echo 
    echo "Installing Starship..."
    echo
    echo

    local tarball=starship-x86_64-unknown-linux-musl.tar.gz
    curl -L https://github.com/starship/starship/releases/download/v${VERSION}/${tarball} --output /tmp/${tarball}
    pushd .
        cd ${BIN}
        tar xvf /tmp/${tarball}
        rm -rf /tmp/${tarball}
    popd
    stow -t ${HOME} -d config
}

function uninstall() {
    stow -t ${HOME} -D config
    rm -rf ${BIN}/starship
}

function initrc() {
    eval "$(starship init bash)"
}

