function dependencies() {
    echo "clang"
}

function install_package() {
    local version=2.1.12
    local dirname=libevent-${version}-stable
    local tarball=${dirname}.tar.gz
    local checksum=b5333f021f880fe76490d8a799cd79f4

    curl -L https://github.com/libevent/libevent/releases/download/release-${version}-stable/${tarball} --output /tmp/${tarball}
    if [ "${checksum}" != $(md5sum /tmp/${tarball} | awk '{print $1}') ]; then
        >&2 echo Unexpected checksum
        return 1
    fi

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

