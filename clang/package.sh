#!/bin/false "This script should be sourced in a shell, not executed directly"

function dependencies() {
    echo ""
}

function install_package() {
    local version=${1-14.0.0}
    local tarball=clang+llvm-${version}-x86_64-linux-gnu-ubuntu-18.04.tar.xz
    curl -L https://github.com/llvm/llvm-project/releases/download/llvmorg-${version}/${tarball} --output /tmp/${tarball}
    tar xvf /tmp/${tarball} --strip-components=1 -C ${DOTFILES_PREFIX}
    rm -rf /tmp/${tarball}
}

function uninstall_package() {
    # TODO
    echo -n
}

function init_package() {
    echo -n
}
