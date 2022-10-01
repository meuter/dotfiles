#! /usr/bin/env bash
set -eo pipefail

BIN=~/.local/bin
SRC=~/.local/src
SHARE=~/.local/share
mkdir -p ${BIN} ${SRC} ${SHARE}

function banner() {
    local white_on_green="\e[97m\e[102m"
    local normal="\e[0m"
    echo
    printf "${white_on_green}------------------------------------------------------------${normal}\n"
    printf "${white_on_green}-- %-57s${normal}\n" "${1}"
    printf "${white_on_green}------------------------------------------------------------${normal}\n"
    echo
}

function add_line_to_file() {
    local file=${1}
    local line=${*:2}
    if ! grep "${line}" "${file}" &>/dev/null; then
        echo "${line}" >>${file}
    fi
}

function initrc() {
    local initrc=~/.bashrc
    add_line_to_file ${initrc} ${1}
    source ${initrc}
}

function install_gnu_stow() {
    banner "Installing GNU/Stow"
    local version=${1-2.3.1}
    local tarball=stow-${version}.tar.gz
    curl -L http://ftp.gnu.org/gnu/stow/${tarball} --output /tmp/${tarball}
    tar xvf /tmp/${tarball} -C ${SRC}/
    pushd .
        cd ${SRC}/stow-${version}/
        ./configure --prefix ~/.local/ && make install
        rm -rf /tmp/${tarball}
    popd
    initrc 'export PERL5LIB=~/.local/share/perl/'
    initrc 'export PATH=~/.local/bin:$PATH'
    export PATH=~/.local/bin:$PATH
    export PERL5LIB=~/.local/share/perl/
}

function install_git_config() {
    banner "Configuring git"
    if [ -f ~/.gitconfig ]; then
        mv -v ~/.gitconfig ~/.gitconfig.bak
    fi
    stow git
    initrc 'alias w="git status -s"'
    initrc 'alias d="git diff"'
    initrc 'alias l="git lol"'
    initrc 'alias g="git lolg"'
}

function install_bash_config() {
    banner "Configuring bash"
    if [ -f ~/.inputrc ]; then
        mv -v ~/.inputrc ~/.inputrc.bak
    fi
    stow bash
    initrc 'export EDITOR=$([ "${TERM_PROGRAM:-unknown}" == "vscode" ] && echo "code --wait" || echo "vim")'
    initrc 'export VISUAL="$EDITOR"'
}

function install_libtree() {
    banner "Installing libtree"
    local version=${1-3.1.0}
    curl -L https://github.com/haampie/libtree/releases/download/v${version}/libtree_x86_64 --output ${BIN}/libtree
    chmod u+x ${BIN}/libtree
    initrc 'export PATH=~/.local/bin:$PATH'
}

function install_starship() {
    banner "Installing starship"
    local version=${1-1.6.2}
    local tarball=starship-x86_64-unknown-linux-musl.tar.gz
    curl -L https://github.com/starship/starship/releases/download/v${version}/${tarball} --output /tmp/${tarball}
    pushd .
        cd ${BIN}
        tar xvf /tmp/${tarball}
        rm -rf /tmp/${tarball}
    popd
    stow starship
    initrc 'eval "$(starship init bash)"'
}


function install_exa() {
    banner "Installing exa"
    local version=${1-0.10.1}
    local zipfile=exa-linux-x86_64-v${version}.zip
    curl -L https://github.com/ogham/exa/releases/download/v${version}/${zipfile} --output /tmp/${zipfile}
    pushd .
        cd ~/.local
        unzip -o /tmp/${zipfile}
        rm -rf /tmp/${zipfile}
    popd
    initrc 'export PATH=~/.local/bin:$PATH'
    initrc 'alias ls=exa'
}

function install_bat() {
    banner "Installing bat"
    local version=${1-0.18.3}
    local tarball=bat-v${version}-x86_64-unknown-linux-musl.tar.gz
    curl -L https://github.com/sharkdp/bat/releases/download/v${version}/${tarball} --output /tmp/${tarball}
    pushd .
        cd /tmp
        tar xvf /tmp/${tarball}
        find /tmp/${tarball%.tar.gz} -name "bat" -type f -exec mv {} ~/.local/bin/ \;
        rm -rf /tmp/${tarball}
    popd
    initrc 'export PATH=~/.local/bin:$PATH'
}

function install_bfs() {
    banner "Installing bfs"
    stow bfs
    initrc 'export PATH=~/.local/bin:$PATH'
}

function install_fzf() {
    banner "Installing fzf"
    local version=${1-0.29.0}
    local tarball=fzf-${version}-linux_amd64.tar.gz
    curl -L https://github.com/junegunn/fzf/releases/download/${version}/${tarball} --output /tmp/${tarball}
    mkdir -pv ${SHARE}/fzf
    curl -L https://raw.githubusercontent.com/junegunn/fzf/${version}/shell/key-bindings.bash --output ${SHARE}/fzf/key-bindings.bash
    pushd .
        cd ${BIN}
        tar xvf /tmp/${tarball}
        rm -rf /tmp/${tarball}
    popd
    initrc 'export PATH=~/.local/bin:$PATH'
    initrc "FZF_ALT_C_COMMAND=\"bfs ~/ -type d -exclude -name '.local' -exclude -name '.cache' -exclude -name '.npm' -exclude -name '.git'\""
    initrc 'source ~/.local/share/fzf/key-bindings.bash'
}

function install_lazygit() {
    banner "Installing lazygit"
    local version=${1-0.34}
    local tarball=lazygit_${version}_Linux_x86_64.tar.gz
    curl -L https://github.com/jesseduffield/lazygit/releases/download/v${version}/${tarball} --output /tmp/${tarball}
    pushd .
        cd ${BIN}
        tar xvf /tmp/${tarball} lazygit
        rm -rf /tmp/${tarball}
    popd
    stow lazygit
    initrc 'export PATH=~/.local/bin:$PATH'
}

function install_nodejs() {
    banner "Installing nodejs"
    local version=${1-16.13.1}
    local tarball=node-v${version}-linux-x64.tar.gz
    curl -L https://nodejs.org/download/release/v${version}/${tarball} --output /tmp/${tarball}
    pushd .
        cd ~/.local
        tar xvf /tmp/${tarball} --strip-components=1 --exclude="*/CHANGELOG.md" --exclude="*/README.md" --exclude="*/LICENSE"
        rm -rf /tmp/${tarball}
    popd
    initrc 'export PATH=~/.local/bin:$PATH'
}

function install_clang() {
    banner "Installing clang"
    local version=${1-14.0.0}
    local tarball=clang+llvm-${version}-x86_64-linux-gnu-ubuntu-18.04.tar.xz
    curl -L https://github.com/llvm/llvm-project/releases/download/llvmorg-${version}/${tarball} --output /tmp/${tarball}
    pushd .
        cd ~/.local
        tar xvf /tmp/${tarball} --strip-components=1
        rm -rf /tmp/${tarball}
    popd
    initrc 'export PATH=~/.local/bin:$PATH'
}

function install_go() {
    banner "Installing go"
    local version=${1-1.18.3}
    local tarball=go${version}.linux-amd64.tar.gz
    curl -L https://go.dev/dl/${tarball} --output /tmp/${tarball}
    pushd .
        tar -C ~/.local -xvf /tmp/${tarball}
        rm -rf /tmp/${tarball}
    popd

    export GOROOT=/home/cme/.local/go
    export GOPATH=/home/cme/.local/go/packages
    export PATH=$GOROOT/bin:$GOPATH/bin:$PATH

    initrc 'export GOROOT=/home/cme/.local/go'
    initrc 'export GOPATH=/home/cme/.local/go/packages'
    initrc 'export PATH=$GOROOT/bin:$GOPATH/bin:$PATH'
}

function install_tmux() {
    banner "Installing libevent (tmux)"
    local libevent_version=2.1.12
    local libevent_name=libevent-${libevent_version}-stable
    local libevent_tarball=${libevent_name}.tar.gz
    curl -L https://github.com/libevent/libevent/releases/download/release-${libevent_version}-stable/${libevent_tarball} --output /tmp/${libevent_tarball}
    pushd .
        cd /tmp/
        tar xvf ${libevent_tarball}
        rm -v ${libevent_tarball}
        cd ${libevent_name}
        ./configure --prefix=${HOME}/.local --enable-shared --disable-openssl
        make -j && make install
        cd ~
        rm -rf /tmp/${libevent_name}
    popd


    banner "Installing ncurses (tmux)"
    local ncurses_version=6.3
    local ncurses_name=ncurses-${ncurses_version}
    local ncurses_tarball=${ncurses_name}.tar.gz
    curl -L https://ftp.gnu.org/pub/gnu/ncurses/${ncurses_tarball} --output /tmp/${ncurses_tarball}
    pushd .
        cd /tmp
        tar xvf ${ncurses_tarball}
        rm -v ${ncurses_tarball}
        cd ${ncurses_name}
        ./configure --prefix=${HOME}/.local --with-shared --with-termlib --enable-pc-files  --with-pkg-config-libdir=${HOME}/.local/lib/pkgconfig
        make -j && make install
        cd ~
        rm -rf /tmp/${ncurses_name}
    popd

    banner "Installing tmux"
    local version=${1-3.3}
    local name=tmux-${version}
    local tarball=${name}.tar.gz
    curl -L https://github.com/tmux/tmux/releases/download/${version}/${tarball} --output /tmp/${tarball}
    pushd .
        cd /tmp
        tar xvf /tmp/${tarball}
        rm -v ${tarball}
        cd ${name}
        ./configure CPPFLAGS="-I/home/cme/.local/include/ -I/home/cme/.local/include/ncurses/" LDFLAGS=-L/home/cme/.local/lib --prefix=/home/cme/.local/
        make -j && make install
        cd ~
        rm -rf ~/.local/lib/libtinfo*
        rm -rf /tmp/${name}
    popd

    stow tmux

    initrc 'export PATH=~/.local/bin:$PATH'
    initrc 'export LD_LIBRARY_PATH=~/.local/lib'
}

function install_rust() {
    banner "Installing rust"
    local script="/tmp/rust_bootstrap.sh"
    curl -L https://sh.rustup.rs --output ${script}
    chmod u+x ${script}
    CARGO_HOME=~/.local/cargo RUSTUP_HOME=~/.local/rustup ${script} -y
    initrc 'export CARGO_HOME=~/.local/cargo'
    initrc 'export RUSTUP_HOME=~/.local/rustup'
    initrc 'source /home/cme/.local/cargo/env'
    export CARGO_HOME=~/.local/cargo
    export RUSTUP_HOME=~/.local/rustup
    source ~/.local/cargo/env
}

function install_ripgrep() {
    banner "Installing ripgrep"
    cargo install ripgrep
}

function install_git_delta() {
    banner "Installing git-delta"
    cargo install git-delta
}

function install_neovim() {
    banner "Installing NeoVIM"
    local version=${1-0.6.1}
    local tarball=nvim-linux64.tar.gz
    curl -L https://github.com/neovim/neovim/releases/download/v${version}/${tarball} --output /tmp/${tarball}
    pushd .
        cd ~/.local
        tar xvf /tmp/${tarball} --strip-components=1
        rm -rf /tmp/${tarball}
    popd
    stow neovim
    initrc 'export PATH=~/.local/bin:$PATH'
    initrc 'alias vim=nvim'

    banner "Installing NeoVim related NodeJS packages"
    npm install -g neovim tree-sitter remark

    banner "Installing NeoVim related Python packages"
    pip install --user neovim debugpy

    banner "Installing NeoVim config"
    nvim --headless -u ~/.config/nvim/install.lua

    # for future reference:
    # local lsp_servers="sumneko_lua tsserver eslint jsonls html yamlls pyright clangd cmake bashls dockerls remark_ls rust_analyzer"
}

function install_component() {
    for component in "$@"; do
        case $1 in
            stow)       install_gnu_stow    2.3.1;;
            libtree)    install_libtree     3.1.0;;
            starship)   install_starship    1.7.1;;
            exa)        install_exa         0.10.1;;
            bat)        install_bat         0.21.0;;
            fzf)        install_fzf         0.30.0;;
            lazygit)    install_lazygit     0.34;;
            nodejs)     install_nodejs      16.15.1;;
            clang)      install_clang       14.0.0;;
            neovim)     install_neovim      0.8.0;;
            go)         install_go          1.18.3;;
            tmux)       install_tmux        3.3;;
            bash)       install_bash_config ;;
            git)        install_git_config  ;;
            bfs)        install_bfs         ;;
            rust)       install_rust        ;;
            ripgrep)    install_ripgrep     ;;
            delta)      install_git_delta   ;;
            all)        install_all         ;;
        esac
        shift
    done
}

function install_all() {
    install_component \
        stow \
        libtree \
        starship \
        exa \
        bat \
        bfs \
        fzf \
        rust \
        ripgrep \
        delta \
        lazygit \
        nodejs \
        clang \
        tmux \
        go \
        neovim \
        bash \
        git
}

install_component $@
