function install_package() {
    local version=3.1.1
    local checksum=933b52f7c860d98cec173a36cf5c1a56

    curl -L https://github.com/haampie/libtree/releases/download/v${version}/libtree_x86_64 --output /tmp/libtree
    if [ "${checksum}" != $(md5sum /tmp/libtree | awk '{print $1}') ]; then
        >&2 echo Unexpected checksum
        return 1
    fi

    mv /tmp/libtree ${DOTFILES_BIN}/libtree
    chmod u+x ${DOTFILES_BIN}/libtree
}

function uninstall_package() {
    rm -fv ${DOTFILES_BIN}/libtree
}

