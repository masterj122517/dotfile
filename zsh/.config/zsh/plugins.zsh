ZIM_HOME="$ZDOTDIR/.zim"
if [[ ! -r $ZIM_HOME/init.zsh ]]; then
  print -u2 "zsh: install shell dependencies with bash $ZDOTDIR/install.sh"
  return 1
fi

# Rebuild locally when the module list changes; never download at startup.
if [[ ! $ZIM_HOME/init.zsh -nt $ZDOTDIR/.zimrc ]]; then
  source "$ZIM_HOME/zimfw.zsh" build -q || return
fi
source "$ZIM_HOME/init.zsh"
