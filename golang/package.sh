function install_package() {
    local version=1.22.0
    local tarball=go${version}.linux-amd64.tar.gz
    local checksum=d712ecc3dad6daf8a99299c205433964

    curl -L https://go.dev/dl/${tarball} --output /tmp/${tarball}
    if [ "${checksum}" != $(md5sum /tmp/${tarball} | awk '{print $1}') ]; then
        >&2 echo Unexpected checksum
        return 1
    fi

    tar -C ${DOTFILES_PREFIX} -xvf /tmp/${tarball}
    rm -rf /tmp/${tarball}
}

function uninstall_package() {
    rm -rvf ${DOTFILES_PREFIX}/go
}

function init_package() {
    export GOROOT=${DOTFILES_PREFIX}/go
    export GOPATH=${DOTFILES_PREFIX}/go/packages
    export GOFLAGS=-modcacherw
    export PATH=${GOROOT}/bin:${GOPATH}/bin:${PATH}
}

function uninit_package() {
    export PATH=$(echo ${PATH} | tr ":" "\n" | grep -v ${GOROOT}/bin | grep -v ${GOPATH}/bin | tr "\n" ":")
    unset GOROOT
    unset GOPATH
    unset GOFLAGS
}
