function dependencies() {
    echo "clang"
}

function install_package() {
    # version info
    local version=2.1.12
    local dirname=libevent-${version}-stable
    local tarball=${dirname}.tar.gz
    local checksum=b5333f021f880fe76490d8a799cd79f4

    # download tarball
    curl -L https://github.com/libevent/libevent/releases/download/release-${version}-stable/${tarball} --output /tmp/${tarball}

    # check tarball
    if [ "${checksum}" != $(md5sum /tmp/${tarball} | awk '{print $1}') ]; then
        >&2 echo Unexpected checksum
        return 1
    fi

    # extract tarball and remove
    tar xvf /tmp/${tarball} -C ${DOTFILES_SRC}/
    rm -fv /tmp/${tarball}

    # compile and install
    cd ${DOTFILES_SRC}/${dirname}
    CC=clang ./configure --prefix=${DOTFILES_PREFIX} --enable-shared --disable-openssl
    make -j && make install
}

function uninstall_package() {
    # version info
    local version=2.1.12
    local dirname=libevent-${version}-stable

    # uninstall
    make -C ${DOTFILES_SRC}/${dirname} uninstall

    # remove source
    rm -rvf ${DOTFILES_SRC}/${dirname}
}

