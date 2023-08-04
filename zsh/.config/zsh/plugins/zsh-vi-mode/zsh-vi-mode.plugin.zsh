# According to the standard:
# https://zdharma-continuum.github.io/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# Append a command directly
zvm_after_init_commands+=('[ -f ~/.config/zsh/fzf.zsh ] && source ~/.config/zsh/fzf.zsh')
source ${0:h}/zsh-vi-mode.zsh
