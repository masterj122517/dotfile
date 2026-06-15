
# 进入 vi 模式
bindkey '^v' edit-command-line
bindkey -v

# 恢复部分默认 vim 键位行为
bindkey -M vicmd "k" vi-up-line-or-history
bindkey -M vicmd "K" vi-up-line-or-history
bindkey -M vicmd "j" vi-down-line-or-history
bindkey -M vicmd "J" vi-down-line-or-history
bindkey -M vicmd "h" vi-backward-char
bindkey -M vicmd "l" vi-forward-char
bindkey -M vicmd "n" vi-repeat-search
bindkey -M vicmd "N" vi-rev-repeat-search

# 选择合适的光标形状
function zle-keymap-select {
	if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
		echo -ne '\e[1 q'  # 块状光标
	elif [[ ${KEYMAP} == main ]] || [[ ${KEYMAP} == viins ]] || [[ ${KEYMAP} = '' ]] || [[ $1 = 'beam' ]]; then
		echo -ne '\e[5 q'  # 光标形状为竖线
  fi
}
zle -N zle-keymap-select

# 启动时使用光标形状为竖线
echo -ne '\e[5 q'

# 每个新提示符时使用光标形状为竖线
preexec() {
	echo -ne '\e[5 q'
}

_fix_cursor() {
	echo -ne '\e[5 q'
}
precmd_functions+=(_fix_cursor)

# 设置 vim 模式下的超时时间
KEYTIMEOUT=1

_magic_move() {
  local line="$BUFFER"
  local cur=$CURSOR
  
  # 找到第一个非空字符的位置
  local head=$(echo "$line" | sed 's/^\s*//' | wc -c)
  head=$(( ${#line} - head + 1 ))
  
  if [[ $cur -lt $head ]]; then
    # 在缩进里 → 跳到第一个非空字符
    CURSOR=$head
  elif [[ $cur -eq $head ]]; then
    # 已在 ^ → 跳到行尾
    CURSOR=${#BUFFER}
  else
    # 已在行尾或其他 → 跳到行首
    CURSOR=0
  fi
}
zle -N _magic_move
bindkey -M vicmd '0' _magic_move
