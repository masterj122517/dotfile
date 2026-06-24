#!/bin/sh

# --- Configuration ---
NVIM_SRC_REPO="https://github.com/neovim/neovim"
NVIM_CONFIG_REPO_HTTPS="https://github.com/masterj122517/nvim.git"
NVIM_CONFIG_REPO_SSH="git@github.com:masterj122517/nvim.git"
INSTALL_DIR="${HOME}/.local/src/nvim_build"
NVIM_CONFIG_DIR="${HOME}/.config/nvim"

WITH_CONFIG=0

# Parse arguments
for arg in "$@"; do
    case $arg in
        --with-config|-c)
        WITH_CONFIG=1
        shift
        ;;
    esac
done

echo "BlackSmith is starting to forge your Valyrian Sword (Neovim setup)..."

# ----------------------------------------------------------------------
# 1. Install Dependencies
# ----------------------------------------------------------------------
install_dependencies_mac() {
    echo "Detected macOS. Checking for Homebrew..."
    if ! command -v brew >/dev/null 2>&1; then
        echo "Error: Homebrew is not installed."
        exit 1
    fi
    echo "Installing Neovim build dependencies via Homebrew..."
    brew install cmake ninja gettext libtool automake pkg-config unzip curl
}

install_dependencies_arch() {
    echo "Detected Arch Linux."
    echo "Installing Neovim build dependencies via pacman..."
    sudo pacman -S --needed base-devel cmake ninja gettext libtool automake pkgconf unzip curl
}

install_dependencies_debian() {
    echo "Detected Debian-like system."
    echo "Installing Neovim build dependencies via apt..."
    sudo apt-get update
    sudo apt-get install -y build-essential cmake ninja-build gettext libtool automake pkg-config unzip curl
}

install_dependencies_gentoo() {
    echo "Detected Gentoo."
    echo "Installing Neovim build dependencies via emerge..."
    sudo emerge -av --noreplace dev-util/cmake dev-util/ninja sys-devel/gettext sys-devel/libtool sys-devel/automake dev-util/pkgconf app-arch/unzip net-misc/curl
}

install_dependencies() {
    OS="$(uname -s)"
    case "${OS}" in
        Linux*)
            if command -v pacman >/dev/null 2>&1; then
                install_dependencies_arch
            elif command -v apt-get >/dev/null 2>&1; then
                install_dependencies_debian
            elif command -v emerge >/dev/null 2>&1; then
                install_dependencies_gentoo
            else
                echo "Error: Unsupported Linux distribution. Could not find pacman, apt-get, or emerge."
                exit 1
            fi
            ;;
        Darwin*)
            install_dependencies_mac
            ;;
        *)
            echo "Error: Unsupported OS: ${OS}"
            exit 1
            ;;
    esac

    if ! command -v git >/dev/null 2>&1; then
        echo "Error: git is not installed."
        exit 1
    fi
}

# ----------------------------------------------------------------------
# 2. Install Neovim from Source
# ----------------------------------------------------------------------
install_nvim() {
    (
        mkdir -p "${HOME}/.local/src"
        echo "Cloning/Updating Neovim source code in ${INSTALL_DIR}..."
        
        if [ -d "$INSTALL_DIR" ]; then
            cd "$INSTALL_DIR" || exit 1
            echo "Pulling latest changes..."
            git pull origin master || { echo "Failed to update source."; exit 1; }
        else
            git clone --depth 1 $NVIM_SRC_REPO "$INSTALL_DIR" || { echo "Failed to clone Neovim source."; exit 1; }
            cd "$INSTALL_DIR" || exit 1
        fi

        echo "Building Neovim..."
        make CMAKE_BUILD_TYPE=Release
        
        echo "Installing Neovim..."
        sudo make install || { echo "Installation failed."; exit 1; }
    )
}

# ----------------------------------------------------------------------
# 3. Install Neovim Config
# ----------------------------------------------------------------------
install_config() {
    echo "Setting up Neovim configuration..."

    if [ -d "$NVIM_CONFIG_DIR" ]; then
        echo "Existing Neovim config found at ${NVIM_CONFIG_DIR}. Skipping configuration clone."
        return 0
    fi

    echo "Attempting to clone config via SSH: ${NVIM_CONFIG_REPO_SSH}"
    if git clone --depth 1 "$NVIM_CONFIG_REPO_SSH" "$NVIM_CONFIG_DIR"; then
        echo "Successfully cloned config via SSH."
        return 0
    fi
    
    echo "SSH clone failed. Attempting to clone config via HTTPS: ${NVIM_CONFIG_REPO_HTTPS}"
    if git clone --depth 1 "$NVIM_CONFIG_REPO_HTTPS" "$NVIM_CONFIG_DIR"; then
        echo "Successfully cloned config via HTTPS."
        return 0
    fi

    echo "Error: Failed to clone Neovim configuration using both SSH and HTTPS."
    exit 1
}

# ----------------------------------------------------------------------
# 4. Main Execution
# ----------------------------------------------------------------------

install_dependencies
install_nvim

if [ "$WITH_CONFIG" -eq 1 ]; then
    install_config
else
    echo "Skipping config installation. Use '--with-config' or '-c' to install config."
fi

echo "Installation/Update complete."
