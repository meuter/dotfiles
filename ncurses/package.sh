function dependencies() {
    echo "clang pkg-config libevent"
}

function install_package() {
    local version=6.3
    local dirname=ncurses-${version}
    local tarball=${dirname}.tar.gz
    local checksum=a2736befde5fee7d2b7eb45eb281cdbe

    curl -L https://ftp.gnu.org/pub/gnu/ncurses/${tarball} --output /tmp/${tarball}
    if [ "${checksum}" != $(md5sum /tmp/${tarball} | awk '{print $1}') ]; then
        >&2 echo Unexpected checksum
        return 1
    fi

    tar xvf /tmp/${tarball} -C ${DOTFILES_SRC}/
    rm -fv /tmp/${tarball}

    cd ${DOTFILES_SRC}/${dirname}
    CC=clang ./configure --prefix=${DOTFILES_PREFIX} \
                         --with-shared --with-termlib \
                         --enable-pc-files \
                         --with-pkg-config-libdir=${DOTFILES_LIB}/pkgconfig
    make -j && make install

    # https://stackoverflow.com/questions/51408698/when-in-conda-tmux-and-emacs-throw-error-while-loading-shared-libraries-libti
    rm -v ${DOTFILES_LIB}/libtinfo.so.6
    ln -s `readlink -f ${DOTFILES_LIB}/libtinfo.so` `readlink -f ${DOTFILES_LIB}/libtinfo.so | sed 's@libtinfo.so$@libtinfo.so.6@'`
}

function uninstall_package() {
    local version=6.3
    local dirname=ncurses-${version}
    make -C ${DOTFILES_SRC}/${dirname} uninstall
    rm -rvf ${DOTFILES_SRC}/${dirname}
}

