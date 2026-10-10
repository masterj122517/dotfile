alias ll='eza --all --git --icons --color=always'
alias l='eza -al'
alias ls='eza'
alias gita='git add'
alias gitc='git commit'
alias gitp='git push'
alias c='clear'
alias cat='bat'
alias lg='lazygit'
alias cbg='cd /Users/masterj/.local/src/masterj122517.github.io/src/content/blog/'
alias s='fastfetch'
alias avante='nvim -c "lua vim.defer_fn(function()require(\"avante.api\").zen_mode()end, 100)"'
alias nb='newsboat'
alias tnb='cd ~/.config/newsboat && nvim .'
alias zkd='cd ~/TheBrain/ && zk new daily --no-input && cd -'
zkn() { command zk new --title "$*"; }
alias za='open -a Sioyek'
alias pip='uv pip'
alias pip3='uv pip'
alias ctags='/opt/homebrew/bin/ctags'
alias pi='omp'

[[ -f $HOME/.ssh/scp.sh ]] && alias scp="$HOME/.ssh/scp.sh"
[[ -f $HOME/.ssh/ssh.sh ]] && alias ssh="$HOME/.ssh/ssh.sh"

zad() {
  local dir
  for dir in ./*(/N); do
    command zoxide add -- "$dir"
  done
}

sesh-sessions() {
  local session
  session=$({ command sesh list -t -c | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  '; } </dev/tty)
  zle reset-prompt 2>/dev/null || true
  [[ -n $session ]] && command sesh connect -- "$session"
}
alias st='sesh-sessions'

bindkey -M viins -s '^w' '~/.config/tmux/tmux-sessionizer\n'

zle_eval() {
  zle -I
  command "$@"
  zle reset-prompt
}

openlazygit() {
  zle_eval lazygit
}
zle -N openlazygit
bindkey -M viins '^G' openlazygit

r() {
  local tmp cwd exit_code
  tmp=$(mktemp -t 'yazi-cwd.XXXXXX') || return

  {
    command yazi "$@" --cwd-file="$tmp"
    exit_code=$?
    if [[ -r $tmp ]]; then
      IFS= read -r -d '' cwd < "$tmp" || true
      [[ -n $cwd && $cwd != $PWD && -d $cwd ]] && builtin cd -- "$cwd"
    fi
  } always {
    command rm -f -- "$tmp"
  }

  return $exit_code
}

openvi() {
  zle_eval nvim .
}
zle -N openvi
bindkey -M viins '^o' openvi

return 0
