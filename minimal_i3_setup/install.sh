#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root"
	exit 1
fi

apt-get update

#X window
apt-get install x-window-system
#sudo
apt-get install sudo
#Make you a sudoer
echo "Enter your username:"
read name
usermod -a -G sudo $name
#Install i3 : window manager
apt-get install i3
#Install i3blocks : status bar
apt-get install i3blocks
#Install a file browser
apt-get install ranger
#Install a picture viewer
apt-get install feh
#Install a compositor
apt-get install compton
#Install program launcher
apt-get install rofi

apt-get install udiskie
apt-get install clipit
apt-get install smbclient
apt-get install cifs-utils
apt-get install vim-gtk

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

#Move config files and scripts
sudo -u $name cp $DIR/.xinitrc /home/$name
chmod +x /home/$name/.xinitrc
sudo -u $name cp $DIR/.profile /home/$name
sudo -u $name cp $DIR/.Xresources /home/$name
sudo -u $name cp -R $DIR/Pictures /home/$name
sudo -u $name mkdir /home/$name/Documents
sudo -u $name cp -R $DIR/.config /home/$name

echo "Now logout and log back in"
