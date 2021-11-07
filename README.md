# Guide for installing Arch Linux
This is my way of setting up Arch Linux

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
# dd bs=4M if=/path/to/iso of=/dev/sda conv=fsync oflag=direct status=progress
```

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
:n  :1  :first sector: default :last sector: +500M code:ef00
:n  :2  :first sector: default :last sector: +32G  code:8200
:n  :3  :first sector: default :last sector: default code:8300
:w

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048         1026047   500.0 MiB   EF00  EFI system partition
   2         1026048        68134911   32.0 GiB    8200  Linux swap
   3        68134912      1953525134   899.0 GiB   8300  Linux filesystem
```

Use lsblk to check on your work:
```
# lsblk

NAME          MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
sda             8:0    1  29.3G  0 disk
├─sda1          8:1    1   760M  0 part
└─sda2          8:2    1    86M  0 part
nvme0n1       259:0    0 931.5G  0 disk
├─nvme0n1p1   259:1    0   500M  0 part  
├─nvme0n1p2   259:2    0    32G  0 part  
└─nvme0n1p3   259:3    0   899G  0 part
```

# Create Filesystems
```
# mkfs.vfat -F32 /dev/nvme0n1p1
# mkswap /dev/nvme0n1p2
# swapon /dev/nvme0n1p2
# cryptsetup -y -v luksFormat /dev/nvme0n1p3
# cryptsetup open /dev/nvme0n1p3 cryptroot
# mkfs.ext4 /dev/mapper/cryptroot
```

# Mount Filesystems
```
# mount /dev/mapper/cryptroot /mnt
# mkdir /mnt/boot
# mount /dev/nvme0n1p1 /mnt/boot
```

# Install base packages
```
# pacstrap /mnt base linux linux-firmware intel-ucode vim 
```

