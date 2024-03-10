function install_package() {
    local version=0.47.0
    local tarball=fzf-${version}-linux_amd64.tar.gz
    local checksum=fe457176baedfc23f71c5a35dece2f72

    curl -L https://github.com/junegunn/fzf/releases/download/${version}/${tarball} --output /tmp/${tarball}
    if [ "${checksum}" != $(md5sum /tmp/${tarball} | awk '{print $1}') ]; then
        >&2 echo Unexpected checksum
        return 1
    fi

    mkdir -p /tmp/fzf-${version}
    tar xvf /tmp/${tarball} -C /tmp/fzf-${version}

    find /tmp/fzf-${version} -name "fzf" -type f -exec mv {} ${DOTFILES_BIN}/ \;

    mkdir -pv ${DOTFILES_SHARE}/fzf
    curl -L https://raw.githubusercontent.com/junegunn/fzf/${version}/shell/key-bindings.bash --output ${DOTFILES_SHARE}/fzf/key-bindings.bash

    rm -rf \
        /tmp/${tarball} \
        /tmp/fzf-${version}
}

function uninstall_package() {
    rm -vf ${DOTFILES_BIN}/fzf ${DOTFILES_SHARE}/fzf/key-bindings.bash
}

function init_package() {
    source ${DOTFILES_SHARE}/fzf/key-bindings.bash
}
