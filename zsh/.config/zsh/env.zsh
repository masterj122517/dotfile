# export PATH=$HOME/.local/bin:$PATH
# export PATH=$HOME/scripts/:$PATH
#
# eval $(/opt/homebrew/bin/brew shellenv)
# eval "$(zoxide init zsh)"
# eval "$(direnv hook zsh)"
#
# export EDITOR="nvim"
# export TERMINAL="ghostty"
# export BROWSER="zen"
#
# # export TERM=xterm-256color
#
# export FILMANAGER=/opt/homebrew/bin/yazi
# # Other program settings:
# export FZF_DEFAULT_OPTS="--layout=reverse --height 40%"
# export LESS=-R
# export LESS_TERMCAP_mb="$(printf '%b' '[1;31m')"
# export LESS_TERMCAP_md="$(printf '%b' '[1;36m')"
# export LESS_TERMCAP_me="$(printf '%b' '[0m')"
# export LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')"
# export LESS_TERMCAP_se="$(printf '%b' '[0m')"
# export LESS_TERMCAP_us="$(printf '%b' '[1;32m')"
# export LESS_TERMCAP_ue="$(printf '%b' '[0m')"
# export LESSOPEN="| /usr/bin/highlight -O ansi %s 2>/dev/null"
#
#
# export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
# # use gnu software
# export PATH=$PATH:/opt/homebrew/opt/llvm/bin
# export PATH="/opt/homebrew/opt/gnu-getopt/bin:$PATH"
# export PATH="/opt/homebrew/opt/gawk/libexec/gnubin:$PATH"
# export PATH="/opt/homebrew/opt/coreutils/bin:$PATH"
# export PATH=$PATH:$HOME/Library/Python/3.9/bin
# # Set up Orb Environement (will pass to the vm ) 
# # export ORBENV=
#
# #setup haskell stack env 
# export PATH="~/.stack/programs/aarch64-osx/ghc-9.8.4/bin:$PATH"
#
# # add $GOPATH/bin to path
#
# export PATH="$GOPATH/bin:$PATH"
#
# # LLVM 
# export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
#
#
# test -e "${ZDOTDIR}/.iterm2_shell_integration.zsh" && source "${ZDOTDIR}/.iterm2_shell_integration.zsh"
#
# # >>> conda initialize >>>
# # !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
#         . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
#     else
#         export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# # <<< conda initialize <<<
# # LLM's api's
# # source $ZDOTDIR/keys.zsh
#
#
# # OPENJDK
# # openjdk 17
# # export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
# export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
#
# # pyenv 
# export PATH="$HOME/.pyenv/bin:$PATH"
# eval "$(pyenv init --path)"
# eval "$(pyenv init -)"
#
#
# # nvm
#   export NVM_DIR="$HOME/.nvm"
#   [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
#
#
# # doom emacs
# export PATH="$HOME/.config/emacs/bin:$PATH"
#
# # grep
# export PATH="$(brew --prefix grep)/libexec/gnubin:$PATH"


# =============================================================================
# OPTIMIZED ENVIRONMENT CONFIGURATION
# Optimized by Gemini for Performance
# =============================================================================

# --- 1. Path & Environment Variables (Hardcoded for Speed) ---
# Sir, I replaced 'brew shellenv' and 'brew --prefix' with static paths.
# Calling brew at startup is a sin against performance.

# Homebrew Base
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"

# Construct PATH strictly (Order matters: Local > Homebrew > System)
# Using Zsh array syntax for cleaner management, then exporting
typeset -U path # Ensure unique entries
path=(
    "$HOME/.local/bin"
    "$HOME/scripts"
    "$HOME/go/bin"                   # GOPATH/bin
    "$HOME/.config/emacs/bin"        # Doom Emacs
    "$HOME/.stack/programs/aarch64-osx/ghc-9.8.4/bin" # Haskell
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
    "/opt/homebrew/opt/gnu-sed/libexec/gnubin"
    "/opt/homebrew/opt/gnu-getopt/bin"
    "/opt/homebrew/opt/gawk/libexec/gnubin"
    "/opt/homebrew/opt/coreutils/bin"
    "/opt/homebrew/opt/grep/libexec/gnubin"  # Replaced $(brew --prefix grep)
    "/opt/homebrew/opt/llvm/bin"
    "/opt/homebrew/opt/openjdk/bin"
    "$path[@]"
)
export PATH

# Other Homebrew Envs
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"

# --- 2. Tool Configuration (Cached) ---

# Editor & Terminal
export EDITOR="nvim"
export TERMINAL="ghostty"
export BROWSER="zen"
export FILMANAGER="/opt/homebrew/bin/yazi"

# FZF & Less
export FZF_DEFAULT_OPTS="--layout=reverse --height 40%"
export LESS=-R
export LESS_TERMCAP_mb=$'\E[1;31m'
export LESS_TERMCAP_md=$'\E[1;36m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_us=$'\E[1;32m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESSOPEN="| /usr/bin/highlight -O ansi %s 2>/dev/null"

# --- 3. Lazy Loading & Caching (The Performance Boosters) ---

# Function to cache initialization scripts
# Sir, this prevents running 'zoxide init' every single time.
_cache_eval() {
    local cmdname=$1
    local cmd_gen=$2
    local cache_file="${XDG_CACHE_HOME:-$HOME/.cache}/${cmdname}_init.zsh"
    
    # Regenerate cache if missing or older than 24 hours
    if [[ ! -f "$cache_file" || $(find "$cache_file" -mtime +1 2>/dev/null) ]]; then
        eval "$cmd_gen" > "$cache_file"
    fi
    source "$cache_file"
}

# Fast Init for Zoxide & Direnv
_cache_eval "zoxide" "zoxide init zsh"
_cache_eval "direnv" "direnv hook zsh"

# --- 4. Runtime Managers (Lazy Loaded) ---

# NVM: Extremely heavy. Only load when necessary.
export NVM_DIR="$HOME/.nvm"
nvm_lazy_load() {
    echo "⚡ Initializing NVM..."
    unset -f node npm nvm npx pnpm yarn
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
    "$@"
}
# Stub functions
node() { nvm_lazy_load node "$@"; }
npm() { nvm_lazy_load npm "$@"; }
nvm() { nvm_lazy_load nvm "$@"; }
npx() { nvm_lazy_load npx "$@"; }
pnpm() { nvm_lazy_load pnpm "$@"; }
yarn() { nvm_lazy_load yarn "$@"; }

# Pyenv: Heavy. Lazy load.
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH" # Add pyenv binary to path immediately
pyenv_lazy_load() {
    echo "🐍 Initializing Pyenv..."
    unset -f python pip pyenv
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
    "$@"
}
python() { pyenv_lazy_load python "$@"; }
pip() { pyenv_lazy_load pip "$@"; }
pyenv() { pyenv_lazy_load pyenv "$@"; }

# Conda: The heaviest. Lazy load.
# Sir, I removed the auto-managed block. This is safer for speed.
conda_lazy_load() {
    echo "🐍 Initializing Conda..."
    unset -f conda
    # Standard Miniconda install path on Apple Silicon
    local conda_sh="/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    if [ -f "$conda_sh" ]; then
        . "$conda_sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
    conda "$@"
}
conda() { conda_lazy_load "$@"; }

# iTerm2 Integration (Fast enough to keep)
test -e "${ZDOTDIR}/.iterm2_shell_integration.zsh" && source "${ZDOTDIR}/.iterm2_shell_integration.zsh"
