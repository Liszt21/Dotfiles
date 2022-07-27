# !/usr/bin/env bash
# utilities
function text-in-file() {
    # $1 text
    # $2 file
    [ $1 ] && [ $2 ] && {
        [ ! -e $2 ] && {
            echo "File $2 not exist..."
            exit
        }
        grep "$1" < "$2" >/dev/null 2>&1
    }
}

function command-exists() {
	  command -v "$@" >/dev/null 2>&1
}

function pre-install() {
    command-exists pacman && PACKAGE_MANAGER="pacman"
    command-exists apt && PACKAGE_MANAGER="apt"
    command-exists yum && PACKAGE_MANAGER="yum"

    echo "Package manager: $PACKAGE_MANAGER"

    SHELL_NAME="$(grep < /etc/passwd $USER | grep -Pho '[a-z]*$')"
    case $SHELL_NAME in
        "zsh") RC_FILE="$HOME/.zshrc";;
        *) RC_FILE="$HOME/.bashrc";;
    esac

    echo "pre instal"

    case $PACKAGE_MANAGER in
        "pacman")
            echo "Using pacman"
            command-exists reflector && {
                echo "update mirrorlist"
                reflector --verbose --country China --sort rate --save /etc/pacman.d/mirrorlist
            }
            sudo pacman -S git wget base-devel --needed --noconfirm;;
        "apt")
            echo "Using apt"
            sudo apt-get install git gcc build-essential libcurl4-openssl-dev automake zlib1g-dev -y;;
        "yum")
            echo "Using yum"
            sudo yum install git gcc autoconf libtool make automake libcurl-devel zlib-devel -y
    esac
}

function install() {
    pre-install

    ROSWELL_HOME="$HOME/.roswell"

    [ ! -d "$HOME/.roswell" ] && {
        echo "Cloning roswell..."
        git clone -b release https://github.com/roswell/roswell.git $HOME/Downloads/roswell

        echo "Installing roswell..."
        cd $HOME/Downloads/roswell
        sh bootstrap
        ./configure --prefix=$ROSWELL_HOME
        make
        make install
        cd $OLDPWD
    }

    [ ! -d "$HOME/.dotfiles" ] && {
        echo "Cloning dotfiles"
        git clone https://github.com/Liszt21/Dotfiles ~/.dotfiles
    }

    post-install
}

function post-install() {
    echo "post install"
    text-in-file ".roswell/bin" "$RC_FILE" || {
        echo "add roswell to PATH"
        printf "export PATH=$HOME/.roswell/bin:\$PATH" | tee -a "$RC_FILE"
    }

    export PATH=$HOME/.roswell/bin:$PATH

    ros setup
    ros install Liszt21/Aliya likit clish ust aliya
    ros ~/.dotfiles/scripts/default.lisp setup
}

install
