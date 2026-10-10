export FZF_DEFAULT_OPTS='--bind=ctrl-t:top,change:top --bind=ctrl-j:down,ctrl-k:up
--color=bg+:#313244,bg:-1,spinner:#F5E0DC,hl:#F38BA8
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8
--color=selected-bg:#45475A
--color=border:#6C7086,label:#CDD6F4'
if (( $+commands[rg] )); then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
elif (( $+commands[ag] )); then
  export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
else
  export FZF_DEFAULT_COMMAND='find . -path "*/.git" -prune -o -type f -print'
fi
export FZF_COMPLETION_TRIGGER='\'
export FZF_TMUX=1
export FZF_TMUX_HEIGHT='80%'
export fzf_preview_cmd='bat --color=always --style=plain -- {} 2>/dev/null || eza --tree --level=1 --color=always -- {}'

_fzf_fpath=${0:h}/fzf
fpath+=("$_fzf_fpath")
autoload -U "$_fzf_fpath"/*(-.:t)
unset _fzf_fpath

fzf-redraw-prompt() {
  local precmd
  for precmd in $precmd_functions; do
    "$precmd"
  done
  zle reset-prompt
}
zle -N fzf-redraw-prompt

zle -N fzf-find-widget
bindkey -M viins '^a' fzf-find-widget

fzf-cd-widget() {
  local -a tokens
  local selected_dir query
  tokens=(${(z)LBUFFER})
  (( $#tokens <= 1 )) || return
  query=${LBUFFER##* }

  if (( $+commands[fd] )); then
    selected_dir=$(command fd --type d --hidden --follow --exclude .git --max-depth 3 . |
      fzf --height 40% --border --tiebreak=index --preview "$fzf_preview_cmd" \
        --preview-window right:50%:wrap --query "$query" --prompt 'Select directory> ')
  else
    selected_dir=$(command find . -type d -not -path '*/.*' -not -path './proc/*' -not -path './sys/*' 2>/dev/null |
      fzf --height 40% --border --tiebreak=index --preview "$fzf_preview_cmd" \
        --preview-window right:50%:wrap --query "$query" --prompt 'Select directory> ')
  fi

  if [[ -n $selected_dir && -d $selected_dir ]]; then
    builtin cd -- "$selected_dir" || return
    LBUFFER=
    zle fzf-redraw-prompt
  fi
}
zle -N fzf-cd-widget
bindkey -M viins '^t' fzf-cd-widget

fzf-history-widget() {
  local num ret
  num=$(fhistory "$LBUFFER")
  ret=$?
  [[ -n $num ]] && zle vi-fetch-history -n "$num"
  zle reset-prompt
  return $ret
}
zle -N fzf-history-widget
bindkey -M viins '^R' fzf-history-widget

fif() {
  (( $# )) || { print -u2 'Need a string to search for!'; return 1; }
  command rg --files-with-matches --no-messages -- "$1" |
    fzf --preview "$fzf_preview_cmd"
}

fzf-cd-to-parent() {
  local dir selected_dir
  local -a dirs
  dir=${1:-$PWD}
  dir=${dir:A}

  while true; do
    [[ -d $dir ]] || return 1
    dirs+=("$dir")
    [[ $dir == / ]] && break
    dir=${dir:h}
  done

  selected_dir=$(print -rl -- "${dirs[@]}" | fzf-tmux --tac)
  [[ -n $selected_dir && -d $selected_dir ]] || return
  builtin cd -- "$selected_dir" && command eza
}
alias cdp='fzf-cd-to-parent'

fzf-file-widget() {
  local file
  file=$(command rg --files --hidden --glob '!.git' | fzf --preview "$fzf_preview_cmd")
  [[ -n $file ]] && command nvim -- "$file"
  zle reset-prompt
}
zle -N fzf-file-widget
bindkey -M viins '^f' fzf-file-widget

fgp() {
  local query=${1:-} result file line rest
  result=$(command rg --line-number --no-heading --color=always -- "${query:-.}" . | fzf --ansi \
    --delimiter : \
    --preview 'bat --style=numbers --color=always --highlight-line {2} -- {1}' \
    --preview-window 'up,60%,border-bottom,+{2}+3/3')
  [[ -n $result ]] || return
  file=${result%%:*}
  rest=${result#*:}
  line=${rest%%:*}
  command nvim "+$line" -- "$file"
}

fzf-grep-widget() {
  local result file line rest
  result=$(fzf --ansi --disabled \
    --bind 'start:reload:rg --line-number --no-heading --color=always --smart-case . || true' \
    --bind 'change:reload:sleep 0.1; rg --line-number --no-heading --color=always --smart-case {q} . || true' \
    --delimiter : \
    --preview 'bat --style=numbers --color=always --highlight-line {2} -- {1}' \
    --preview-window 'up,60%,border-bottom,+{2}+3/3')
  if [[ -n $result ]]; then
    file=${result%%:*}
    rest=${result#*:}
    line=${rest%%:*}
    command nvim "+$line" -- "$file"
  fi
  zle reset-prompt
}
zle -N fzf-grep-widget
bindkey -M viins '^_' fzf-grep-widget

bindkey -M viins -s '^b' 'zi\n'

return 0
