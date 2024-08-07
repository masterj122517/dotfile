case "$1" in
    run) rofi -show run -theme ~/.config/rofi/config.rasi ;;
    drun) rofi -show drun -show-icons -theme ~/.config/rofi/rofi_2c.rasi ;;
    custom) rofi -show menu -modi 'menu:~/.config/rofi/config.rasi' -theme ~/.config/rofi/config.rasi ;;
    window) rofi -show window -show-icons -theme ~/.config/rofi/rofi_2c.rasi ;;
esac
