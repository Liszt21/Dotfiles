# !/usr/bin/env bash
function command-exists() {
	  command -v "$@" >/dev/null 2>&1
}

function install() {
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
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
