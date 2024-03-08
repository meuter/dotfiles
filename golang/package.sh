#!/bin/false "This script should be sourced in a shell, not executed directly"

function dependencies() {
    echo ""
}

function install_package() {
    local version=1.22.0
    local tarball=go${version}.linux-amd64.tar.gz
    curl -L https://go.dev/dl/${tarball} --output /tmp/${tarball}
    pushd . &> /dev/null
        tar -C ${DOTFILES_PREFIX} -xvf /tmp/${tarball}
        rm -rf /tmp/${tarball}
    popd &> /dev/null
}

function uninstall_package() {
    rm -rvf ${DOTFILES_PREFIX}/go
    unset GOROOT
    unset GOROOT
}

function init_package() {
    export GOROOT=${DOTFILES_PREFIX}/go
    export GOPATH=${DOTFILES_PREFIX}/go/packages
    export PATH=$GOROOT/bin:$GOPATH/bin:$PATH
}
