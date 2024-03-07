#! /usr/bin/env bash
set -eo pipefail

function install_package() {
    pushd .
        cd ${1}
        source package.sh
        install
        initrc
    popd 
}

function uninstall_package() {
    pushd .
        cd ${1}
        source package.sh
        uninstall
    popd
}

function init_package() {
    pushd .
        cd ${1}
        source package.sh
        initrc 
    popd
}


function install() {
    install_package stow
    install_package starship
}


function uninstall() {
    uninstall_package stow
    uninstall_package starship
}

function initrc() {
    init_package stow
    init_package starship
}
