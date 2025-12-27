#!/bin/sh

# --- Configuration ---
NVIM_SRC_REPO="https://github.com/neovim/neovim"
NVIM_CONFIG_REPO_HTTPS="https://github.com/masterj122517/nvim.git"
NVIM_CONFIG_REPO_SSH="git@github.com:masterj122517/nvim.git"
INSTALL_DIR="${HOME}/.local/src/nvim_build"
NVIM_CONFIG_DIR="${HOME}/.config/nvim"

echo "BlackSmith is starting to forge your Valyrian Sword (Neovim setup)..."

# ----------------------------------------------------------------------
# 1. Install Dependencies
# ----------------------------------------------------------------------
install_dependencies() {
    echo "Checking for Homebrew (required for dependencies)..."
    if ! command -v brew >/dev/null 2>&1; then
        echo "Error: Homebrew is not installed. Please install it first:"
        echo "/bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi

    echo "Installing Neovim build dependencies (cmake, ninja, gettext, libtool, automake, pkg-config)..."
    brew install cmake ninja gettext libtool automake pkg-config
    
    # Check for 'git' which is also a dependency
    if ! command -v git >/dev/null 2>&1; then
        echo "Error: git is not installed. Please install git."
        exit 1
    fi
}

# ----------------------------------------------------------------------
# 2. Install Neovim from Source
# ----------------------------------------------------------------------
install_nvim() {
    (
        mkdir -p "${HOME}/.local/src"
        echo "Cloning Neovim source code into ${INSTALL_DIR}..."
        if [ -d "$INSTALL_DIR" ]; then
            echo "Removing existing build directory: ${INSTALL_DIR}"
            rm -rf "$INSTALL_DIR"
        fi
        git clone --depth 1 $NVIM_SRC_REPO "$INSTALL_DIR" || { echo "Failed to clone Neovim source."; exit 1; }

        cd "$INSTALL_DIR" || exit 1
        echo "Building Neovim..."
        make CMAKE_BUILD_TYPE=Release
        
        echo "Installing Neovim..."
        # Note: 'sudo make install' is used for a system-wide installation, which requires elevated privileges.
        # If you prefer a local install without sudo, change the build flags (e.g., set CMAKE_INSTALL_PREFIX).
        sudo make install || { echo "Installation failed. You might need to check permissions or set a custom prefix."; exit 1; }
        
        echo "Neovim installation complete (installed to standard system location, e.g., /usr/local/bin)."
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

    # Try SSH first
    echo "Attempting to clone config via SSH: ${NVIM_CONFIG_REPO_SSH}"
    if git clone --depth 1 "$NVIM_CONFIG_REPO_SSH" "$NVIM_CONFIG_DIR"; then
        echo "Successfully cloned config via SSH."
        return 0
    fi
    
    # If SSH fails, try HTTPS
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
install_config

echo "Installation complete. Your Valyrian Sword is forged and ready!"
echo "You can now run 'nvim' (you may need to source your shell profile if /usr/local/bin is not in PATH)."