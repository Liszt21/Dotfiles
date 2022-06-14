# Enivronment
export PATH=~/.node/bin:~/.roswell/bin:~/.guix-profile/bin:~/.nix-profile/bin:$PATH:~/.local/bin
# export GUIX_PACKAGE_PATH=~/.dotfiles/guix/packages
export GUIX_BUILD_OPTIONS="--substitute-urls=https://mirror.sjtu.edu.cn/guix/"
export GUIX_LOCPATH="$HOME/.guix-profile/lib/locale"
export GPG_TTY=$(tty)
export GIT_SSL_NO_VERIFY=1
# source ~/.clishrc

# Hooks
eval "$(starship init bash)"
eval "$(direnv hook bash)"

# Additional 
if [ -d "$HOME/.nvm" ] ; then 
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

if [ -d "$HOME/.anaconda" ] ;then
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('$HOME/.anaconda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "$HOME/.anaconda/etc/profile.d/conda.sh" ]; then
            . "$HOME/.anaconda/etc/profile.d/conda.sh"
        else
            export PATH="$HOME/.anaconda/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<
fi
