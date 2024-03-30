git clone https://github.com/meuter/dotfiles ~/.dotfiles/
echo ". ~/.dotfiles/bootstrap.sh" >> ~/.bashrc
. ~/.dotfiles/bootstrap.sh
dotfiles install "${@:-shell-essential}"
