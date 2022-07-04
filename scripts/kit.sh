load-conda() {
    if [ -d "$HOME/.anaconda" ];then
    CONDA_HOME="$HOME/.anaconda"
    fi

    if [ -d "$HOME/.miniconda" ];then
    CONDA_HOME="$HOME/.miniconda"
    fi

    if [ -d "$CONDA_HOME" ] ;then
        # >>> conda initialize >>>
        # !! Contents within this block are managed by 'conda init' !!
        __conda_setup="$('$CONDA_HOME/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
        if [ $? -eq 0 ]; then
            eval "$__conda_setup"
        else
            if [ -f "$CONDA_HOME/etc/profile.d/conda.sh" ]; then
                . "$CONDA_HOME/etc/profile.d/conda.sh"
            else
                export PATH="$CONDA_HOME/bin:$PATH"
            fi
        fi
        unset __conda_setup
        # <<< conda initialize <<<
    fi
}

load-nvm () {
    if [ -d "$HOME/.nvm" ] ; then
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
        [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
    fi
}

proxy-on () {
    export HTTP_PROXY=http://127.1:1080
    export HTTPS_PROXY=http://127.1:1080
}

proxy-off () {
    unset HTTP_PROXY
    unset HTTPS_PROXY
}

init-kit () {
    export KIT_LOADED=true
    load-conda
    load-nvm
}

init-kit-if-not () {
    if [ ! $KIT_LOADED ]; then
        init-kit
    fi
}
