# This is the branch that sets up my macos


**pacakges install**
```
# Building
brew install automake gcc gdb cmake gnu-getopt gnu-sed node go

# Utils
brew install git rainbarf bat wget tree fzf the_silver_searcher ripgrep fd eza sesh

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

## Zsh

Install shell dependencies separately from the rest of the desktop:

```sh
bash ~/.config/zsh/install.sh
```

The installer adds missing Homebrew tools, installs the declared Zim modules,
and sets up NVM's default Node and the `caniuse` CLI. Existing Node versions and
the global Python environment are preserved. It never runs during shell startup.

- `env.zsh`: edit `environment` for exports and `search_path` for PATH order.
  Every open shell picks up changes at its next prompt, including removed settings.
  Invalid syntax keeps the previous environment.
- `runtime.zsh`: cached direnv/zoxide hooks, lazy NVM, and one-time Python activation.
  Project environments take precedence over base settings.
- `.zshenv` and `environment.zsh`: bootstrap the base environment, including child
  shells that inherit `ZDOTDIR`. `.zprofile` and `.zshrc` can also be sourced directly.
- `aliases.zsh`, `vi.zsh`, `fzf.zsh`, `completion.zsh`, `prompt.zsh`: interactive behavior.
  Run `reload` after editing these files; sourcing `.zshrc` does the same without
  reinitializing plugins. Autosuggestion widgets bind once at the next prompt.
  Open a new shell after changing `runtime.zsh` or `environment.zsh`.
  After changing `.zimrc`, rerun the installer and open a new shell.
- `z` remains zsh-z; `zi` and Ctrl-B remain zoxide.

After editing a project's `.envrc`, authorize it with `direnv allow`.
Shell reloads do not update the environment of already-running programs.
Linux-only package/service helpers require their Linux tools; they are not emulated
on macOS. Chrome bookmark helpers use the existing local Chrome profile.

Run the isolated environment, archive, and picker regression checks with:

```sh
zsh -f ~/.config/zsh/tests/environment.zsh
zsh -f ~/.config/zsh/tests/extract.zsh
zsh -f ~/.config/zsh/tests/fzf.zsh
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
