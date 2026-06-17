# env config
export LANG="en_US.UTF-8"
export EDITOR="nvim"
export TERMINAL="ghostty"
export BROWSER="google-chrome"
export FILE_MANAGER="yazi"
export FZF_DEFAULT_OPTS="--layout=reverse --height 40%"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk-17.jdk/Contents/Home"

export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="${HOMEBREW_PREFIX}/Cellar"
export HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}"
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

export PATH="$HOME/.local/share/cargo/bin:$PATH"

# path
if [[ -d "${HOMEBREW_PREFIX}/share/zsh/site-functions" ]]; then
    fpath=("${HOMEBREW_PREFIX}/share/zsh/site-functions" $fpath)
fi

typeset -U path
path=(
    ~/.local/bin
    ~/go/bin
    ~/.ghcup/bin
    ~/.config/emacs/bin
    ~/scripts
    ${HOMEBREW_PREFIX}/opt/gnu-sed/libexec/gnubin
    ${HOMEBREW_PREFIX}/opt/gnu-getopt/bin
    ${HOMEBREW_PREFIX}/opt/grep/libexec/gnubin
    ${HOMEBREW_PREFIX}/opt/coreutils/bin
    ${HOMEBREW_PREFIX}/opt/llvm/bin
    ${HOMEBREW_PREFIX}/opt/curl/bin
    ${HOMEBREW_PREFIX}/bin
    ${HOMEBREW_PREFIX}/sbin
    $path
)
export PATH

# fast init zoxide direnv...
_load_cache() {
    local cache_file="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/$1.zsh"
    if [[ ! -f "$cache_file" ]]; then
        mkdir -p "${cache_file:h}"
        "$1" "$2" "$3" > "$cache_file"
    fi
    source "$cache_file"
}

_load_cache zoxide init zsh
_load_cache direnv hook zsh
unset -f _load_cache

# lazyload
node() {
    unset -f node npm npx
    source "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh"
    node "$@"
}

npm() {
    unset -f node npm npx
    source "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh"
    npm "$@"
}

npx() {
    unset -f node npm npx
    source "${HOMEBREW_PREFIX}/opt/nvm/nvm.sh"
    npx "$@"
}

# --- Python / Pyenv ---
python() {
    unset -f python pip pyenv
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
    python "$@"
}

pip() {
    unset -f python pip pyenv
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
    pip "$@"
}

pyenv() {
    unset -f python pip pyenv
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
    pyenv "$@"
}

# --- Conda ---
conda() {
    unset -f conda
    source "${HOMEBREW_PREFIX}/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    conda "$@"
}
