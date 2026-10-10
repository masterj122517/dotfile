#!/bin/zsh -f
setopt err_exit

config_dir=${0:A:h:h}
fixture=$(mktemp -d)
trap 'command rm -rf -- "$fixture"' EXIT
path=(/opt/homebrew/bin $path)
fpath=("$config_dir/fzf" $fpath)
autoload -U fhistory ffind fps kp ks _fzf_expand_path

fail() { print -u2 -- "$1"; exit 1; }
print -s -- 'echo OMP_HISTORY_REGRESSION'
event=$(FZF_DEFAULT_OPTS='--filter=OMP_HISTORY_REGRESSION' fhistory '')
[[ $event == <-> ]] || fail 'History selection did not return an event number'
[[ $(fc -ln "$event" "$event") == 'echo OMP_HISTORY_REGRESSION' ]] || fail 'History selection returned a different command'

export ZSH_TEST_DIRECTORY="$fixture/directory with spaces"
_fzf_expand_path '$ZSH_TEST_DIRECTORY/child'
[[ $REPLY == "$ZSH_TEST_DIRECTORY/child" ]] || fail 'Environment-variable paths were not expanded'
_fzf_expand_path "'$ZSH_TEST_DIRECTORY/child'"
[[ $REPLY == "$ZSH_TEST_DIRECTORY/child" ]] || fail 'Quoted paths were not expanded'
_fzf_expand_path '~/child'
[[ $REPLY == "$HOME/child" ]] || fail 'Home-relative paths were not expanded'

# An anchored full-row query cannot match a process table row.
export FZF_DEFAULT_OPTS='--filter=^OMP_NO_MATCH_EXACT_ROW$'
for picker in fps kp ks; do
  output=$("$picker") && fail "$picker accepted an empty selection"
  [[ -z $output ]] || fail "$picker emitted a selection after cancellation"
done
output=$(ffind -s "$fixture") && fail 'File selection accepted an empty result'
[[ -z $output ]] || fail 'Cancelled file selection emitted an empty filename'
print -r -- 'History and picker transitions passed.'
