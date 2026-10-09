# This is the branch that sets up my macos


**pacakges install**
```
# Building
brew install automake gcc gdb cmake gnu-getopt gnu-sed node go

# Utils
brew install git rainbarf bat ccat wget tree fzf the_silver_searcher ripgrep fd eza sesh

# Apps
brew install tmux neovim jesseduffield/lazygit/lazygit yazi gh  

# Yazi
brew install poppler ffmpeg sevenzip jq starship imagemagick

# casks 
brew install --cask raycast

# change default application 
brew install duti
# find the id of the app
osascript -e 'id of app "zathura"'

duti -s com.pwmt.zathura pdf all


```

# Or you can install all my pacakges 
```bash
brew bundle --file=./Brewfile
```

# When using MiniConda + direnv
```
# 载入 Conda
export CONDA_PREFIX=$(conda info --base)    # 获取conda的基础路径
source $CONDA_PREFIX/etc/profile.d/conda.sh # 加载conda脚本
conda activate AI
```


i use lxgw-wenkai as my chinese font

```
brew install font-lxgw-wenkai
```

## Tmux links

Press `Ctrl+s`, release it, then press `Shift+u` to select a link in an fzf popup.
Lowercase `prefix + u` remains the sesh picker.

- `Enter`: open with the macOS default application.
- `Ctrl+y`: copy the selected URL to the clipboard and close the popup.
- `Esc`: cancel.
- `Ctrl+j` / `Ctrl+k`: navigate using the existing fzf bindings.

The picker scans the current pane and its last 2000 history lines, joins soft
wraps, deduplicates URLs, and includes hidden OSC 8 targets. It requires macOS,
Python 3, fzf, and tmux 3.7+ (`capture-pane -H`). The binding lives in
`tmux/.tmux.conf`; the script is `tmux/.config/tmux/tmux-url-picker.py`.
After configuration changes, reload with `prefix + r`.
