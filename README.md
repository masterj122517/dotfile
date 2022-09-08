# This is my dotfile for my linux 

# Important:

## To use my dotfile 

### First You Have to install  stow  

Then Use 

`stow *`



## Font 
I use `Fira Code Nerd ` and `Source code pro `

Just install `noto-fonts` and `Fira Code` From [Nerd Font](https://www.nerdfonts.com/)  and put them to the `/usr/share/fonts/`

## Emoji 
### Be able to display emoji correctly in arch

`yay -S libxft-bgra-git`
### the emoji font I use 
```
yay -S ttf-linux-libertine ttf-inconsolata ttf-joypixels ttf-twemoji-color noto-fonts-emoji ttf-liberation ttf-droid
```
#### Chinese
```
yay -S wqy-bitmapfont wqy-microhei wqy-microhei-lite wqy-zenhei adobe-source-han-mono-cn-fonts adobe-source-han-sans-cn-fonts adobe-source-han-serif-cn-fonts
```

## Some Dependencies
### set wallpapers 
```
yay -S xwallpaper
```
### image Viewer
```
yay -S sxiv
```

## To be able to use image preview in ranger 

Use 
```
pip install ueberzug
```

### To use keymaps<LeftRelease> 
```
sudo pacman -S xcape
```

### The RSS client 
```
sudo pacman -S newsboat
```

### To use the audio  
```
sudo pacman -S alsa-firmware alsa-lib alsa-plugins alsa-tools alsa-utils pulseaudio-alsa sof-firmware
```

**NOW JUST USE PIPEWIRE** 
```
yay -S pipewire-alsa pipewire-jack pipewire pipewire-pulse wireplumber
```


### Notify 

```
sudo pacman -S libnotify dunst
```
