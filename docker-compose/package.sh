function install_package() {
    local version=2.24.7
    local binary=docker-compose-linux-x86_64
    local checksum="a24c26e39af438437c8d664f109f8456"

    curl -SL https://github.com/docker/compose/releases/download/v${version}/${binary} \
        --output /tmp/${binary}

    if [ "${checksum}" != $(md5sum /tmp/${binary} | awk '{print $1}') ]; then
        >&2 echo Unexpected checksum
        return 1
    fi

    mv -v /tmp/${binary} ${DOTFILES_BIN}/docker-compose
    chmod a+x ${DOTFILES_BIN}/docker-compose
}

function uninstall_package() {
    rm -vf ${DOTFILES_BIN}/docker-compose
}

function init_package() {
    alias dc="docker-compose"
    export PUID=$(id -u)
    export GUID=$(id -g)
}

function uninit_package() {
    unalias dc
    unset PUID
    unset GUID
}

