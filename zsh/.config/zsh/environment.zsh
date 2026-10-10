# Keep inherited values so removing a setting also removes its effect.
typeset -gU path fpath
typeset -gA _zsh_env_values _zsh_env_original _zsh_env_flags
typeset -ga _zsh_env_paths
typeset -g _zsh_env_checked

_zsh_load_environment() {
  local config="$ZDOTDIR/env.zsh" contents name
  local -A environment
  local -a search_path
  [[ -r $config ]] || { print -u2 "zsh: cannot read $config"; return 1; }
  contents=$(<$config)
  _zsh_env_checked=$contents
  eval "$contents" || { print -u2 "zsh: keeping the previous environment"; return 1; }

  # Remove the project layer before changing its base, then apply it again.
  local project=${DIRENV_DIR:+${+commands[direnv]}}
  if [[ $project == 1 ]]; then
    local undo
    undo=$(builtin cd -q / && command direnv export zsh) || return
    eval "$undo"
    eval "$contents" || return
  fi

  for name in ${(k)_zsh_env_values}; do
    (( ${+environment[$name]} )) && continue
    if [[ ${(P)name} == ${_zsh_env_values[$name]} ]]; then
      if [[ -z ${_zsh_env_flags[$name]} ]]; then
        unset "$name"
      elif [[ ${_zsh_env_flags[$name]} == *export* ]]; then
        typeset -gx "$name=${_zsh_env_original[$name]}"
      else
        typeset -g +x "$name=${_zsh_env_original[$name]}"
      fi
    fi
    unset "_zsh_env_original[$name]" "_zsh_env_flags[$name]"
  done
  for name in ${(k)environment}; do
    if (( ! ${+_zsh_env_values[$name]} )); then
      _zsh_env_original[$name]=${(P)name}
      _zsh_env_flags[$name]=${(tP)name}
    fi
    typeset -gx "$name=${environment[$name]}"
  done
  _zsh_env_values=("${(@kv)environment}")
  path=("${(@)search_path}" "${(@)path:|_zsh_env_paths}")
  _zsh_env_paths=("${(@)search_path}")
  export PATH
  # Deactivation must not undo later changes to the base PATH.
  if [[ -n $VIRTUAL_ENV && -n $_OLD_VIRTUAL_PATH ]]; then
    local -a virtualenv_path=("$VIRTUAL_ENV/bin")
    local -a inactive_path=("${(@)path:|virtualenv_path}")
    _OLD_VIRTUAL_PATH="${(j.:.)inactive_path}"
  fi
  if [[ $project == 1 ]]; then
    local project_layer
    project_layer=$(command direnv export zsh) || return
    eval "$project_layer"
  fi
  return 0
}

_zsh_load_environment
