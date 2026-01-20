# Homebrew 必须最先定义
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX"

# 将常用的路径拼接到 PATH 前面
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/scripts:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.config/emacs/bin:$PATH"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

# GNU 工具 (替换 macOS 自带的旧工具)
export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/gnu-getopt/bin:$PATH"
export PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/coreutils/bin:$PATH"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

# ------------------------------------------------------------------------------
# 2. 全局变量 (常用工具配置)
# ------------------------------------------------------------------------------

export EDITOR="nvim"
export TERMINAL="ghostty"
export BROWSER="zen"
export LANG="en_US.UTF-8"

# FZF 配置 
export FZF_DEFAULT_OPTS="--layout=reverse --height 40%"

# Yazi 文件管理器
export FILE_MANAGER="yazi"

# ------------------------------------------------------------------------------
# 3. 快速启动工具
# ------------------------------------------------------------------------------

eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"

# ------------------------------------------------------------------------------
# 4. 重型工具懒加载 (Lazy Load)
# ------------------------------------------------------------------------------

# --- NVM (Node) ---
# 只有输入 node/npm 等命令时才加载
zsh_nvm_lazy() {
    unset -f node npm nvm npx pnpm yarn # 移除伪装
    echo "⚡ Loading NVM..."             # 提示一下，让您知道为什么会卡顿一下
    [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && . "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
    "$@"                                # 执行您刚才输入的命令
}

# 伪装函数
node() { zsh_nvm_lazy node "$@"; }
npm()  { zsh_nvm_lazy npm "$@"; }
nvm()  { zsh_nvm_lazy nvm "$@"; }
pnpm() { zsh_nvm_lazy pnpm "$@"; }
yarn() { zsh_nvm_lazy yarn "$@"; }

# --- Pyenv (Python) ---
zsh_pyenv_lazy() {
    unset -f python pip pyenv
    echo "🐍 Loading Pyenv..."
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    "$@"
}

python() { zsh_pyenv_lazy python "$@"; }
pip()    { zsh_pyenv_lazy pip "$@"; }
pyenv()  { zsh_pyenv_lazy pyenv "$@"; }

# --- Conda / Miniconda ---
zsh_conda_lazy() {
    unset -f conda
    echo "🐍 Loading Conda..."
    # 只要 source 它的启动脚本即可
    [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ] && \
        source "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    conda "$@"
}

conda() { zsh_conda_lazy "$@"; }
