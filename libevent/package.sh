#!/bin/false "This script should be sourced in a shell, not executed directly"

function dependencies() {
    echo "clang"
}

function install_package() {
    local version=2.1.12
    local dirname=libevent-${version}-stable
    local tarball=${dirname}.tar.gz
    curl -L https://github.com/libevent/libevent/releases/download/release-${version}-stable/${tarball} --output /tmp/${tarball}
    tar xvf /tmp/${tarball} -C ${DOTFILES_SRC}/
    rm -fv /tmp/${tarball}
    cd ${DOTFILES_SRC}/${dirname}
    CC=clang ./configure --prefix=${DOTFILES_PREFIX} --enable-shared --disable-openssl
    make -j && make install
}

function uninstall_package() {
    local version=2.1.12
    local dirname=libevent-${version}-stable
    make -C ${DOTFILES_SRC}/${dirname} uninstall
    rm -rvf ${DOTFILES_SRC}/${dirname}
}

function init_package() {
    echo -n
}
