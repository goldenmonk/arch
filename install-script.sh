#!/bin/bash

# Open the encrypted volume
cryptsetup luksOpen /dev/sda3 /luks
#enter passphrase

# format all the partitions
mkfs.vfat -F32 /dev/sda1
mkfs.ext2 /dev/sda2
mkfs.ext4 /dev/mapper/vg-root
mkfs.ext4 /dev/mapper/vg-home #optional

# mount the root volume
mount /dev/mapper/vg-root /mnt

# Create home directory for separate home volume
mkdir /mnt/home

# Create boot and efi dirctories for efi boot
mkdir /mnt/boot
mkdir /mnt/boot/efi

#mount home, boot and efi
mount /dev/mapper/vg-home /mnt/home
mount /dev/sda2 /boot
mount /dev/sda1 /boot/efi

# install using pacstrap
pacstrap /mnt intel-ucode base linux linux-firmware linux-headers nano sudo grub efibootmgr networkmanager network-manager-applet

# Set timezone
timedatectl set-timezone America/Los_Angeles

# Set locale 
nano /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8

# Set hosts
echo myarch > /etc/hostname
touch /etc/hosts
nano /etc/hosts

# Install all the essential packages 
# broadcom-wl-dkms for lts kernel and broadcom-wl otherwise 
pacman -S grub nano sudo efibootmgr networkmanager wireless_tools broadcom-wl-dkms gnome-shell gdm libreoffice-still lvm2 base-devel gvfs ufw ntfs-3g cron gvfs-mtp

# Install Grub 
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
grub-mkconfig -o /boot/grub/grub.cfg

# enable services
systemctl enable gdm.service
systemctl enable NetworkManager.service

# Install Applications
pacman -S grub vlc gimpp shotwell htop neofetch papirus-icon-theme gparted  rhythmbox homebank telegram-desktop  

# Multilib support
# Uncomment this section
# [multilib]
# Include = /etc/pacman.d/mirrorlist
nano /etc/pacman.conf
pacman -S multi-devel

# Install Halium specific packages
pacman -S repo 

# Install yay helper 
cd /opt
sudo git clone https://aur.archlinux.org/yay-git.git
sudo chown -R maverick ./yay-git
cd yay-git
makepkg -si

yay -S brave-bin #Brave browser
yay -S timeshift #Backup utility
yay -S stacer # System utility
