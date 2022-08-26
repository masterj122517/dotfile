# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#fi

# Enable colors and change prompt:
autoload -U colors && colors	# Load colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "
setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments


source ~/.zplug/init.zsh

# History config
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE=~/.zsh_history

# zplug plugins
#zplug "romkatv/powerlevel10k", as:theme, depth:1
zplug 'zplug/zplug', hook-build:'zplug --self-manage'
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-autosuggestions"
zplug "zdharma/fast-syntax-highlighting"
zplug "zpm-zsh/ls"
zplug "plugins/docker", from:oh-my-zsh
zplug "plugins/composer", from:oh-my-zsh
zplug "plugins/extract", from:oh-my-zsh
zplug "lib/completion", from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh
#zplug "b4b4r07/enhancd", use:init.sh
zplug "jeffreytse/zsh-vi-mode"
# Install packages that have not been installed yet
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    else
        echo
    fi
fi
zplug load

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# window swallow 
alias vlc='ws vlc'
alias zathura='ws zathura'
alias mpv='ws mpv'



alias ll='exa -al'
alias la='exa -a'
alias pacin='sudo pacman -S'
alias gita='git add'
alias gitc='git commit'
alias ra='ranger'
alias r='ranger'
alias paclean='sudo pacman -Sc'
alias pacu='sudo pacman -Rns'
alias gitp='git push'
alias c='clear'
alias s='neofetch'
alias cat='bat'
alias za='ws zathura'
alias pacman='sudo pacman'
alias v='nvim'
alias locate='plocate'
alias setproxy="export ALL_PROXY=socks5://127.0.0.1:7890"
alias unsetproxy="unset ALL_PROXY"
alias pc="proxychains4"
alias tcn="trans en:zh"
alias ten="trans zh:en"
alias nb='newsboat'
alias pcnb='proxychains4 newsboat'



#set things 
#export BROWSER=/usr/bin/brave
export EDITOR="nvim"
export TERMINAL="alacritty"
export BROWSER="librewolf"
export FILMANAGER=/usr/bin/ranger

