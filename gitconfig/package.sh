function dependencies() {
    echo "git-delta"
}

function install_package() {
    ln -sf ${DOTFILES_ROOT}/gitconfig/.gitconfig ${HOME}/.gitconfig
}

function uninstall_package() {
    rm -f ${HOME}/.gitconfig
}

function init_package() {
    alias w="git status -s"
    alias d="git diff"
    alias l="git lol"
    alias g="git lolg"
}

function uninit_package() {
    unalias w
    unalias d
    unalias l
    unalias g
}
