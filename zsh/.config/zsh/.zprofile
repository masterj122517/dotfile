export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"


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
export PATH="$HOME/.local/src/cross/bin:$PATH"


