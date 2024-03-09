# Introduction

Here lies my _dotfiles_. But these are not ordinary dotfiles. It is more like
an artisanal package manager of sorts. Each "package" is a script that will
install a component locally (in `~/.local`) as well as the corresponding config
`~/.config`.

But why? _you may ask_ 🤔
1. Because I can 🤓.
2. Because I often work remotely on servers where I do not have root access.
   And this package manager is a way to gain back control.
3. Because I always get the exact version I want regardless of the underlying
   distribution / package manager.
4. Because I can restart from scratch by removing `~/.local` and `~/.config`
   and rerun one command to get back to a clean known state.

And why not use [nix](https://nixos.org/) then? because using nix without root access
is a pain in the 🤡, otherwize it would be 🥇.

CAUTION: this is highly experimental! Use are your own risk ⚠

# Installation

Just clone the repo, then source `bootstrap.sh` in your `~/.bashrc`:

```bash
git clone https://github.com/meuter/dotfiles ~/.dotfiles/
echo ". ~/.dotfiles/bootstrap.sh" >> ~/.bashrc
. ~/.dotfiles/bootstrap.sh
```

You then have access to a dedicated `dotfiles` command:

```
❯ dotfiles
Usage:
    dotfiles <command>

Available Commands:
    list                  list available packages
    list_installed        list installed packages
    check                 check all packages
    install               install packages
    uninstall             uninstall packages
    help                  print this help message

Examples:
    dotfiles install neovim tmux
```

# Structure of a Package

```bash
#!/bin/false "This script should be sourced in a shell, not executed directly"

# Beware that functions in `bash` cannot be empty so always put
# something between the `{` `}`, like `echo -n`

function dependencies() {
    # This function returns (prints to stdout) the list of packages
    # that should be installed before this package. Note that there
    # are no transitive dependencies here. *ALL* dependencies and
    # their dependencies, and their dependencies, etc. should be
    # specified here.
    echo ""
}

function install_package() {
    # This function is used to install the package. It will be executed
    # in a dedicated subshell, so no need to be a good citizen here
    # (for the cwd for instance). The subshell in which the function
    # is executed will be configured with `set -eou pipefile`. Therefore
    # if it fails on any command, the execution will halt and
    # an error message will be displayed.
    echo -n
}

function uninstall_package() {
    # This function is used to uninstall the packages. It will be
    # executed in the exact same way as `install_pakage`.
    echo -n
}

function init_package() {
    # This function is used to initialize the package during the
    # bootstrap phase (will be called from ~/.bashrc via bootstrap.sh).
    # This function will also be called directly after installation
    # so that any environment variable is propagated to the next package
    # in the list that will be installed.
    # Beware that this function is executed in the main shell, it should
    # therefore be a good citizen, e.g. not change the cwd.
    echo -n
}

```

# Package Examples

### neovim

```bash
#!/bin/false "This script should be sourced in a shell, not executed directly"

function dependencies() {
    echo "golang rust ripgrep nodejs"
}

function install_package() {
    local version=0.9.5
    local tarball=nvim-linux64.tar.gz
    curl -L https://github.com/neovim/neovim/releases/download/v${version}/${tarball} --output /tmp/${tarball}
    pushd . &> /dev/null
        cd ${DOTFILES_PREFIX}
        tar xvf /tmp/${tarball} --strip-components=1
        rm -rf /tmp/${tarball}
    popd &> /dev/null
    git clone https://github.com/meuter/nvim ${DOTFILES_CONFIG}/nvim
}

function uninstall_package() {
    rm -rvf \
    	${DOTFILES_CONFIG}/nvim/ \
	    ${DOTFILES_SHARE}/nvim/ \
        ${DOTFILES_BIN}/nvim \
        ${DOTFILES_LIB}/nvim \
        ${DOTFILES_MAN}/man1/nvim.1
    rm -vf \
        $(find ${DOTFILES_SHARE} -name "*nvim*")
    unalias vim
}

function init_package() {
    alias vim=nvim
}

```

### zoxide

```bash
#!/bin/false "This script should be sourced in a shell, not executed directly"

function dependencies() {
    echo "rust"
}

function install_package() {
    cargo install zoxide
}

function uninstall_package() {
    cargo uninstall zoxide
}

function init_package() {
    eval "$(zoxide init --cmd cd bash)"
}
```


