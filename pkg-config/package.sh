function dependencies() {
    echo "clang"
}

function install_package() {
    local version=0.28
    local dirname=pkg-config-${version}
    local tarball=${dirname}.tar.gz
    local checksum=aa3c86e67551adc3ac865160e34a2a0d

    curl -L https://pkgconfig.freedesktop.org/releases/${tarball} --output /tmp/${tarball}
    if [ "${checksum}" != $(md5sum /tmp/${tarball} | awk '{print $1}') ]; then
        >&2 echo Unexpected checksum
        return 1
    fi

    tar xvf /tmp/${tarball} -C ${DOTFILES_SRC}/
    rm -fv /tmp/${tarball}

    cd ${DOTFILES_SRC}/${dirname}
    CC=clang CFLAGS=-Wno-int-conversion ./configure --prefix=${DOTFILES_PREFIX} --with-internal-glib
    make -j && make install
}

function uninstall_package() {
    local version=0.28
    local dirname=pkg-config-${version}
    make -C ${DOTFILES_SRC}/${dirname} uninstall
    rm -rvf ${DOTFILES_SRC}/${dirname}
}

