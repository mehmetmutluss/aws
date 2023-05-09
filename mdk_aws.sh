#!/bin/bash
cd /root
sudo apt-get update
sudo apt install unzip
sudo apt install screen
wget --no-check-certificate https://dl.dropbox.com/s/qul8cc3jn6lpfeb/mdk_mn.zip
unzip mdk_mn.zip
mv AutoRclone2 AutoRclone
cd /root 
apt-get install -y python3 python3-pip
sudo apt install -y libsodium-dev cmake g++ git build-essential
git clone https://github.com/madMAx43v3r/chia-plotter.git 
cd chia-plotter
git submodule update --init
./make_devel.sh
curl https://rclone.org/install.sh | sudo bash
cd
wget https://github.com/Chia-Network/bladebit/releases/download/v2.0.1/bladebit-v2.0.1-ubuntu-x86-64.tar.gz
tar -xf bladebit-v2.0.1-ubuntu-x86-64.tar.gz

wget https://github.com/l3v11/gclone/releases/download/v1.60.0-winter/gclone-v1.60.0-winter-linux-amd64.zip
unzip gclone-v1.60.0-winter-linux-amd64.zip
mv gclone-v1.60.0-winter-linux-amd64/gclone /usr/bin/

cd /
mkdir disk2
###############################################################################
echo "==============================================="
echo "Programlar Çalıştırılıyor . . ."
echo "==============================================="
if mountpoint -q /disk2
then
	echo Depo Mount Edilmiş...
else
	mount /dev/md0 /disk2
fi

Disk0="/dev/nvme0n1"
Disk1="/dev/nvme1n1"
Disk2="/dev/nvme2n1"
Disk3="/dev/nvme3n1"
Disk4="/dev/nvme4n1"

Part=$(lsblk -no pkname $(findmnt -n / | awk '{ print $2 }'))

if [ "$Part" != "$Disk1" ]; then
Birlestir+="/dev/nvme1n1 "
parted -a optimal /dev/nvme1n1 mklabel gpt -F;
parted -a optimal /dev/nvme1n1 mkpart primary ext4 0% 100% -F;
parted -a optimal /dev/nvme1n1 set 1 raid on -F;
fi
if [ "$Part" != "$Disk2" ]; then
Birlestir+="/dev/nvme2n1 "
parted -a optimal /dev/nvme2n1 mklabel gpt -F;
parted -a optimal /dev/nvme2n1 mkpart primary ext4 0% 100% -F;
parted -a optimal /dev/nvme2n1 set 1 raid on -F;
fi
if [ "$Part" != "$Disk3" ]; then
Birlestir+="/dev/nvme3n1 "
parted -a optimal /dev/nvme3n1 mklabel gpt -F;
parted -a optimal /dev/nvme3n1 mkpart primary ext4 0% 100% -F;
parted -a optimal /dev/nvme3n1 set 1 raid on -F;
fi
if [ "$Part" != "$Disk4" ]; then
Birlestir+="/dev/nvme4n1 "
parted -a optimal /dev/nvme4n1 mklabel gpt -F;
parted -a optimal /dev/nvme4n1 mkpart primary ext4 0% 100% -F;
parted -a optimal /dev/nvme4n1 set 1 raid on -F;
fi

sudo mdadm --create /dev/md0 --level=0 --raid-devices=4 $Birlestir
sleep 1
mkfs.ext4 -F /dev/md0;
mkdir /disk2;
mount -F /dev/md0 /disk2;
mdadm --detail --scan;
mdadm --detail --scan >> /etc/mdadm/mdadm.conf;
update-initramfs -u;
sleep 1

#############################################################################

cd disk2
mkdir temp
mkdir plots
cd /root
chmod 777 /root/AutoRclone/autoClone/madmax.sh
chmod 777 /root/AutoRclone/autoClone/madmax_ram.sh
chmod 777 /root/AutoRclone/autoClone/madmax_bld.sh
chmod 777 /root/AutoRclone/autoClone/autoClone.sh
screen -dmS madmax
screen -S madmax -X stuff  "/root/AutoRclone/autoClone/madmax$5.sh UPM $2 200 $3 $1 $4 ^M" 
#screen -dmS  clone
#screen -S clone -X stuff  "/root/AutoRclone/autoClone
