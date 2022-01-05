# utilities
function Test-Command($command) {
    $ErrorActionPreference = 'stop'
    try {
        Get-Command $command | Out-Null
        return $true
    }
    catch {
        return $false
    }
}

function install() {
    Write-Output "Installing..."

    if (!$ENV:HOME) {
        $ENV:HOME = "$ENV:HOMEPROFILE"
        [environment]::setEnvironmentVariable('HOME', $ENV:HOME, 'User')
        echo "Set ENV:HOME = $ENV:HOME"
    }

    if (!$ENV:SCOOP) {
        $ENV:SCOOP = "$ENV:HOME\Scoop"
        [environment]::setEnvironmentVariable('SCOOP', $ENV:SCOOP, 'User')
        echo "Set ENV:SCOOP = $ENV:SCOOP"
    }

    if(!(Test-Command "scoop")) {
        echo "Installing Scoop to $ENV:SCOOP"
        Invoke-Expression (new-object net.webclient).downloadstring('https://get.scoop.sh')
        scoop update

    }
    scoop install git sudo ln
    echo "Add buckets"
    scoop bucket add extras
    scoop bucket add java
    scoop bucket add nerd-fonts
    scoop bucket add dorado https://github.com/chawyehsu/dorado
    scoop bucket add scoopet https://github.com/ivaquero/scoopet

    if(!(Test-Command "ros")) {
        echo "Install roswell"
        scoop install roswell
        ros setup

    }
    ros install Liszt21/Clish Liszt21/Likit Liszt21/Ust clish likit ust

    if(!(Test-Path "$ENV:HOME/.dotfiles")) {
        echo "Clone Dotfiles"
        git clone https://github.com/Liszt21/Dotfiles "$ENV:HOME/.dotfiles"
    }

    ros ~/.dotfiles/scripts/system.lisp setup
}

function uninstall() {
    Write-Output "Uninstalling..."
    if (!$INSTALLED) {
        Write-Output "Scoop is not installed"
        exit
    }
}

switch($args[0]) {
    "" {
        install
    }
    "install" {
        install
    }
    "uninstall" {
        uninstall
    }
    "help" {
        echo "Script for windows"
        echo "  install   : install basic tools[scoop, roswell]"
        echo "  uninstall : remove "
        echo "  help      : display this message"
        echo "  ...       : run system.lisp with args [ $args ]"
    }
    Default {
        if(!(Test-Command "ros")) {
            echo "roswell not install, please run with install first"
        }else{
            echo "Eval ros ~/.dotfiles/scripts/system.lisp $args"
            ros ~/.dotfiles/scripts/system.lisp $args
        }
    }
}
