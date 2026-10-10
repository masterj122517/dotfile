_zsh_cached_init() {
  local tool=$1 executable=${commands[$1]:A}
  shift
  [[ -x $executable ]] || { print -u2 "zsh: missing $tool; run bash $ZDOTDIR/install.sh"; return 1; }
  local -A info
  zstat -H info "$executable" || return
  local signature="$executable:${info[mtime]}:${info[size]}"
  local cache="$XDG_CACHE_HOME/zsh/$tool.zsh" header
  [[ -r $cache ]] && IFS= read -r header < "$cache"
  if [[ $header != "# $signature" ]]; then
    command mkdir -p "${cache:h}" || return
    local tmp="$cache.$$"
    if { print -r -- "# $signature"; "$executable" "$@"; } >| "$tmp" &&
       command zsh -fn "$tmp"; then
      command mv -f "$tmp" "$cache" || return
    else
      command rm -f "$tmp"
      return 1
    fi
  fi
  source "$cache"
  # A false optional completion check is not a failed hook initialization.
  case $tool in
    zoxide) (( ${+functions[__zoxide_hook]} )) ;;
    direnv) (( ${+functions[_direnv_hook]} )) ;;
  esac
}

_zsh_load_nvm() {
  unfunction node npm npx
  if [[ $OSTYPE == darwin* ]]; then
    source "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
  else
    source "$NVM_DIR/nvm.sh"
  fi
}

_zsh_init_tools() {
  zmodload zsh/stat
  _zsh_cached_init zoxide init zsh || return
  _zsh_cached_init direnv hook zsh || return

  node() { _zsh_load_nvm && node "$@"; }
  npm() { _zsh_load_nvm && npm "$@"; }
  npx() { _zsh_load_nvm && npx "$@"; }

  # Keep an explicitly activated project environment; otherwise use global Python.
  if [[ -z $VIRTUAL_ENV ]]; then
    source "$HOME/.virtualenvs/global/bin/activate" || return
  fi
}

_zsh_source_user_config() {
  local file
  for file in aliases.zsh prompt.zsh plugins/extract/extract.plugin.zsh \
              completion.zsh vi.zsh fzf.zsh functions/cd_git_root.zsh; do
    source "$ZDOTDIR/$file" || return
  done
  (( ${+functions[_zsh_autosuggest_start]} )) && add-zsh-hook precmd _zsh_autosuggest_start
  return 0
}

reload() {
  _zsh_load_environment && _zsh_source_user_config
}

_zsh_sync_environment() {
  local contents=$(<"$ZDOTDIR/env.zsh")
  [[ $contents == $_zsh_env_checked ]] || _zsh_load_environment
}
