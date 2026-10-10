#!/bin/zsh -f
setopt err_exit

config_dir=${0:A:h:h}
path=("${HOMEBREW_PREFIX:-/opt/homebrew}/opt/llvm/bin" $path)
fixture=$(mktemp -d)
trap 'command rm -rf -- "$fixture"' EXIT
source "$config_dir/plugins/extract/extract.plugin.zsh"

fail() { print -u2 -- "$1"; exit 1; }
command mkdir -p "$fixture/input" "$fixture/output"
print -r -- 'archive payload' > "$fixture/input/file with spaces.txt"
command tar -czf "$fixture/archive one.tar.gz" -C "$fixture/input" 'file with spaces.txt'
(builtin cd "$fixture/input" && command zip -q "$fixture/archive two.zip" 'file with spaces.txt')
builtin cd "$fixture/output"
original_pwd=$PWD

extract "$fixture/archive one.tar.gz"
[[ $(<'file with spaces.txt') == 'archive payload' && $PWD == $original_pwd ]] || fail 'Tar extraction changed content or cwd'
[[ -f "$fixture/archive one.tar.gz" ]] || fail 'Extraction removed an archive without -r'
extract -r "$fixture/archive two.zip"
[[ $(<'archive two/file with spaces.txt') == 'archive payload' && $PWD == $original_pwd ]] || fail 'Zip extraction lost a space-containing path'
[[ ! -e "$fixture/archive two.zip" ]] || fail '-r did not remove the successfully extracted archive'

extract "$fixture/missing.tar" "$fixture/archive one.tar.gz" 2>/dev/null && fail 'A later success concealed an earlier failure'
print -r -- 'not an archive' > "$fixture/broken.zip"
extract -r "$fixture/broken.zip" >/dev/null 2>&1 && fail 'Invalid input was reported as successful'
[[ -f "$fixture/broken.zip" && $PWD == $original_pwd ]] || fail 'Failed extraction removed input or changed cwd'
extract -r >/dev/null 2>&1 && fail 'An option without an archive was accepted'

command mkdir -p "$fixture/control-input"
print -r -- 'package control' > "$fixture/control-input/control"
print -r -- '2.0' > "$fixture/debian-binary"
command tar -cf "$fixture/control.tar" -C "$fixture/control-input" control
command tar -cf "$fixture/data.tar" -C "$fixture/input" 'file with spaces.txt'
command xz "$fixture/control.tar" "$fixture/data.tar"
(builtin cd "$fixture" &&
  command llvm-ar --format=gnu rc 'package with spaces.deb' debian-binary control.tar.xz data.tar.xz)
extract "$fixture/package with spaces.deb"
[[ $(<'package with spaces/control/control') == 'package control' &&
   $(<'package with spaces/data/file with spaces.txt') == 'archive payload' &&
   $PWD == $original_pwd ]] || fail 'GNU Debian extraction lost content or changed cwd'

print -r -- 'Archive transitions passed.'
