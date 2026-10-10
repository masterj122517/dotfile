# Also bootstrap when this file is sourced by an existing shell.
export ZDOTDIR="${${(%):-%N}:a:h}"
(( ${+functions[_zsh_load_environment]} )) || source "$ZDOTDIR/environment.zsh" || return

[[ -o interactive ]] || return

# Reload user settings without rebuilding plugins or reactivating runtimes.
if (( ${+_zsh_initialized} )); then
  reload
  return
fi

bindkey -v
[[ -n $HOMEBREW_PREFIX ]] && fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

source "$ZDOTDIR/runtime.zsh"
_zsh_init_tools || return
source "$ZDOTDIR/plugins.zsh" || return
_zsh_source_user_config || return
_zsh_load_environment || return

autoload -Uz add-zsh-hook
add-zsh-hook precmd _zsh_sync_environment
typeset -g _zsh_initialized=1
