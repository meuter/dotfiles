#!/bin/false "This script should be sourced in a shell, not executed directly"

function install_package() {
    local version=1.22.0
    local tarball=go${version}.linux-amd64.tar.gz
    curl -L https://go.dev/dl/${tarball} --output /tmp/${tarball}
    tar -C ${DOTFILES_PREFIX} -xvf /tmp/${tarball}
    rm -rf /tmp/${tarball}
}

function uninstall_package() {
    rm -rvf ${DOTFILES_PREFIX}/go
    unset GOROOT
    unset GOROOT
    unset GOFLAGS=-modcacherw
}

function init_package() {
    export GOROOT=${DOTFILES_PREFIX}/go
    export GOPATH=${DOTFILES_PREFIX}/go/packages
    export GOFLAGS=-modcacherw
    export PATH=$GOROOT/bin:$GOPATH/bin:$PATH
}
