function print_osc7() {
    if [ "$ZSH_SUBSHELL" -eq 0 ] ; then
        printf "\033]7;file://$HOST/$PWD\033\\"
    fi
}
autoload -Uz add-zsh-hook
add-zsh-hook -Uz chpwd print_osc7
print_osc7
