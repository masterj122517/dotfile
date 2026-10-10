#!/usr/bin/env bash
set -euo pipefail

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
config_dir=${ZDOTDIR:-"${XDG_CONFIG_HOME:-$HOME/.config}/zsh"}
if [[ ! -d $config_dir && -f $script_dir/.zimrc ]]; then
    config_dir=$script_dir
fi
zim_home="$config_dir/.zim"
brew_bin=$(command -v brew || true)

if [[ -z $brew_bin ]]; then
    printf '%s\n' 'Homebrew is required to install Zsh dependencies.' >&2
    exit 1
fi

formulae=(
    bat coreutils curl direnv eza fastfetch fd fzf git gnu-getopt gnu-sed grep jq
    lazygit llvm lz4 lzip lrzip neovim newsboat nvm openjdk@17 ripgrep rpm
    sesh sevenzip the_silver_searcher tmux tree universal-ctags uv xz yazi
    zk zoxide zstd
)
missing=()
for formula in "${formulae[@]}"; do
    "$brew_bin" list --versions "$formula" >/dev/null 2>&1 || missing+=("$formula")
done

if ((${#missing[@]})); then
    HOMEBREW_NO_AUTO_UPDATE=1 "$brew_bin" install "${missing[@]}"
else
    printf '%s\n' 'Homebrew Zsh dependencies already installed.'
fi

if [[ ! -f $config_dir/.zimrc ]]; then
    printf 'Missing Zim configuration: %s\n' "$config_dir/.zimrc" >&2
    exit 1
fi

if [[ ! -f $zim_home/zimfw.zsh ]]; then
    mkdir -p "$zim_home"
    curl -fsSL --create-dirs -o "$zim_home/zimfw.zsh" \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi

ZDOTDIR="$config_dir" ZIM_HOME="$zim_home" zsh -f "$zim_home/zimfw.zsh" install -q
ZDOTDIR="$config_dir" ZIM_HOME="$zim_home" zsh -f "$zim_home/zimfw.zsh" build -q

if [[ ! -d $HOME/.virtualenvs/global ]]; then
    python3 -m venv "$HOME/.virtualenvs/global"
fi

export NVM_DIR=${NVM_DIR:-$HOME/.nvm}
# shellcheck disable=SC1090
. "$("$brew_bin" --prefix nvm)/nvm.sh"
default_node=$(nvm version default 2>/dev/null || true)
if [[ -z $default_node || $default_node == N/A ]]; then
    nvm install --lts
fi

nvm use default >/dev/null
if ! npm list -g --depth=0 @bramus/caniuse-cli >/dev/null 2>&1; then
    npm install -g @bramus/caniuse-cli
fi

printf 'Zsh dependencies installed from %s. omp remains at %s.\n' \
    "$script_dir" "$(command -v omp || printf 'not found')"
