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


# Create swap space
cd /mnt 
dd if=/dev/zero of=/swap bs=1M count=1024
mkswap /swap
swapon /swap
chmod 0600 /swap
cd

# install using pacstrap
pacstrap /mnt intel-ucode base linux linux-firmware linux-headers nano sudo grub efibootmgr networkmanager network-manager-applet lvm2 base-devel gvfs ufw ntfs-3g cron gvfs-mtp git wireless_tools broadcom-wl wpa_supplicants i3 dmenu xorg-server xorg-xinit terminator ttf-dejavu lxappearance ranger xbacklight xorg

# Create fstab
genfstab -U /mnt >> /mnt/etc/fstab
# "/swapfile none swap defaults 0 0" >> /mnt/etc/fstab

arch-chroot /mnt

#Edit /etc/mkinitcpio.conf
#HOOKS="base udev autodetect modconf block keymap encrypt lvm2 resume filesystems keyboard fsck"
# mkinitcpio -p linux

# Set timezone
#timedatectl set-timezone America/Los_Angeles
timedatectl set-timezone Asia/Kolkata
hwclock --systohc

# Set locale 
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
export LANG=en_US.UTF-8

# Set hosts
echo myarch > /etc/hostname
touch /etc/hosts
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1 localhost" >> /etc/hosts
echo "127.0.1.1 myarch" >> /etc/hosts

 #nano /etc/default/grub
#GRUB_CMDLINE_LINUX=”cryptdevice=/dev/sda3:vg-root”

# Install Grub 
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
grub-mkconfig -o /boot/grub/grub.cfg

# enable services
systemctl enable ufw.service
systemctl enable NetworkManager.service

# Install Applications
pacman -S vlc gimp shotwell htop neofetch papirus-icon-theme gparted rhythmbox homebank telegram-desktop libreoffice-still nautilus 

passwd
#useradd -m -G wheel username
#passwd username
# Multilib support
# Uncomment this section
# [multilib]
# Include = /etc/pacman.d/mirrorlist
echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
pacman -S multilib-devel

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
yay -S redshift-minimal i3-swallow 
echo "exec i3" > ~/.xinitrc
echo "exec terminator" >> ~/.config/i3/config
echo "exec redshift -P -O 2500" >> ~/.config/i3/config
#alsa-firmware alsa-utils alsa-plugins pulseaudio-alsa pulseaudio
 #exec --no-startup-id "pulseaudio --start
