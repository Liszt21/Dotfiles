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
        Write-Output "Set ENV:HOME = $ENV:HOME"
    }

    if (!$ENV:SCOOP) {
        $ENV:SCOOP = "$ENV:HOME\Scoop"
        [environment]::setEnvironmentVariable('SCOOP', $ENV:SCOOP, 'User')
        Write-Output "Set ENV:SCOOP = $ENV:SCOOP"
    }

    if (!(Test-Command "scoop")) {
        Write-Output "Installing Scoop to $ENV:SCOOP"
        Invoke-Expression (new-object net.webclient).downloadstring('https://get.scoop.sh')
        scoop update

    }
    scoop install git sudo ln
    Write-Output "Add buckets"
    scoop bucket add extras
    scoop bucket add java
    scoop bucket add nerd-fonts
    scoop bucket add dorado https://github.com/chawyehsu/dorado
    scoop bucket add scoopet https://github.com/ivaquero/scoopet

    if (!(Test-Command "ros")) {
        Write-Output "Install roswell"
        scoop install roswell
        ros setup

    }
    ros install Liszt21/Aliya likit clish ust

    if (!(Test-Path "$ENV:HOME/.dotfiles")) {
        Write-Output "Clone Dotfiles"
        git clone https://github.com/Liszt21/Dotfiles "$ENV:HOME/.dotfiles"
    }

    ros ~/.dotfiles/scripts/system.lisp setup
}

install