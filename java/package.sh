function dependencies() {
    echo "sdkman"
}

function install_package() {
    set +euxo pipefail
    sdk install java 17.0.10-amzn
}

function uninstall_package() {
    set +euxo pipefail
    sdk uninstall --force java 17.0.10-amzn
}

function uninit_package() {
    unset JAVA_HOME
}
