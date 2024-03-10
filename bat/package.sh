function install_package() {
    # version info
    local version=0.24.0
    local tarball=bat-v${version}-x86_64-unknown-linux-musl.tar.gz
    local checksum=2c018f64d8fa1106f51fd021bb074064

    # grab tarball
    curl -L https://github.com/sharkdp/bat/releases/download/v${version}/${tarball} --output /tmp/${tarball}

    # check tarball
    if [ "${checksum}" != $(md5sum /tmp/${tarball} | awk '{print $1}') ]; then
        >&2 echo Unexpected checksum
        return 1
    fi

    # extract tarball
    tar xvf /tmp/${tarball} -C /tmp

    # install content
    find /tmp/${tarball%.tar.gz} -name "bat" -type f -exec mv {} ${DOTFILES_BIN}/ \;
    find /tmp/${tarball%.tar.gz} -name "bat.bash" -type f -exec mv {} ${DOTFILES_COMPLETION}/ \;
    find /tmp/${tarball%.tar.gz} -name "bat.1" -type f -exec mv {} ${DOTFILES_MAN1} \;

    # cleanup tarball and extracted archive
    rm -v /tmp/${tarball}
    rm -rv /tmp/${tarball%.tar.gz}
}

function uninstall_package() {
    # remove installed files
    rm -fv \
        ${DOTFILES_BIN}/bat \
        ${DOTFILES_COMPLETION}/bat.bash \
        ${DOTFILES_MAN1}/bat.1
}

function init_package() {
    source ${DOTFILES_COMPLETION}/bat.bash
}
