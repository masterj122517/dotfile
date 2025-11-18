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

