# Kataware completion semantics; these styles do not change ls/eza or shell syntax.
# Files: #D9E2F2; directories: #9B8CFF; executables: #82D2B2; links: #60D7E8.
# Variables: #F08BC3; aliases/functions: #9B8CFF; other group labels: #A8B7D0.
typeset -a _kataware_completion_colors=(
  'fi=0;38;2;217;226;242'
  'di=1;38;2;155;140;255'
  'ex=1;38;2;130;210;178'
  'ln=0;38;2;96;215;232'
  'or=0;38;2;242;119;139'
  'mi=0;38;2;242;119;139'
  'tw=1;38;2;155;140;255'
  'ow=1;38;2;155;140;255'
  'st=1;38;2;155;140;255'
  '*=0;38;2;217;226;242'
)
zstyle ':completion:*' list-colors "${_kataware_completion_colors[@]}"
zstyle ':completion:*:default' list-colors "${_kataware_completion_colors[@]}"
unset _kataware_completion_colors

# Plain group names let fzf-tab apply its own theme instead of Zim's ANSI colors.
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:*' single-group color
zstyle ':fzf-tab:*' default-color $'\e[38;2;217;226;242m'

# Color non-file groups by meaning, not their position in a changing candidate list.
# Filesystem candidates retain their more specific list-colors styles above.
zstyle -e ':fzf-tab:*' group-colors '
  local group rgb color
  reply=()
  for group in "${_ftb_groups[@]}"; do
    case ${group:l} in
      *parameter*|*variable*|*environment*) rgb="240;139;195" ;;
      *director*) rgb="155;140;255" ;;
      *command*|*executable*) rgb="130;210;178" ;;
      *alias*|*function*|*reserved*) rgb="155;140;255" ;;
      *file*) rgb="217;226;242" ;;
      *) rgb="168;183;208" ;;
    esac
    printf -v color "\033[38;2;%sm" "$rgb"
    reply+=("$color")
  done
  # The installed native helper needs a spare entry after the final group.
  printf -v color "\033[38;2;168;183;208m"
  reply+=("$color")
'
