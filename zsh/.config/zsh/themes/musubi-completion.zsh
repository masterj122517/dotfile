# musubi completion semantics; these styles do not change ls/eza or shell syntax.
# Files: #48465B; directories: #765991; executables: #4B673F; links: #236A70.
# Variables: #9D4D6D; aliases/functions: #765991; other group labels: #625B6D.
typeset -a _musubi_completion_colors=(
  'fi=0;38;2;72;70;91'
  'di=1;38;2;118;89;145'
  'ex=1;38;2;75;103;63'
  'ln=0;38;2;35;106;112'
  'or=0;38;2;164;61;70'
  'mi=0;38;2;164;61;70'
  'tw=1;38;2;118;89;145'
  'ow=1;38;2;118;89;145'
  'st=1;38;2;118;89;145'
  '*=0;38;2;72;70;91'
)
zstyle ':completion:*' list-colors "${_musubi_completion_colors[@]}"
zstyle ':completion:*:default' list-colors "${_musubi_completion_colors[@]}"
unset _musubi_completion_colors

# Plain group names let fzf-tab apply its own theme instead of Zim's ANSI colors.
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:*' single-group color
zstyle ':fzf-tab:*' default-color $'\e[38;2;72;70;91m'

# Color non-file groups by meaning, not their position in a changing candidate list.
# Filesystem candidates retain their more specific list-colors styles above.
zstyle -e ':fzf-tab:*' group-colors '
  local group rgb color
  reply=()
  for group in "${_ftb_groups[@]}"; do
    case ${group:l} in
      *parameter*|*variable*|*environment*) rgb="157;77;109" ;;
      *director*) rgb="118;89;145" ;;
      *command*|*executable*) rgb="75;103;63" ;;
      *alias*|*function*|*reserved*) rgb="118;89;145" ;;
      *file*) rgb="72;70;91" ;;
      *) rgb="98;91;109" ;;
    esac
    printf -v color "\033[38;2;%sm" "$rgb"
    reply+=("$color")
  done
  # The installed native helper needs a spare entry after the final group.
  printf -v color "\033[38;2;98;91;109m"
  reply+=("$color")
'
