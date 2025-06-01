function install_package() {
    local version=3.14.0
    local tarball=lua-language-server-${version}-linux-x64.tar.gz
    local checksum=f97f4a403909b71a67af0c6f80fd927b

    curl -L --fail https://github.com/LuaLS/lua-language-server/releases/download/${version}/${tarball} --output /tmp/${tarball}
    if [ "${checksum}" != $(md5sum /tmp/${tarball} | awk '{print $1}') ]; then
        >&2 echo Unexpected checksum
        return 1
    fi

    mkdir -pv ${DOTFILES_OPT}/luals
    tar xvf /tmp/${tarball} -C ${DOTFILES_OPT}/luals/
    ln -s ${DOTFILES_OPT}/luals/bin/lua-language-server ${DOTFILES_BIN}/lua-language-server

    rm -v /tmp/${tarball}
}

function uninstall_package() {
    rm -rvf ${DOTFILES_OPT}/luals/
    rm -vf ${DOTFILES_BIN}/lua-language-server
}
