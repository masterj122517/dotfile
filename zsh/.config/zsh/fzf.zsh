export FZF_DEFAULT_OPTS='--bind=ctrl-t:top,change:top --bind ctrl-j:down,ctrl-k:up'
#export FZF_DEFAULT_OPTS='--bind ctrl-e:down,ctrl-u:up --preview "[[ $(file --mime {}) =~ binary ]] && echo {} is a binary file || (ccat --color=always {} || highlight -O ansi -l {} || cat {}) 2> /dev/null | head -500"'
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
#export FZF_DEFAULT_COMMAND='fd'
export FZF_COMPLETION_TRIGGER='\'
export FZF_TMUX=1
export FZF_TMUX_HEIGHT='80%'
export fzf_preview_cmd='[[ $(file --mime {}) =~ binary ]] && echo {} is a binary file || (ccat --color=always {} || highlight -O ansi -l {} || cat {}) 2> /dev/null | head -500'

# load tools from ./fzf/
_fzf_fpath=${0:h}/fzf
fpath+=$_fzf_fpath
autoload -U $_fzf_fpath/*(.:t)
unset _fzf_fpath

fzf-redraw-prompt() {
	local precmd
	for precmd in $precmd_functions; do
		$precmd
	done
	zle reset-prompt
}
zle -N fzf-redraw-prompt

zle -N fzf-find-widget
bindkey '^a' fzf-find-widget

# fzf-cd-widget() {
# 	local tokens=(${(z)LBUFFER})
# 	if (( $#tokens <= 1 )); then
# 		zle fzf-find-widget 'only_dir'
# 		if [[ -d $LBUFFER ]]; then
# 			cd $LBUFFER
# 			local ret=$?
# 			LBUFFER=
# 			zle fzf-redraw-prompt
# 			return $ret
# 		fi
# 	fi
# }
# zle -N fzf-cd-widget
# bindkey '^t' fzf-cd-widget
# fzf-cd-widget: 使用 fzf 模糊查找目录并切换
fzf-cd-widget() {
  # 检查 fzf 和 fd 是否存在
  if ! command -v fzf >/dev/null 2>&1; then
    echo "Error: fzf is not installed." >&2
    return 1
  fi
  if ! command -v fd >/dev/null 2>&1; then
    echo "Warning: fd not found, falling back to find." >&2
    local find_cmd="find . -type d -not -path '*/\.*' -not -path './proc/*' -not -path './sys/*' 2>/dev/null"
  else
    local find_cmd="fd --type d --hidden --follow --exclude .git --max-depth 3 . 2>/dev/null"
  fi

  # 检查 LBUFFER 是否为空或仅一个 token
  local tokens=(${(z)LBUFFER})
  if (( $#tokens <= 1 )); then
    # 使用 fzf 查找目录
    local selected_dir=$(
      eval "$find_cmd" | fzf \
        --height 40% \
        --border \
        --tiebreak=index \
        --preview 'tree -C {} | head -n 20' \
        --preview-window right:50%:wrap \
        --query "${LBUFFER##* }" \
        --prompt "Select directory> "
    )

    # 如果选择了目录，切换到该目录
    if [[ -n "$selected_dir" && -d "$selected_dir" ]]; then
      cd "$selected_dir"
      local ret=$?
      LBUFFER=
      zle fzf-redraw-prompt
      return $ret
    fi
  fi
}

# 注册 widget 并绑定到 Ctrl+T
zle -N fzf-cd-widget
bindkey '^t' fzf-cd-widget

fzf-history-widget() {
	local num=$(fhistory $LBUFFER)
	local ret=$?
	if [[ -n $num ]]; then
		zle vi-fetch-history -n $num
	fi
	zle reset-prompt
	return $ret
}
zle -N fzf-history-widget
bindkey '^R' fzf-history-widget

fif() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}

find-in-file() {
	grep --line-buffered --color=never -r "" * | fzf
}
zle -N find-in-file
bindkey '^z' find-in-file


