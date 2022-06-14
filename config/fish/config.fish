set -x GUIX_BUILD_OPTIONS "--substitute-urls=https://mirror.sjtu.edu.cn/guix/"
set -x PATH $PATH ~/.roswell/bin ~/.node/bin ~/.guix-profile/bin ~/.nix-profile/bin ~/.local/bin
set -x GUIX_LOCPATH $HOME/.guix-profile/lib/locale

starship init fish | source
direnv hook fish | source