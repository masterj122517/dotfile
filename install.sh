#!/usr/bin/env bash
set -e

echo "[*] Starting system setup..."

# 1. Install Homebrew if not present
if ! command -v brew >/dev/null 2>&1; then
    echo "[*] Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "[*] Homebrew already installed."
fi

# 2. Install packages using Brewfile
if [ -f "./Brewfile" ]; then
    echo "[*] Installing brew packages from Brewfile..."
    brew bundle --file=./Brewfile
else
    echo "[!] Brewfile not found!"
fi

# 3. Install GNU stow if not installed
if ! command -v stow >/dev/null 2>&1; then
    echo "[*] Installing stow..."
    brew install stow
fi

echo "[*] Stowing dotfiles..."

for dir in */; do
    dir=${dir%/}  # 去掉末尾的 /

    # 跳过不需要 stow 的目录/文件
    case "$dir" in
      .git|Fonts|install.sh|Brewfile|README.md|masterj_rules.yaml|masterj_rules_game.yaml)
        echo "[-] Skipping $dir"
        continue
        ;;
    esac

    echo "[+] Stowing $dir"
    stow --verbose=1 "$dir"
done

echo "[✓] Setup complete!"

