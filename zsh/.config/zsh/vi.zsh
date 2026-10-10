bindkey -M viins '^v' edit-command-line

bindkey -M vicmd 'k' vi-up-line-or-history
bindkey -M vicmd 'K' vi-up-line-or-history
bindkey -M vicmd 'j' vi-down-line-or-history
bindkey -M vicmd 'J' vi-down-line-or-history
bindkey -M vicmd 'h' vi-backward-char
bindkey -M vicmd 'l' vi-forward-char
bindkey -M vicmd 'n' vi-repeat-search
bindkey -M vicmd 'N' vi-rev-repeat-search

zle-keymap-select() {
  if [[ $KEYMAP == vicmd || $1 == block ]]; then
    print -n '\e[1 q'
  elif [[ $KEYMAP == main || $KEYMAP == viins || -z $KEYMAP || $1 == beam ]]; then
    print -n '\e[5 q'
  fi
}
zle -N zle-keymap-select

_vi_fix_cursor() {
  print -n '\e[5 q'
}

autoload -Uz add-zsh-hook
add-zsh-hook -d preexec _vi_fix_cursor
add-zsh-hook preexec _vi_fix_cursor
add-zsh-hook -d precmd _vi_fix_cursor
add-zsh-hook precmd _vi_fix_cursor
_vi_fix_cursor

KEYTIMEOUT=1

_magic_move() {
  local prefix=${BUFFER%%[^[:space:]]*}
  local first_nonblank=${#prefix}

  if (( CURSOR < first_nonblank )); then
    CURSOR=$first_nonblank
  elif (( CURSOR == first_nonblank )); then
    CURSOR=${#BUFFER}
  else
    CURSOR=0
  fi
}

zle -N _magic_move
bindkey -M vicmd '0' _magic_move

return 0
