export PATH=~/.node/bin:~/.roswell/bin:~/.nix-profile/bin:$PATH:~/.local/bin
# export GUIX_PACKAGE_PATH=~/.dotfiles/guix/packages
export GUIX_BUILD_OPTIONS="--substitute-urls=https://mirror.sjtu.edu.cn/guix/"

export GPG_TTY=$(tty)
# source ~/.clishrc
eval "$(starship init bash)"
