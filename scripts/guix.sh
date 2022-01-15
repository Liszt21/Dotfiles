# !/usr/bin/env bash
function command-exists() {
	  command -v "$@" >/dev/null 2>&1
}

function install() {
    command-exists guix && {
        echo "Guix already installed"
        exit
    }
    wget https://git.savannah.gnu.org/cgit/guix.git/plain/etc/guix-install.sh -O /tmp/guix-install.sh
    sudo sh /tmp/guix-install.sh
}

function uninstall() {
    echo "uninstall"
}

case $1 in
    "") install;;
    "install") install;;
    "uninstall") echo "Uninstall";;
    "help") echo "Script for guix";
            echo "  install";
            echo "  uninstall";
            echo "  help";;
esac
