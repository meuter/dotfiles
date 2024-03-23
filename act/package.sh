function install_package() {
    local version=0.2.60
    local tarball=act_Linux_x86_64.tar.gz
    local checksum=aad2aa29ffe5908610ce82f65c06a53f

    curl -L https://github.com/nektos/act/releases/download/v${version}/${tarball} --output /tmp/${tarball}
    if [ "${checksum}" != $(md5sum /tmp/${tarball} | awk '{print $1}') ]; then
        >&2 echo Unexpected checksum
        return 1
    fi

    mkdir -p /tmp/act-${version}/
    tar xvf /tmp/${tarball} -C /tmp/act-${version}

    find /tmp/act-${version} -name "act" -type f -exec mv {} ${DOTFILES_BIN}/ \;

    rm -rvf \
        /tmp/${tarball} \
        /tmp/act-${version}
}

function uninstall_package() {
    rm -fv ${DOTFILES_BIN}/act
}

