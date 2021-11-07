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

Install i3
$ sudo pacman -S xorg xf86-video-intel \
  dmenu lightdm lightdm-gtk-greeter \
  lightdm-gtk-greeter-settings ttf-dejavu \
  ttf-liberation noto-fonts firefox nitrogen \
  picom lxappearance pcmanfm materia-gtk-theme \
  papirus-icon-theme alacritty archlinux-wallpaper
$ sudo systemctl enable lightdm
$ reboot
```
