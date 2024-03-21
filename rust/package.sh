function install_package() {
    # NOTE: on some machines the /tmp is mounted in noexec
    # see: https://github.com/rust-lang/cargo/issues/4350
    local script=${DOTFILES_TMP}/rust_bootstrap.sh
    curl -L https://sh.rustup.rs --output ${script}
    chmod u+x ${script}
    TMPDIR=${DOTFILES_TMP} CARGO_HOME=${DOTFILES_PREFIX}/cargo RUSTUP_HOME=${DOTFILES_PREFIX}/rustup ${script} -y --no-modify-path
}

function uninstall_package() {
    rustup self uninstall -y
    rm -rvf ${DOTFILES_PREFIX}/cargo ${DOTFILES_PREFIX}/rustup
}

function init_package() {
    export CARGO_HOME=${DOTFILES_PREFIX}/cargo
    export RUSTUP_HOME=${DOTFILES_PREFIX}/rustup
    export TMPDIR=${DOTFILES_TMP}
    source ${CARGO_HOME}/env
}
