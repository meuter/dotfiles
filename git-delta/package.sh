function install_package() {
    local version=0.16.5
    local tarball=delta-${version}-x86_64-unknown-linux-musl.tar.gz
    local checksum=0a88c858c23149f246addab1403aa98f

    # grab tarball
    curl -L https://github.com/dandavison/delta/releases/download/${version}/${tarball} --output /tmp/${tarball}

    # check tarball
    if [ "${checksum}" != $(md5sum /tmp/${tarball} | awk '{print $1}') ]; then
        >&2 echo Unexpected checksum
        return 1
    fi

    # extract tarball
    tar xvf /tmp/${tarball} -C /tmp

    # install binary
    find /tmp/${tarball%.tar.gz} -name "delta" -type f -exec mv {} ${DOTFILES_BIN}/ \;

    # remove tarball and extracted folder
    rm -vf /tmp/${tarball}
    rm -rvf /tmp/${tarball%.tar.gz}
}

function uninstall_package() {
    # remove binary
    rm -fv ${DOTFILES_BIN}/delta
}

