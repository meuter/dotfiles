function install_package() {
    # version info
    local version=1.22.0
    local tarball=go${version}.linux-amd64.tar.gz
    local checksum=d712ecc3dad6daf8a99299c205433964

    # download tarball
    curl -L https://go.dev/dl/${tarball} --output /tmp/${tarball}

    # check tarball
    if [ "${checksum}" != $(md5sum /tmp/${tarball} | awk '{print $1}') ]; then
        >&2 echo Unexpected checksum
        return 1
    fi

    # extract tarball
    tar -C ${DOTFILES_PREFIX} -xvf /tmp/${tarball}

    # remove tarball
    rm -rf /tmp/${tarball}
}

function uninstall_package() {
    # remove all installed files
    rm -rvf ${DOTFILES_PREFIX}/go
}

function init_package() {
    # set environment variables
    export GOROOT=${DOTFILES_PREFIX}/go
    export GOPATH=${DOTFILES_PREFIX}/go/packages
    export GOFLAGS=-modcacherw
    export PATH=${GOROOT}/bin:${GOPATH}/bin:${PATH}
}

function uninit_package() {
    # cleanup environment variables
    export PATH=$(echo ${PATH} | tr ":" "\n" | grep -v ${GOROOT}/bin | grep -v ${GOPATH}/bin | tr "\n" ":")
    unset GOROOT
    unset GOPATH
    unset GOFLAGS
}
