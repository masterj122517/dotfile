gr() {
  local git_root
  if git_root=$(command git rev-parse --show-toplevel 2>/dev/null) && [[ -d $git_root ]]; then
    builtin cd -- "$git_root"
  else
    print -u2 'Not in a git repository or could not find the git root.'
    return 1
  fi
}

return 0
