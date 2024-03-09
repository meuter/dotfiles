#!/bin/false "This script should be sourced in a shell, not executed directly"

function dependencies() {
    echo "clang libevent"
}

function install_package() {
    local version=6.3
    local dirname=ncurses-${version}
    local tarball=${dirname}.tar.gz
    curl -L https://ftp.gnu.org/pub/gnu/ncurses/${tarball} --output /tmp/${tarball}
    tar xvf /tmp/${tarball} -C ${DOTFILES_SRC}/
    rm -fv /tmp/${tarball}
    pushd . &> /dev/null
        cd ${DOTFILES_SRC}/${dirname}
	CC=clang ./configure --prefix=${DOTFILES_PREFIX} --with-shared --with-termlib --enable-pc-files \
	                     --with-pkg-config-libdir=${DOTFILES_LIB}/pkgconfig
	
	make -j && make install

        # https://stackoverflow.com/questions/51408698/when-in-conda-tmux-and-emacs-throw-error-while-loading-shared-libraries-libti
        rm -v ${DOTFILES_LIB}/libtinfo.so.6
        ln -s `readlink -f ${DOTFILES_LIB}/libtinfo.so` `readlink -f ${DOTFILES_LIB}/libtinfo.so | sed 's@libtinfo.so$@libtinfo.so.6@'`
    popd &> /dev/null
}

function uninstall_package() {
    # TODO
    echo -n
}

function init_package() {
    echo -n
}
