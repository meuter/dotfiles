function install_package() {
    local version=0.16.5
    local tarball=delta-${version}-x86_64-unknown-linux-musl.tar.gz
    local checksum=0a88c858c23149f246addab1403aa98f

    curl -L https://github.com/dandavison/delta/releases/download/${version}/${tarball} --output /tmp/${tarball}
    if [ "${checksum}" != $(md5sum /tmp/${tarball} | awk '{print $1}') ]; then
        >&2 echo Unexpected checksum
        return 1
    fi

    mkdir -p /tmp/delta-${version}/
    tar xvf /tmp/${tarball} -C /tmp/delta-${version}

    find /tmp/delta-${version} -name "delta" -type f -exec mv {} ${DOTFILES_BIN}/ \;

    rm -rv \
        /tmp/${tarball} \
        /tmp/delta-${version}
}

function uninstall_package() {
    rm -fv ${DOTFILES_BIN}/delta
}

