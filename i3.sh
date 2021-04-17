#!/bin/bash
pacman -S i3 dmenu xorg-server xorg-xinit terminator ttf-dejavu
yay -S redshift-minimal
echo "exec i3" > ~/.xinitrc
echo "exec terminator" >> ~/.config/i3/config
echo "exec redshift -P -O 2500" >> ~/.config/i3/config
  
startx
