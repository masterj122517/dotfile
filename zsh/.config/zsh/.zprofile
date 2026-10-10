# macOS path_helper runs before this file; restore our PATH order afterward.
export ZDOTDIR="${${(%):-%N}:a:h}"
source "$ZDOTDIR/environment.zsh"
