#!/usr/bin/env bash

function check() {
    command-exists pacman && {
        PACKAGE_MANAGER="pacman"
    }

    command-exists apt && {
        PACKAGE_MANAGER="apt"
    }

    command-exists yum && {
        PACKAGE_MANAGER="yum"
    }

    echo "Package manager: $PACKAGE_MANAGER"

    [ $http_proxy ] || [ $HTTP_PROXY ] && {
        USE_PROXY=true
        echo "Using proxy $http_proxy$HTTP_PROXY"
    }

    SHELL_NAME=cat /etc/passwd | grep -P '$USER:' | grep -Pho '[a-z]*$'

    RC_FILE="$HOME/.bashrc"
    [ -f "$HOME/.zshrc" ] && {
        RC_FILE="$HOME/.zshrc"
    }
}


function pre-install() {
    echo "pre instal"
    [ $PACKAGE_MANAGER == "pacman" ] && {
        echo "Using pacman"
        MIRROR=`cat /etc/pacman.d/mirrorlist | grep -e "^Server" | awk '{print $3}'`
        command_exists reflector && {
            echo "update mirrorlist"
            reflector --verbose --country China --sort rate --save /etc/pacman.d/mirrorlist
        }
        text-in-file "archlinuxcn" /etc/pacman.conf || {
            echo "  - add archlinuxcn server"
            printf "[archlinuxcn]\nServer = https://mirrors.163.com/archlinux-cn/\$arch" | sudo tee -a /etc/pacman.conf
            sudo pacman -Syy
            sudo pacman -S archlinuxcn-keyring --noconfirm
        }
        sudo pacman -S git wget base-devel --needed --noconfirm
    }

    [ $PACKAGE_MANAGER == "apt" ] && {
        echo "Using apt"
        sudo apt-get install git gcc build-essential libcurl4-openssl-dev automake zlib1g-dev -y
    }

    [ $PACKAGE_MANAGER == "yum" ] && {
        echo "Using yum"
        sudo yum install git gcc autoconf libtool make automake libcurl-devel zlib-devel -y
    }
}


function install() {
    ROSWELL_HOME="$HOME/.roswell"

    [ -d $ROSWELL_HOME ] && {
        echo "Roswell is already installed..."
        return
    }

    echo "Installing roswell..."
    [ ! -d "$HOME/.roswell" ] && {
        echo "Cloning roswell..."
        git clone -b release https://github.com/roswell/roswell.git $HOME/Downloads/roswell
    }
    cd $HOME/Downloads/roswell
    sh bootstrap
    ./configure --prefix=$ROSWELL_HOME
    make
    make install
    cd $OLDPWD
}

function post-install() {
    echo "post install"
}

function remove() {
    echo "remove"
}

function main() {
    echo "Hello $USER!!!"
    check
    [ $1 ] && [ $1 == "remove" ] && {
        remove
        exit
    }
    pre-install
    install
    post-install
}

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

function ln-and-backup() {
    ln -s -b $1 $2
}

function rm-if-exist() {
    [ -e $1 ] && {
        rm -rf $1
    }
}

function command-exists() {
	  command -v "$@" >/dev/null 2>&1
}

main $@
