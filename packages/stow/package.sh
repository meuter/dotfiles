#! /usr/bin/env bash
set -eo pipefail

VERSION=2.3.1
BIN=~/.local/bin
SRC=~/.local/src
SHARE=~/.local/share

function install() {
    echo
    echo 
    echo "Installing GNU/Stow..."
    echo
    echo
    mkdir -pv ${BIN} ${SRC} ${SHARE}
    local tarball=stow-${VERSION}.tar.gz
    curl -L http://ftp.gnu.org/gnu/stow/${tarball} --output /tmp/${tarball}
    tar xvf /tmp/${tarball} -C ${SRC}/
    pushd .
        cd ${SRC}/stow-${VERSION}/
        ./configure --prefix ~/.local/ && make install
        rm -rvf /tmp/${tarball} 
    popd

}

function uninstall() {
    pushd .
        cd ${SRC}/stow-${VERSION}/
        make uninstall
    popd
    rm -rvf ${SRC}/stow-${VERSION}/
}

function initrc() {
    export PATH=${BIN}:$PATH
    export PERL5LIB=${SHARE}/perl/
}
