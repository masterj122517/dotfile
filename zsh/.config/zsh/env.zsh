export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/scripts/:$PATH
eval $(/opt/homebrew/bin/brew shellenv)
eval "$(zoxide init zsh)"
export EDITOR="nvim"
export TERMINAL="kitty"
export BROWSER="google-chrome"

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
eval "$(direnv hook zsh)"
