#!/bin/false "This script should be sourced in a shell, not executed directly"

function dependencies() {
    echo "clang libevent ncurses"
}

function install_package() {
    local version=3.3
    local dirname=tmux-${version}
    local tarball=${dirname}.tar.gz
    curl -L https://github.com/tmux/tmux/releases/download/${version}/${tarball} --output /tmp/${tarball}
    tar xvf /tmp/${tarball} -C ${DOTFILES_SRC}/
    rm -fv /tmp/${tarball}
    pushd . &> /dev/null
        cd ${DOTFILES_SRC}/${dirname}

        CC=clang ./configure CPPFLAGS="-I${DOTFILES_INCLUDE} -I${DOTFILES_INCLUDE}/ncurses" \
                             LDFLAGS=-L${DOTFILES_LIB} \
                             --prefix=${DOTFILES_PREFIX}
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
