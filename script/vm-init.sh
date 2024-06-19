#!/bin/sh

set -e

sudo parted /dev/sda -- mklabel gpt
sudo parted /dev/sda -- mkpart ESP fat32 0% 512MB
sudo parted /dev/sda -- set 1 esp on
sudo parted /dev/sda -- mkpart root ext4 512MB 100%

sudo mkfs.fat -F 32 -n boot /dev/sda1
sudo mkfs.ext4 -L root /dev/sda2

sudo mount /dev/disk/by-label/root /mnt
sudo mkdir -p /mnt/boot
sudo mount -o umask=077 /dev/disk/by-label/boot /mnt/boot
