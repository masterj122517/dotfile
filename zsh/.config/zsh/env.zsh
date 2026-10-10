# Base settings only; environment.zsh applies and reloads these two collections.
local config_home="$HOME/.config"
local data_home="$HOME/.local/share"
local cache_home="$HOME/.cache"
local brew_prefix
if [[ $OSTYPE == darwin* ]]; then
  brew_prefix=$HOMEBREW_PREFIX
  if [[ -z $brew_prefix ]]; then
    if [[ -d /opt/homebrew ]]; then
      brew_prefix=/opt/homebrew
    elif [[ -d /usr/local ]]; then
      brew_prefix=/usr/local
    fi
  fi
fi

environment=(
  XDG_CONFIG_HOME "$config_home"
  XDG_DATA_HOME "$data_home"
  XDG_CACHE_HOME "$cache_home"
  CARGO_HOME "$data_home/cargo"
  GOPATH "$data_home/go"
  LANG en_US.UTF-8
  EDITOR nvim
  TERMINAL ghostty
  BROWSER google-chrome
  FILE_MANAGER yazi
  RIPGREP_CONFIG_PATH "$HOME/.ripgreprc"
  NVM_DIR "$HOME/.nvm"
)
if [[ -n $brew_prefix ]]; then
  environment+=(
    JAVA_HOME "$brew_prefix/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"
    HOMEBREW_PREFIX "$brew_prefix"
    HOMEBREW_CELLAR "$brew_prefix/Cellar"
    HOMEBREW_REPOSITORY "$brew_prefix"
  )
fi
[[ -n $XDG_RUNTIME_DIR ]] && environment[TMUX_TMPDIR]=$XDG_RUNTIME_DIR

search_path=(
  ${NVM_BIN:+"$NVM_BIN"}
)
[[ -n $brew_prefix ]] && search_path+=("$brew_prefix/opt/curl/bin")
search_path+=(
  "$cache_home/.bun/bin"
  ${VIRTUAL_ENV:+"$VIRTUAL_ENV/bin"}
  "$HOME/.local/bin"
  "$data_home/cargo/bin"
  "$data_home/go/bin"
  "$HOME/go/bin"
  "$HOME/.local/src/cross/bin"
  "$HOME/.ghcup/bin"
  "$config_home/emacs/bin"
  "$HOME/scripts"
)
if [[ -n $brew_prefix ]]; then
  search_path+=(
    "$brew_prefix/opt/gnu-sed/libexec/gnubin"
    "$brew_prefix/opt/gnu-getopt/bin"
    "$brew_prefix/opt/grep/libexec/gnubin"
    "$brew_prefix/opt/coreutils/bin"
    "$brew_prefix/opt/llvm/bin"
    "$brew_prefix/bin"
    "$brew_prefix/sbin"
  )
fi
