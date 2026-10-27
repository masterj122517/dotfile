export FZF_DEFAULT_OPTS='--bind=ctrl-t:top,change:top --bind=ctrl-j:down,ctrl-k:up'

# Kataware completion semantics; these styles do not change ls/eza or shell syntax.
# Files: #D9E2F2; directories: #9B8CFF; executables: #82D2B2; links: #60D7E8.
# Variables: #F08BC3; aliases/functions: #9B8CFF; other group labels: #A8B7D0.
typeset -a _kataware_completion_colors=(
  'fi=0;38;2;217;226;242'
  'di=1;38;2;155;140;255'
  'ex=1;38;2;130;210;178'
  'ln=0;38;2;96;215;232'
  'or=0;38;2;242;119;139'
  'mi=0;38;2;242;119;139'
  'tw=1;38;2;155;140;255'
  'ow=1;38;2;155;140;255'
  'st=1;38;2;155;140;255'
  '*=0;38;2;217;226;242'
)
zstyle ':completion:*' list-colors "${_kataware_completion_colors[@]}"
zstyle ':completion:*:default' list-colors "${_kataware_completion_colors[@]}"
unset _kataware_completion_colors

# Plain group names let fzf-tab apply its own theme instead of Zim's ANSI colors.
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:*' single-group color
zstyle ':fzf-tab:*' default-color $'\e[38;2;217;226;242m'

# Color non-file groups by meaning, not their position in a changing candidate list.
# Filesystem candidates retain their more specific list-colors styles above.
zstyle -e ':fzf-tab:*' group-colors '
  local group rgb color
  reply=()
  for group in "${_ftb_groups[@]}"; do
    case ${group:l} in
      *parameter*|*variable*|*environment*) rgb="240;139;195" ;;
      *director*) rgb="155;140;255" ;;
      *command*|*executable*) rgb="130;210;178" ;;
      *alias*|*function*|*reserved*) rgb="155;140;255" ;;
      *file*) rgb="217;226;242" ;;
      *) rgb="168;183;208" ;;
    esac
    printf -v color "\033[38;2;%sm" "$rgb"
    reply+=("$color")
  done
  # The installed native helper needs a spare entry after the final group.
  printf -v color "\033[38;2;168;183;208m"
  reply+=("$color")
'

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
