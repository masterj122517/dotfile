## XDG 规范变量
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export GOPATH="$XDG_DATA_HOME/go"

# 基础环境配置
export LANG="en_US.UTF-8"
export EDITOR="nvim"
export TERMINAL="st"
export BROWSER="librewolf-bin"
export FILE_MANAGER="yazi"


# 全局默认开启 NVIDIA 独显渲染与 VA-API 硬解
export __NV_PRIME_RENDER_OFFLOAD=1
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export LIBVA_DRIVER_NAME=nvidia
export NVD_BACKEND=direct
export MOZ_DISABLE_RDD_SANDBOX=1

# 如果当前在第 1 个虚拟终端(TTY1)，且 X 服务没有运行，则自动执行 startx
if [[ -z "$DISPLAY" && "$(tty)" == "/dev/tty1" ]]; then
    exec startx
fi
