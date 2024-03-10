function install_package() {
    # version info
    local version=2.43
    local checksum="6b75424e1d5d392d4d0fc60ab8d22d86"

    # download
    curl https://android.googlesource.com/tools/repo/+/refs/tags/v${version}/repo?format=TEXT | base64 --decode > /tmp/repo-${version}

    # check download
    if [ "${checksum}" != $(md5sum /tmp/repo-${version} | awk '{print $1}') ]; then
        >&2 echo Unexpected checksum
        return 1
    fi

    # install binary
    mv /tmp/repo-${version} ${DOTFILES_BIN}/repo
    chmod a+rx ${DOTFILES_BIN}/repo
}

function uninstall_package() {
    # remove binary
    rm -fv ${DOTFILES_BIN}/repo
}
