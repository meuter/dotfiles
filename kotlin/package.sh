function dependencies() {
    echo "sdkman"
}

function install_package() {
    set +euxo pipefail
    sdk install kotlin 1.8.20
}

function uninstall_package() {
    set +euxo pipefail
    sdk uninstall --force kotlin 1.8.20
}

function uninit_package() {
    unset KOTLIN_HOME
}
