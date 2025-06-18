export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/scripts/:$PATH

eval $(/opt/homebrew/bin/brew shellenv)
eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"

export EDITOR="nvim"
export TERMINAL="ghostty"
export BROWSER="zen"

export TERM=xterm-256color

export FILMANAGER=/opt/homebrew/bin/yazi
# Other program settings:
export FZF_DEFAULT_OPTS="--layout=reverse --height 40%"
export LESS=-R
export LESS_TERMCAP_mb="$(printf '%b' '[1;31m')"
export LESS_TERMCAP_md="$(printf '%b' '[1;36m')"
export LESS_TERMCAP_me="$(printf '%b' '[0m')"
export LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')"
export LESS_TERMCAP_se="$(printf '%b' '[0m')"
export LESS_TERMCAP_us="$(printf '%b' '[1;32m')"
export LESS_TERMCAP_ue="$(printf '%b' '[0m')"
export LESSOPEN="| /usr/bin/highlight -O ansi %s 2>/dev/null"


export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
# use gnu software
export PATH=$PATH:/opt/homebrew/opt/llvm/bin
export PATH="/opt/homebrew/opt/gnu-getopt/bin:$PATH"
export PATH="/opt/homebrew/opt/gawk/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/coreutils/bin:$PATH"
export PATH=$PATH:$HOME/Library/Python/3.9/bin
# Set up Orb Environement (will pass to the vm ) 
# export ORBENV=

#setup haskell stack env 
export PATH="~/.stack/programs/aarch64-osx/ghc-9.8.4/bin:$PATH"

# add $GOPATH/bin to path

export PATH="$GOPATH/bin:$PATH"

# LLVM 
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"


test -e "${ZDOTDIR}/.iterm2_shell_integration.zsh" && source "${ZDOTDIR}/.iterm2_shell_integration.zsh"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
# LLM's api's
# source $ZDOTDIR/keys.zsh
