#!/bin/zsh -f
setopt err_exit
unset DIRENV_DIR DIRENV_DIFF DIRENV_WATCHES DIRENV_FILE

config_dir=${0:A:h:h}
fixture=$(mktemp -d)
trap 'command rm -rf -- "$fixture"' EXIT
export ZDOTDIR=$fixture
export ZSH_TEST_INHERITED=original
ZSH_TEST_LOCAL=local
path=(/usr/bin /bin)

fail() { print -u2 -- "$1"; exit 1; }

cat > "$fixture/env.zsh" <<'EOF'
environment=(ZSH_TEST_INHERITED changed ZSH_TEST_LOCAL exported ZSH_TEST_NEW first)
search_path=("$ZDOTDIR/first bin")
EOF
source "$config_dir/environment.zsh"
source "$config_dir/runtime.zsh"
[[ $ZSH_TEST_INHERITED == changed && $ZSH_TEST_NEW == first ]] || fail 'Initial environment was not applied'
[[ $path[1] == "$fixture/first bin" ]] || fail 'A path containing spaces was split'
[[ ${(t)ZSH_TEST_LOCAL} == *export* ]] || fail 'Managed variables were not exported'

# Detect same-size edits without relying on file timestamps.
cat > "$fixture/env.zsh" <<'EOF'
environment=(ZSH_TEST_INHERITED changed ZSH_TEST_LOCAL exported ZSH_TEST_NEW other)
search_path=("$ZDOTDIR/other bin")
EOF
_zsh_sync_environment
[[ $ZSH_TEST_NEW == other ]] || fail 'An edit was not picked up'
[[ $path[1] == "$fixture/other bin" && ${path[(Ie)$fixture/first bin]} == 0 ]] || fail 'The previous path was not removed'
path+=("$fixture/manual bin")

cat > "$fixture/env.zsh" <<'EOF'
environment=()
search_path=()
EOF
_zsh_sync_environment
[[ $ZSH_TEST_INHERITED == original ]] || fail 'The inherited value was not restored'
[[ $ZSH_TEST_LOCAL == local && ${(t)ZSH_TEST_LOCAL} != *export* ]] || fail 'The original export flag was not restored'
(( ! ${+ZSH_TEST_NEW} )) || fail 'A removed setting remained defined'
[[ ${path[(Ie)$fixture/other bin]} == 0 && ${path[(Ie)$fixture/manual bin]} != 0 ]] || fail 'Removing configured paths changed an unmanaged path'

print -r -- 'environment=(' > "$fixture/env.zsh"
_zsh_sync_environment 2>/dev/null && fail 'A syntax error was accepted'
[[ $ZSH_TEST_INHERITED == original && ${path[(Ie)$fixture/manual bin]} != 0 ]] || fail 'Invalid configuration changed the environment'

cat > "$fixture/env.zsh" <<'EOF'
environment=(ZSH_TEST_NEW recovered)
search_path=("$ZDOTDIR/recovered bin")
EOF
_zsh_sync_environment
for attempt in {1..5}; do _zsh_load_environment; done
[[ $ZSH_TEST_NEW == recovered && $path[1] == "$fixture/recovered bin" ]] || fail 'A corrected configuration did not recover'
typeset -a unique_path=("${(@u)path}")
(( ${#path} == ${#unique_path} )) || fail 'Repeated reloads duplicated PATH entries'

command ln -s "$config_dir/.zshenv" "$fixture/.zshenv"
command ln -s "$config_dir/environment.zsh" "$fixture/environment.zsh"
child_value=$(ZSH_TEST_NEW=stale /bin/zsh -c 'print -r -- "$ZSH_TEST_NEW"')
[[ $child_value == recovered ]] || fail 'A child shell with inherited ZDOTDIR kept stale settings'

path=("${HOMEBREW_PREFIX:-/opt/homebrew}/bin" $path)
export DIRENV_CONFIG="$fixture/direnv"
command mkdir -p "$fixture/project"
print -r -- 'export ZSH_TEST_NEW=project' > "$fixture/project/.envrc"
command direnv allow "$fixture/project"
(
  builtin cd "$fixture/project"
  eval "$(command direnv export zsh)"
  child_value=$(/bin/zsh -c 'print -r -- "$ZSH_TEST_NEW"')
  [[ $child_value == project ]] || fail 'A child shell replaced the inherited project environment with base settings'
)

print -r -- 'Environment transitions passed.'
