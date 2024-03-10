function install_package() {
    local version=14.1.0
    local tarball=ripgrep-${version}-x86_64-unknown-linux-musl.tar.gz
    local checksum=ed206f245868d3df58d37599a811bf54

    curl -L https://github.com/BurntSushi/ripgrep/releases/download/${version}/${tarball} --output /tmp/${tarball}
    if [ "${checksum}" != $(md5sum /tmp/${tarball} | awk '{print $1}') ]; then
        >&2 echo Unexpected checksum
        return 1
    fi

    mkdir -p /tmp/ripgrep-${version}
    tar xvf /tmp/${tarball} -C /tmp/ripgrep-${version}

    find /tmp/ripgrep-${version} -name "rg"      -type f -exec mv {} ${DOTFILES_BIN}/ \;
    find /tmp/ripgrep-${version} -name "rg.bash" -type f -exec mv {} ${DOTFILES_COMPLETION}/ \;
    find /tmp/ripgrep-${version} -name "rg.1"    -type f -exec mv {} ${DOTFILES_MAN1} \;

    rm -v /tmp/${tarball}
    rm -rv /tmp/ripgrep-${version}/
}

function uninstall_package() {
    rm -fv \
        ${DOTFILES_BIN}/rg \
        ${DOTFILES_COMPLETION}/rg.bash \
        ${DOTFILES_MAN1}/rg.1
}

function init_package() {
    source ${DOTFILES_COMPLETION}/rg.bash
}
