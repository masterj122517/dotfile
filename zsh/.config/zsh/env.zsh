# =============================================================================
# 1. Environment & Globals
# =============================================================================
export LANG="en_US.UTF-8"
export EDITOR="nvim"
export TERMINAL="ghostty"
export BROWSER="google-chrome"
export FILE_MANAGER="yazi"
export FZF_DEFAULT_OPTS="--layout=reverse --height 40%"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk-17.jdk/Contents/Home"

# Homebrew core
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="${HOMEBREW_PREFIX}/Cellar"
export HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}"


export PATH="$HOME/.local/share/cargo/bin/:$PATH"


# =============================================================================
# 2. PATH & FPATH Management (Deduplicated)
# =============================================================================
# Prepend Homebrew site-functions to fpath
[[ -d "${HOMEBREW_PREFIX}/share/zsh/site-functions" ]] && fpath=("${HOMEBREW_PREFIX}/share/zsh/site-functions" $fpath)

# Use Zsh typed arrays for PATH to prevent string parsing and duplication
typeset -U path
path=(
    ~/{.local,go,.ghcup,.config/emacs}/bin
    ~/scripts
    ${HOMEBREW_PREFIX}/opt/{gnu-sed/libexec/gnubin,gnu-getopt/bin,grep/libexec/gnubin,coreutils/bin,llvm/bin,curl/bin}
    ${HOMEBREW_PREFIX}/{bin,sbin}
    $path
)
export PATH

# =============================================================================
# 3. Fast Initialization (Zero-cost Eval Cache)
# =============================================================================
# Replaces blocking `eval "$(cmd init zsh)"` with static file sourcing
_load_cache() {
    local cache_file="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/$1.zsh"
    [[ -f "$cache_file" ]] || { mkdir -p "${cache_file:h}"; "$1" "$2" "$3" > "$cache_file"; }
    source "$cache_file"
}

_load_cache zoxide init zsh
_load_cache direnv hook zsh
unset -f _load_cache # Clean up namespace

# =============================================================================
# 4. Lazy Load Closures (Meta-programming)
# =============================================================================
# Node / NVM
for cmd in node npm nvm npx pnpm yarn; do
    eval "$cmd() { 
        unset -f node npm nvm npx pnpm yarn
        source ${HOMEBREW_PREFIX}/opt/nvm/nvm.sh
        $cmd \"\$@\"
    }"
done

# Python / Pyenv
for cmd in python pip pyenv; do
    eval "$cmd() { 
        unset -f python pip pyenv
        export PATH=\"$HOME/.pyenv/bin:\$PATH\"
        eval \"\$(pyenv init -)\"
        $cmd \"\$@\"
    }"
done

# Conda
conda() { 
    unset -f conda
    source ${HOMEBREW_PREFIX}/Caskroom/miniconda/base/etc/profile.d/conda.sh
    conda "$@"
}

