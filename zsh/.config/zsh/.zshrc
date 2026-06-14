# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# zmodload zsh/zprof
source ~/.config/zsh/env.zsh
source ~/.config/zsh/plugins.zsh
source ~/.config/zsh/aliases.zsh 
source ~/.config/zsh/prompt.zsh
source ~/.config/zsh/plugins/extract/extract.plugin.zsh
source ~/.config/zsh/completion.zsh
source ~/.config/zsh/vi.zsh
source ~/.config/zsh/fzf.zsh
source ~/.config/zsh/functions/cd_git_root.zsh

source ~/.config/zsh/keys.zsh
# zprof
export PATH="/opt/homebrew/opt/curl/bin:$PATH"

