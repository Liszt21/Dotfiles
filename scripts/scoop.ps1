function check() {
    Write-Output "Checking..."

    if (!$ENV:HOME) {
        $ENV:HOME = "C:\Users\$ENV:USERNAME" # 默认盘符
        [environment]::setEnvironmentVariable('HOME', $ENV:HOME, 'User')
    }
    
    if (!$ENV:SCOOP) {
        $ENV:SCOOP = "$ENV:HOME\Scoop"
        [environment]::setEnvironmentVariable('SCOOP', $ENV:SCOOP, 'User')
    }
}

function install() {
    Write-Output "Installing..."
    if (!$INSTALLED) {
        Invoke-Expression (new-object net.webclient).downloadstring('https://get.scoop.sh')
        scoop update
    }

    scoop install git sudo ln 

    scoop bucket add extras
    scoop bucket add java  
    scoop bucket add nerd-fonts
    scoop bucket add dorado https://github.com/chawyehsu/dorado
    scoop bucket add scoopet https://github.com/ivaquero/scoopet

    scoop install lxrunoffline fd ripgrep curl make gcc
    scoop install roswell
    if ($ISME) {
        scoop install v2ray v2rayn emacs atom vim vscode yarn julia openjdk
        scoop install googlechrome firefox sumatrapdf potplayer vcxsrv snipaste
        sudo scoop install sarasagothic-sc FiraCode SourceCodePro-NF
    }
}

function uninstall() {
    Write-Output "Uninstalling..."
    if (!$INSTALLED) {
        Write-Output "Scoop is not installed"
        exit
    }
}

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


$ISME = ($ENV:USERNAME -eq 'liszt')
$INSTALLED = (Test-Command scoop)

Write-Output "Hello $ENV:USERNAME"
check
if ($args[0] -eq "uninstall") {
    uninstall
    exit
}
install