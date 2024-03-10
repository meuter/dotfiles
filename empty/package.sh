#!/bin/false "This script should be sourced in a shell, not executed directly"

# Beware that functions in `bash` cannot be empty so always put
# something between the `{` `}`, like `echo -n`
function dependencies() {
    # This function returns (prints to stdout) the list of packages
    # that should be installed before this package. Note that there
    # are no transitive dependencies here. *ALL* dependencies and
    # their dependencies, and their dependencies, etc. should be
    # specified here.
    #
    # NOTE: this function is optional
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
