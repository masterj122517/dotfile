#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)

usage() {
    printf '%s\n' \
        'Usage: bash install.sh' \
        'Install dependencies, link dotfiles into your home directory with GNU Stow, and install Zsh/Tmux plugins.' \
        'macOS: install Homebrew if needed, then apply Brewfile.' \
        'Linux: install core tools with apt-get, dnf, or pacman; skip macOS-only configs.' \
        'Existing conflicting files are never overwritten. Run as your normal user, not with sudo.'
}

if [[ ${1:-} == --help || ${1:-} == -h ]]; then
    usage
    exit 0
fi
if (($#)); then
    usage >&2
    exit 1
fi

os=$(uname -s)
case $os in
    Darwin|Linux) ;;
    *) printf 'Unsupported OS: %s\n' "$os" >&2; exit 1 ;;
esac
if ((EUID == 0)); then
    printf '%s\n' 'Run this installer as your normal user; it uses sudo only for Linux packages.' >&2
    exit 1
fi

work_dir=$(mktemp -d)
tmux_socket=
cleanup() {
    if [[ -n $tmux_socket ]]; then
        tmux -L "$tmux_socket" kill-server >/dev/null 2>&1 || true
    fi
    rm -rf -- "$work_dir"
}
trap cleanup EXIT

if [[ $os == Darwin ]]; then
    if ! command -v brew >/dev/null 2>&1; then
        if [[ -x /opt/homebrew/bin/brew ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [[ -x /usr/local/bin/brew ]]; then
            eval "$(/usr/local/bin/brew shellenv)"
        else
            curl -fsSL -o "$work_dir/homebrew-install.sh" \
                https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
            /bin/bash "$work_dir/homebrew-install.sh"
            if [[ -x /opt/homebrew/bin/brew ]]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
            else
                eval "$(/usr/local/bin/brew shellenv)"
            fi
        fi
    fi
    eval "$(brew shellenv)"
    brew bundle --file="$repo_dir/Brewfile"
    # Zsh may already be supplied by macOS; the Brewfile supplies the other tools.
    if ! command -v zsh >/dev/null 2>&1; then
        brew install zsh
    fi
else
    if ! command -v sudo >/dev/null 2>&1; then
        printf '%s\n' 'sudo is required to install Linux packages.' >&2
        exit 1
    fi
    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update
        sudo apt-get install -y git curl ca-certificates stow zsh tmux python3 python3-venv fzf direnv zoxide neovim ripgrep
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y git curl ca-certificates stow zsh tmux python3 fzf direnv zoxide neovim ripgrep
    elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -Syu --needed --noconfirm git curl ca-certificates stow zsh tmux python fzf direnv zoxide neovim ripgrep
    else
        printf '%s\n' 'Unsupported Linux package manager; supported: apt-get, dnf, pacman.' >&2
        exit 1
    fi
fi

packages=(git ghostty lazygit ripgrep script sesh tmux vim yazi yt-dlp zsh)
if [[ $os == Darwin ]]; then
    packages+=(aerospace karabiner sioyek)
fi

# Check the entire set first: no adoption, deletion, or partial linking on conflicts.
stow --dir="$repo_dir" --target="$HOME" --no-folding --simulate "${packages[@]}"
stow --dir="$repo_dir" --target="$HOME" --no-folding "${packages[@]}"

ZDOTDIR="$HOME/.config/zsh" bash "$repo_dir/zsh/.config/zsh/install.sh"

plugin_dir="$HOME/.config/tmux/plugins"
tpm_dir="$plugin_dir/tpm"
if [[ ! -d $tpm_dir ]]; then
    mkdir -p "$plugin_dir"
    git clone --depth 1 https://github.com/tmux-plugins/tpm.git "$tpm_dir"
fi
if [[ ! -x $tpm_dir/bin/install_plugins ]]; then
    printf 'TPM is incomplete at %s; resolve it and rerun the installer.\n' "$tpm_dir" >&2
    exit 1
fi

# TPM queries a server; use a private one without touching the user's sessions/config.
tmux_socket="dotfiles-install-$$"
tmux -L "$tmux_socket" -f /dev/null new-session -d -s dotfiles-install 'sleep 3600'
tmux -L "$tmux_socket" set-environment -g TMUX_PLUGIN_MANAGER_PATH "$plugin_dir"
socket_path=$(tmux -L "$tmux_socket" display-message -p '#{socket_path}')
TMUX="$socket_path,0,0" XDG_CONFIG_HOME="$HOME/.config" "$tpm_dir/bin/install_plugins"

printf '\nDotfiles installed for %s. Open a new Zsh shell with: zsh\n' "$os"
printf '%s\n' "Your login shell was not changed. Optional: chsh -s \"\$(command -v zsh)\""
