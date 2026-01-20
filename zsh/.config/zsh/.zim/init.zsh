# FILE AUTOMATICALLY GENERATED FROM /Users/masterj/.config/zsh/.zimrc
# EDIT THE SOURCE FILE AND THEN RUN zimfw build. DO NOT DIRECTLY EDIT THIS FILE!

if [[ -e ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]] zimfw() { source "${HOME}/.config/zsh/.zim/zimfw.zsh" "${@}" }
fpath=("${HOME}/.config/zsh/.zim/modules/git/functions" "${HOME}/.config/zsh/.zim/modules/utility/functions" "${HOME}/.config/zsh/.zim/modules/completion/functions" "${HOME}/.config/zsh/.zim/modules/git-info/functions" "${HOME}/.config/zsh/.zim/modules/duration-info/functions" "${HOME}/.config/zsh/.zim/modules/prompt-pwd/functions" ${fpath})
autoload -Uz -- git-alias-lookup git-branch-current git-branch-delete-interactive git-branch-remote-tracking git-dir git-ignore-add git-root git-stash-clear-interactive git-stash-recover git-submodule-move git-submodule-remove mkcd mkpw coalesce git-action git-info duration-info-precmd duration-info-preexec prompt-pwd
source "${HOME}/.config/zsh/.zim/modules/environment/init.zsh"
source "${HOME}/.config/zsh/.zim/modules/git/init.zsh"
source "${HOME}/.config/zsh/.zim/modules/input/init.zsh"
source "${HOME}/.config/zsh/.zim/modules/termtitle/init.zsh"
source "${HOME}/.config/zsh/.zim/modules/utility/init.zsh"
source "${HOME}/.config/zsh/.zim/modules/completion/init.zsh"
source "${HOME}/.config/zsh/.zim/modules/duration-info/init.zsh"
source "${HOME}/.config/zsh/.zim/modules/zsh-completions/zsh-completions.plugin.zsh"
source "${HOME}/.config/zsh/.zim/modules/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "${HOME}/.config/zsh/.zim/modules/zsh-history-substring-search/zsh-history-substring-search.zsh"
source "${HOME}/.config/zsh/.zim/modules/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
source "${HOME}/.config/zsh/.zim/modules/k/k.sh"
source "${HOME}/.config/zsh/.zim/modules/zsh-autopair/zsh-autopair.plugin.zsh"
source "${HOME}/.config/zsh/.zim/modules/zfm/zfm.zsh"
source "${HOME}/.config/zsh/.zim/modules/zsh-z/zsh-z.plugin.zsh"
source "${HOME}/.config/zsh/.zim/modules/fzf-tab/fzf-tab.zsh"
source "${HOME}/.config/zsh/.zim/modules/gitster/gitster.zsh-theme"
