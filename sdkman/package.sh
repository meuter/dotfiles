function install_package() {
    local script="/tmp/sdkman_bootstrap.sh"
    curl -L https://get.sdkman.io/ --output ${script}
    chmod u+x ${script}
    SDKMAN_DIR=${DOTFILES_PREFIX}/sdkman SDKMAN_DIR_RAW=${SDKMAN_DIR} ${script}
}

function uninstall_package() {
    rm -rvf ${DOTFILES_PREFIX}/sdkman
}

function init_package() {
    set +u
    export SDKMAN_DIR=${DOTFILES_PREFIX}/sdkman
    export SDKMAN_DIR_RAW=${DOTFILES_PREFIX}/sdkman
    source ${SDKMAN_DIR}/bin/sdkman-init.sh
}

function uninit_package() {
    unset SDKMAN_CANDIDATES_API
    unset SDKMAN_CANDIDATES_DIR
    unset SDKMAN_DIR
    unset SDKMAN_DIR_RAW
    unset SDKMAN_PLATFORM
}
