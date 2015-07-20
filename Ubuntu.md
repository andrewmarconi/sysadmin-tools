# Set up Ubuntu 14.x or 15.x with VirtualBox Guest Additions and NodeJS

## Initial Setup

Install base server, with SSH server only. Give machine a *.local name.

 sudo apt-get update
 sudo apt-get upgrade
 sudo apt-get install -y build-essential module-assistant avahi-daemon
 sudo m-a prepare

Mount the Guest Additions cdrom.

 sudo mount /dev/cdrom /mnt
 cd /mnt
 sudo ./VBoxLinuxAdditions.run
 cd
 sudo umount /mnt

## Install Latest Node.js
sudo apt-get install -y nodejs
