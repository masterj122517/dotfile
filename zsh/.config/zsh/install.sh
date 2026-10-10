#!/usr/bin/env bash
set -euo pipefail

script_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
config_dir=${ZDOTDIR:-"${XDG_CONFIG_HOME:-$HOME/.config}/zsh"}
if [[ ! -d $config_dir && -f $script_dir/.zimrc ]]; then
    config_dir=$script_dir
fi
zim_home="$config_dir/.zim"
case "$(uname -s)" in
    Darwin)
        platform=darwin
        ;;
    Linux)
        platform=linux
        ;;
    *)
        printf 'Unsupported operating system: %s. Only macOS and Linux are supported.\n' \
            "$(uname -s)" >&2
        exit 1
        ;;
esac

if [[ $platform == darwin ]]; then
    brew_bin=$(command -v brew || true)
    if [[ -z $brew_bin ]]; then
        printf '%s\n' 'Homebrew is required to install macOS Zsh dependencies.' >&2
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

    # Docker's CLI ships its own completions; no Docker installation is required here.
    if command -v docker >/dev/null 2>&1; then
        completion_dir="$("$brew_bin" --prefix)/share/zsh/site-functions"
        mkdir -p "$completion_dir"
        docker completion zsh > "$completion_dir/_docker"
    fi
else
    required_commands=(git curl zsh python3)
    missing=()
    for command_name in "${required_commands[@]}"; do
        command -v "$command_name" >/dev/null 2>&1 || missing+=("$command_name")
    done

    if ((${#missing[@]})); then
        printf 'Missing required Linux dependencies:' >&2
        printf ' %s' "${missing[@]}" >&2
        printf '\nInstall them with the repository root install.sh or your package manager.\n' >&2
        exit 1
    fi

    if ! python3 -c 'import venv' >/dev/null 2>&1; then
        printf '%s\n' \
            'Python venv support is required. Install python3-venv or the equivalent package.' >&2
        exit 1
    fi
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
if [[ $platform == darwin ]]; then
    # shellcheck disable=SC1090,SC1091
    . "$("$brew_bin" --prefix nvm)/nvm.sh"
elif [[ -f $NVM_DIR/nvm.sh ]]; then
    # shellcheck disable=SC1090,SC1091
    . "$NVM_DIR/nvm.sh"
else
    if [[ -e $NVM_DIR || -L $NVM_DIR ]]; then
        printf 'NVM directory exists without nvm.sh: %s. Refusing to replace it.\n' \
            "$NVM_DIR" >&2
        exit 1
    fi

    nvm_installer=$(mktemp "${TMPDIR:-/tmp}/nvm-install.XXXXXX")
    trap 'rm -f "$nvm_installer"' EXIT HUP INT TERM
    curl -fsSL -o "$nvm_installer" \
        https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh
    PROFILE=/dev/null NVM_DIR="$NVM_DIR" bash "$nvm_installer"

    if [[ ! -f $NVM_DIR/nvm.sh ]]; then
        printf 'NVM installation did not create %s/nvm.sh.\n' "$NVM_DIR" >&2
        exit 1
    fi

    # shellcheck disable=SC1090,SC1091
    . "$NVM_DIR/nvm.sh"
fi
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
