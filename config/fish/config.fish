set -x GUIX_BUILD_OPTIONS "--substitute-urls=https://mirror.sjtu.edu.cn/guix/"
set -x PATH $PATH ~/.roswell/bin ~/.node/bin ~/.nix-profile/bin

starship init fish | source
