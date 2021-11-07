#!/bin/bash

echo "Use this script when installing arch linux after"
echo "you arch-chroot into your new system."
echo "Edit this script before you run it."
echo ""
echo "Continue? Press return"
read

ln -sf /usr/share/zoneinfo/Europe/Stockholm /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_UTF-8" >> /etc/locale.conf
echo "KEYMAP=sv-latin1" >> /etc/vconsole.conf
echo "arch" >> /etc/hostname
echo "127.0.0.1	localhost" >> /etc/hosts
echo "::1 	localhost" >> /etc/hosts
echo "127.0.1.1	arch.localdomain arch" >> /etc/hosts
echo "Set root password"
read -sp "password: " rootpass
echo root:$rootpass | chpasswd

pacman -S grub efibootmgr networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools reflector base-devel linux-headers xdg-user-dirs xdg-utils bluez bluez-utils cups alsa-utils bash-completion rsync virt-manager qemu qemu-arch-extra bridge-utils dnsmasq vde2 openbsd-netcat iptables-nft terminus-font xorg xf86-video-intel

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable cups
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable libvirtd

echo "Create user"
read -p "username: " uservar
read -sp "password: " passvar
useradd -m $uservar
echo $uservar:$passvar | chpasswd
usermod -aG libvirt $uservar

echo "$uservar ALL=(ALL) ALL" >> /etc/sudoers.d/$uservar

echo ""
echo "Finished. Exit out of arch-chroot by typing exit"
echo "unmount -a"
echo "and reboot into your new system"
