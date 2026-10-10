extract() {
  setopt localoptions pipefail
  local archive archive_path extract_dir exit_code result=0 remove_archive=0

  if [[ $1 == -r || $1 == --remove ]]; then
    remove_archive=1
    shift
  fi
  (( $# )) || { print -u2 'Usage: extract [-r|--remove] file [...]'; return 1; }

  for archive in "$@"; do
    if [[ ! -f $archive ]]; then
      print -u2 "extract: '$archive' is not a valid file"
      result=1
      continue
    fi
    archive_path=${archive:A}
    extract_dir=${archive:t:r}
    case ${archive:l} in
      (*.tar|*.tar.gz|*.tgz|*.tar.bz2|*.tbz|*.tbz2|*.tar.xz|*.txz|*.tar.zma|*.tar.lzma|*.tlz|*.tar.zst|*.tzst|*.tar.lz)
        command tar -xvf "$archive"
        ;;
      (*.tar.lz4) command lz4 -c -d -- "$archive" | command tar -xvf - ;;
      (*.tar.lrz) command lrzuntar "$archive" ;;
      (*.gz) command gunzip -k -- "$archive" ;;
      (*.bz2) command bunzip2 -- "$archive" ;;
      (*.xz) command unxz -- "$archive" ;;
      (*.lrz) command lrunzip "$archive" ;;
      (*.lz4) command lz4 -d -- "$archive" ;;
      (*.lzma) command unlzma -- "$archive" ;;
      (*.z) command uncompress -- "$archive" ;;
      (*.zip|*.war|*.jar|*.sublime-package|*.ipsw|*.xpi|*.apk|*.aar|*.whl)
        command unzip -- "$archive" -d "$extract_dir"
        ;;
      (*.rar) command 7zz x "-o$extract_dir" -- "$archive" ;;
      (*.rpm)
        (
          command mkdir -p -- "$extract_dir" &&
            builtin cd -- "$extract_dir" &&
            command rpm2cpio "$archive_path" | command cpio --quiet -id
        )
        ;;
      (*.7z) command 7zz x -- "$archive" ;;
      (*.deb)
        # macOS ar rejects GNU archive member names.
        (
          setopt nullglob
          command mkdir -p -- "$extract_dir/control" "$extract_dir/data" &&
            builtin cd -- "$extract_dir" &&
            command llvm-ar x "$archive_path" || exit
          local -a control_archives=(control.tar.*) data_archives=(data.tar.*)
          (( $#control_archives == 1 && $#data_archives == 1 )) || exit 1
          (builtin cd control && command tar -xvf "../$control_archives[1]") &&
            (builtin cd data && command tar -xvf "../$data_archives[1]") &&
            command rm -f -- "${control_archives[@]}" "${data_archives[@]}" debian-binary
        )
        ;;
      (*.zst) command unzstd -- "$archive" ;;
      (*)
        print -u2 "extract: '$archive' cannot be extracted"
        result=1
        continue
        ;;
    esac
    exit_code=$?
    if (( exit_code == 0 && remove_archive )); then
      command rm -f -- "$archive" || exit_code=$?
    fi
    (( exit_code )) && result=$exit_code
  done
  return $result
}

alias x=extract

return 0
