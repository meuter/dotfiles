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
    pushd . &> /dev/null
        cd ${DOTFILES_SRC}/${dirname}
        CC=clang ./configure --prefix=${DOTFILES_PREFIX} --enable-shared --disable-openssl
        make -j && make install
    popd &> /dev/null
}

function uninstall_package() {
    # TODO
    echo -n
}

function init_package() {
    echo -n
}
