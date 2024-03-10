#!/bin/false "This script should be sourced in a shell, not executed directly"

function dependencies() {
    echo -n
}

function install_package() {
    # version info
    local version=15.0.6
    local tarball=clang+llvm-${version}-x86_64-linux-gnu-ubuntu-18.04.tar.xz
    local checksum=a48464533ddabc180d830df7e13e82ae

    # download tarball
    curl -L https://github.com/llvm/llvm-project/releases/download/llvmorg-${version}/${tarball} --output /tmp/${tarball}

    # check tarball
    if [ "${checksum}" != $(md5sum /tmp/${tarball} | awk '{print $1}') ]; then
        >&2 echo Unexpected checksum
        return 1
    fi

    # extract tarball directly in destibation
    tar xvf /tmp/${tarball} --strip-components=1 -C ${DOTFILES_PREFIX}

    # cleanup tarball
    rm -rf /tmp/${tarball}
}

function uninstall_package() {
    # TODO
    echo -n
}

function init_package() {
    echo -n
}
