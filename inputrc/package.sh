function install_package() {
    ln -sf ${DOTFILES_ROOT}/inputrc/.inputrc ~/.inputrc
}

function uninstall_package() {
    rm -fv ~/.inputrc
}

function init_package() {
    bind -f ~/.inputrc
}
