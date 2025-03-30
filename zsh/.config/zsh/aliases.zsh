alias ll='eza --all --git --icons --color=always '
alias l='ls -al'
alias gita='git add'
alias gitc='git commit'
alias r='yazi'
alias ra='joshuto'
alias gitp='git push'
alias c='clear'
alias cat='bat'
alias lg='lazygit'
alias cbg='cd ~/.local/blog/MasterJ/source/_posts/'
alias python='python3'
alias zad='ls -d */ | xargs -I {} zoxide add {}'

function sesh-sessions() {
  {
    exec </dev/tty
    exec <&1
    local session
    session=$(sesh list -t -c | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
    zle reset-prompt > /dev/null 2>&1 || true
    [[ -z "$session" ]] && return
    sesh connect $session
  }
}

# zle     -N             sesh-sessions
# bindkey -M emacs '\es' sesh-sessions
# bindkey -M vicmd '\es' sesh-sessions
# bindkey -M viins '\es' sesh-sessions
alias s='sesh-sessions'
