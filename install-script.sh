# Set timezone
timedatectl set-timezone Asia/Kolkata

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
pacman -S grub efibootmgr networkmanager wireless_tools broadcom-wl-dkms gnome-shell gdm libreoffice-still lvm2 base-devel gvfs ufw ntfs-3g cron gvfs-mtp

# Install Grub 
grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
grub-mkconfig -o /boot/grub/grub.cfg

# enable services
systemctl enable gdm.service
systemctl enable NetworkManager.service

# Install Applications
pacman -S grub vlc gimpp shotwell htop neofetch papirus-icon-theme gparted  rhythmbox homebank telegram-desktop  

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
