alias ll='eza --all --git --icons --color=always '
alias l='eza -al'
alias ls='eza'
alias gita='git add'
alias gitc='git commit'
 # alias r='yazi'
# alias ra='joshuto'
alias gitp='git push'
alias c='clear'
alias cat='bat'
alias lg='lazygit'
alias cbg='cd /Users/masterj/.local/src/masterj122517.github.io/src/content/blog/'
alias zad='ls -d */ | xargs -I {} zoxide add {}'
alias s='fastfetch'
alias avante='nvim -c "lua vim.defer_fn(function()require(\"avante.api\").zen_mode()end, 100)"'
alias nb='newsboat'
alias tnb='cd ~/.config/newsboat && nvim .'
 alias scp=~/.ssh/scp.sh
 alias ssh=~/.ssh/ssh.sh

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
alias st='sesh-sessions'

function zle_eval {
    echo -en "\e[2K\r"
    eval "$@"
    zle redisplay
}

function openlazygit {
    zle_eval lazygit
}

zle -N openlazygit; bindkey "^G" openlazygit

function r() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}


zkd="zk new daily --no-input"

zkn='zk new --title "$*"'

