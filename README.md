# Guide for installing Arch Linux
Install Arch Linux with encryption

# Preperations
1. Get latest arch iso from https://archlinux.org/download/
2. Find out the name of your USB drive with lsblk

```
# lsblk
NAME          MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
sda             8:0    1  29.3G  0 disk
├─sda1          8:1    1   760M  0 part
└─sda2          8:2    1    86M  0 part
nvme0n1       259:0    0 931.5G  0 disk
```

4. Get iso onto USB:

* using cat:

```
# cat path/to/archlinux.iso > /dev/sda
```

* using cp:

```
# cp path/to/archlinux.iso /dev/sda
```
* using dd:

```
# dd bs=4M if=/path/to/iso of=/dev/sda conv=fsync oflag=sync status=progress
```
# Boot laptop with your usb

5. Set the console keyboard layout

```
# loadkeys sv-latin1
```

6. Connect to the internet

```
# ip -c a
```
For wireless:

```
# iwctl
  [iwd]# device list
  [iwd]# station wlan0 scan
  [iwd]# station wlan0 get-networks
  [iwd]# station wlan0 connect SSID
        [enter passphrase]
  [iwd]# exit
```

For WWAN (simular to iwctl):

```
# mmcli
```

7. Update packages:

```
# pacman -Syyy
```

# Partition the disk

```
# gdisk /dev/nvme0n1
:o
:n  :1  :first sector: default :last sector: +512M code:ef00
:n  :2  :first sector: default :last sector: default code:8300
:w
 
```

Use lsblk to check on your work:
```
# lsblk

NAME          MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
sda             8:0    1  29.3G  0 disk
├─sda1          8:1    1   760M  0 part
└─sda2          8:2    1    86M  0 part
nvme0n1       259:0    0 931.5G  0 disk
├─nvme0n1p1   259:1    0   512M  0 part  
└─nvme0n1p3   259:3    0   931G  0 part
```

# Create Filesystems
```
# mkfs.vfat -F32 /dev/nvme0n1p1
# cryptsetup -y -v luksFormat /dev/nvme0n1p2
# cryptsetup open /dev/nvme0n1p2 cryptroot
# mkfs.ext4 /dev/mapper/cryptroot
```

# Mount Filesystems
```
# mount /dev/mapper/cryptroot /mnt
# mkdir /mnt/boot
# mount /dev/nvme0n1p1 /mnt/boot
```

# Create Swap File (not in VMs)
```
# dd if=/dev/zero of=/mnt/swapfile bs=1M count=24576 status=progress
Make the swapfile as big as you like, usually around 1.5 times the size of your RAM
# chmod 600 /mnt/swapfile
# mkswap /mnt/swapfile
# swapon /mnt/swapfile
```

# Install base packages
```
# pacstrap /mnt base base-devel mkinitcpio linux linux-firmware intel-ucode vim git
```

# Generate Filesystem Table (fstab)
```
# genfstab -U /mnt >> /mnt/etc/fstab
```

# Chroot into system
```
# arch-chroot /mnt
```

# Use script from github
```
# git clone https://github.com/fet64/arch
# chmod +x after_chroot.sh
# ./after_chroot.sh

or continue belov
```

# Timezone and sync time
```
# ls -sf /usr/share/zoneinfo/Europe/Stockholm /etc/localtime
# hwclock --systohc
```

# Locale
Remove # from your selected locale in locale.gen, I use en_US.UTF-8. Update locale.conf.
```
# vim /etc/locale.gen

...
#en_SG.UTF-8 UTF-8
#en_SG ISO-8859-1
en_US.UTF-8 UTF-8
#en_US ISO-8859-1
#en_ZA.UTF-8 UTF-8
...

# locale-gen
# echo LANG=en_US.UTF-8 > /etc/locale.conf
# echo KEYMAP=sv-latin1 > /etc/vconsole.conf
```

# Hostname
```
# echo arch > /etc/hostname
```

# Hostfile
```
# vim /etc/hosts

# Static table lookup for hostnames.
# See hosts(5) for details.
127.0.0.1	localhost
::1     localhost
127.0.1.1	arch.localdomain	arch
```

# Password for root user and create a user
```
# passwd
# useradd -mG wheel,audio,video USERNAME
# passwd USERNAME
# EDITOR=vim visudo

remove # at the start of the following line:
%wheel ALL=(ALL) ALL
```

# Install packages
```
# pacman -S grub efibootmgr networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools base-devel linux-headers bluez bluez-utils cups xdg-utils xdg-user-dirs alsa-utils pulseaudio pulseaudio-bluetooth git reflector
```


# Fix mkinitcpio.conf
```
# vim /etc/mkinitcpio.conf

edit HOOKS:
HOOKS=(base udev autodetect keyboard keymap modconf block encrypt filesystems fsck)

# mkinitcpio -p linux
```

# Install GRUB

```
# pacman -S grub efibootmgr intel-ucode
# grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
# grub-mkconfig -o /boot/grub/grub.cfg

Find UUID of encrypted partition:
# blkid
Copy UUID and change /etc/default/grub
# vim /etc/default/grub
...
GRUB_CMDLINE_LINUX="cryptdevice=UUID=11111111-2222-3333-4444-555555555555:cryptroot root=/dev/mapper/cryptroot"
...
# grub-mkconfig -o /boot/grub/grub.cfg
```

# Enable system services
```
# systemctl enable NetworkManager
# systemctl enable bluetooth
# systemctl enable cups
```

# Finishing the base install
```
Exit arch-chroot environment
# exit
# umount -a
# reboot
```
