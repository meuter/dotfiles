function install_package() {
    local version=0.24.0
    local tarball=bat-v${version}-x86_64-unknown-linux-musl.tar.gz
    local checksum=2c018f64d8fa1106f51fd021bb074064

    curl -L https://github.com/sharkdp/bat/releases/download/v${version}/${tarball} --output /tmp/${tarball}
    if [ "${checksum}" != $(md5sum /tmp/${tarball} | awk '{print $1}') ]; then
        >&2 echo Unexpected checksum
        return 1
    fi

    mkdir -p /tmp/bat-${version}/
    tar xvf /tmp/${tarball} -C /tmp/bat-${version}

    find /tmp/bat-${version} -name "bat"      -type f -exec mv {} ${DOTFILES_BIN}/ \;
    find /tmp/bat-${version} -name "bat.bash" -type f -exec mv {} ${DOTFILES_COMPLETION}/ \;
    find /tmp/bat-${version} -name "bat.1"    -type f -exec mv {} ${DOTFILES_MAN1} \;

    rm -rv \
        /tmp/${tarball} \
        /tmp/bat-${version}/
}

function uninstall_package() {
    rm -fv \
        ${DOTFILES_BIN}/bat \
        ${DOTFILES_COMPLETION}/bat.bash \
        ${DOTFILES_MAN1}/bat.1
}

function init_package() {
    source ${DOTFILES_COMPLETION}/bat.bash
}
