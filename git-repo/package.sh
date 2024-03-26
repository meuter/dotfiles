function install_package() {
    local version=2.45
    local checksum="c55151e3e82c705948d1c114b762c0d5"

    curl https://android.googlesource.com/tools/repo/+/refs/tags/v${version}/repo?format=TEXT | base64 --decode > /tmp/repo-${version}
    if [ "${checksum}" != $(md5sum /tmp/repo-${version} | awk '{print $1}') ]; then
        >&2 echo Unexpected checksum
        return 1
    fi

    mv /tmp/repo-${version} ${DOTFILES_BIN}/repo
    chmod a+rx ${DOTFILES_BIN}/repo
}

function uninstall_package() {
    rm -fv ${DOTFILES_BIN}/repo
}
