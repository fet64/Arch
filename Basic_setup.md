# Basic setup
Do this after first reboot.

```
Sync time
$ timedatectl set-ntp true
$ sudo hwclock --systohc

Fix mirrorlist
$ sudo reflector -c Sweden -a 6 --sort rate --save /etc/pacman.d/mirrorlist
$ sudo pacman -Syy

$ sudo pacman -S bash-completion

Enable services for reflector and ssd-trim
$ sudo systemctl enable --now reflector.timer
$ sudo systemctl enable --now fstrim.timer
```

# Install i3
```
$ sudo pacman -S xorg xf86-video-intel \
  dmenu lightdm lightdm-gtk-greeter \
  lightdm-gtk-greeter-settings ttf-dejavu \
  ttf-liberation noto-fonts firefox nitrogen \
  picom lxappearance pcmanfm materia-gtk-theme \
  papirus-icon-theme alacritty archlinux-wallpaper
$ sudo systemctl enable lightdm
$ reboot
```
# Suckless DWM
* Download DWM source from https://dwm.suckless.org/
* Edit config.def.h
* Compile:
```
$ sudo cp config.def.h config.h
$ sudo make clean install
```
* Put xinitrc in your home directory and change name to .xinitrc or put this at the end of your .xinitrc:
```
exec dwm
```
* Start DWM:
```
$ startx
```
## Installed patches
* dwm-alpha-20201019-61bb8b2.diff
* dwm-fullgaps-6.2.diff
# Suckless ST termnial
* Download ST source from https://st.suckless.org/
* Edit config.def.h or use mine: https://github.com/fet64/Arch/tree/main/suckless/st
* Compile:
```
$ sudo cp config.def.h config.h
$ sudo make clean install
```
## Installed patches
* st-alpha-0.8.2.diff
* st-scrollback-0.8.4.diff

# Suckless SLSTATUS
* Download slstatus source from https://tools.suckless.org/slstatus/
* Edit config.def.h or use mine: https://github.com/fet64/Arch/tree/main/suckless/slstatus
* Compile:
```
$ sudo cp config.def.h config.h
$ sudo make clean install
```
Edit .xinitrc and add 
```
slstatus &
```
# Suckless SLOCK
* Download slock source from https://tools.suckless.org/slock/
* Edit config.def.h
* Compile:
```
$ sudo cp config.def.h config.h
$ sudo make clean install
```
# Suckless DMENU
* Download dmenu source from https://tools.suckless.org/dmenu/
* Edit config.def.h
* Compile:
```
$ sudo cp config.def.h config.h
$ sudo make clean install
```
