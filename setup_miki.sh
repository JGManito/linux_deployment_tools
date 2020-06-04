#!/bin/bash

#Master deployment script for Miki. This is a stopgap measure, intended to be replaced as soon as possible with a complete Ansible playbook.

#Latest update: 04-06-2020

#This script has no other dependencies than a base install with the folowing selected meta-packages:
#	- SSH Server
#	- Standard System Utilities
#Anything else that is required will be installed by this script

#WARNING: THIS SCRIPT DOES NOT HAVE COMPLETE INPUT VALIDATION NOR ERROR HANDLING! ASSUME THAT EVERYTHING MUST RUN CORRECTLY THE FIRST TIME

#0: Install package sudo and add the current user to the sudo group
if [ ! -f /home/joaomanito/next_step1 ]; then
	su - --command="apt-get -y install sudo && usermod -a -G sudo joaomanito && touch /home/joaomanito/next_step1 && reboot"
fi


#1: Update the APT database and any installed packages and install etckeeper
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y install etckeeper

#1.5: Download helper scripts from github
wget https://github.com/jonythunder/linux_deployment_tools/raw/master/configure_static_ip.py


#2: Change the network interface configuration to use a static IP
sudo apt-get -y install python
sudo "python configure_static_ip.py 192.168.1.83 255.255.255.0 192.168.1.254"

#3: Create the mount points for all the internal and external drives
#Add internal drive mountpoints
sudo mkdir /media/ssd_datastore
sudo mkdir /media/ssd_var
sudo mkdir /media/hdd_6000GB
sudo mkdir /media/hdd_160GB
sudo mkdir /media/hdd_500GB

#Add external drive mountpoints
sudo mkdir /media/external_drives
sudo mkdir /media/external_drives/WD1500
sudo mkdir /media/external_drives/WD3000


#Add entries to fstab
# sudo tee -a /etc/fstab > /dev/null <<EOF2
# # SSD_Var Partition
# UUID=aac4f7c3-929b-44f6-ba69-8d7a889196a6	/media/ssd_var	ext4	defaults	0	2
# #
# # VM_Datastore partition
# UUID=1b060dbf-0839-4ab7-93bb-9bae77e19dfa	/media/ssd_datastore	ext4	defaults	0	2
# #
# # 160GB HDD
# UUID=664C24AB1B846B4B				/media/hdd_160GB	ntfs	defaults	0	2
# #
# # 6TB HDD
# UUID=9be119b2-a391-47b3-8bb3-14cc5a761e29	/media/hdd_6000GB	ext4	defaults	0	2
# #
# # 500GB HDD (LTI)
# UUID=768286f1-af6b-4224-88c3-26e8c398fa9a	/media/hdd_500GB	ext4	defaults	0	2
# EOF2

#Install all the software to be run on bare metal:
sudo apt-get -y install fail2ban hddtemp smartmontools sshguard ufw clonezilla
