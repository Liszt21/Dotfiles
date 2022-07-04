source "$HOME/Dotfiles/scripts/kit.sh"

export PATH=~/.node/bin:~/.roswell/bin:~/.local/bin:~/.guix-profile/bin:~/.nix-profile/bin:$PATH
# export GUIX_PACKAGE_PATH=~/.dotfiles/guix/packages
export GUIX_BUILD_OPTIONS="--substitute-urls=https://mirror.sjtu.edu.cn/guix/"
export GUIX_LOCPATH="$HOME/.guix-profile/lib/locale"
export GPG_TTY=$(tty)
export GIT_SSL_NO_VERIFY=1
# source ~/.clishrc

# Hooks
eval "$(starship init bash)"
eval "$(direnv hook bash)"

init-kit-if-not
