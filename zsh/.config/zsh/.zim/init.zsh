zimfw() { source /home/masterj/.config/zsh/.zim/zimfw.zsh "${@}" }
zmodule() { source /home/masterj/.config/zsh/.zim/zimfw.zsh "${@}" }
typeset -gr _zim_fpath=(/home/masterj/dotfile/zsh/.config/zsh/.zim/modules/git/functions /home/masterj/dotfile/zsh/.config/zsh/.zim/modules/utility/functions /home/masterj/dotfile/zsh/.config/zsh/.zim/modules/git-info/functions /home/masterj/dotfile/zsh/.config/zsh/.zim/modules/duration-info/functions /home/masterj/dotfile/zsh/.config/zsh/.zim/modules/prompt-pwd/functions)
fpath=(${_zim_fpath} ${fpath})
autoload -Uz -- git-alias-lookup git-branch-current git-branch-delete-interactive git-branch-remote-tracking git-dir git-ignore-add git-root git-stash-clear-interactive git-stash-recover git-submodule-move git-submodule-remove mkcd mkpw coalesce git-action git-info duration-info-precmd duration-info-preexec prompt-pwd
source /home/masterj/dotfile/zsh/.config/zsh/.zim/modules/environment/init.zsh
source /home/masterj/dotfile/zsh/.config/zsh/.zim/modules/git/init.zsh
source /home/masterj/dotfile/zsh/.config/zsh/.zim/modules/input/init.zsh
source /home/masterj/dotfile/zsh/.config/zsh/.zim/modules/termtitle/init.zsh
source /home/masterj/dotfile/zsh/.config/zsh/.zim/modules/utility/init.zsh
source /home/masterj/dotfile/zsh/.config/zsh/.zim/modules/completion/init.zsh
source /home/masterj/dotfile/zsh/.config/zsh/.zim/modules/duration-info/init.zsh
source /home/masterj/dotfile/zsh/.config/zsh/.zim/modules/magicmace/magicmace.zsh-theme
source /home/masterj/dotfile/zsh/.config/zsh/.zim/modules/zsh-completions/zsh-completions.plugin.zsh
source /home/masterj/dotfile/zsh/.config/zsh/.zim/modules/zsh-autosuggestions/zsh-autosuggestions.zsh
source /home/masterj/dotfile/zsh/.config/zsh/.zim/modules/zsh-history-substring-search/zsh-history-substring-search.zsh
source /home/masterj/dotfile/zsh/.config/zsh/.zim/modules/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
source /home/masterj/dotfile/zsh/.config/zsh/.zim/modules/k/k.sh
source /home/masterj/dotfile/zsh/.config/zsh/.zim/modules/zsh-autopair/zsh-autopair.plugin.zsh
source /home/masterj/dotfile/zsh/.config/zsh/.zim/modules/zfm/zfm.zsh
source /home/masterj/dotfile/zsh/.config/zsh/.zim/modules/zsh-z/zsh-z.plugin.zsh
source /home/masterj/dotfile/zsh/.config/zsh/.zim/modules/fzf-tab/fzf-tab.zsh
source /home/masterj/dotfile/zsh/.config/zsh/.zim/modules/zsh-vi-mode/zsh-vi-mode.zsh
