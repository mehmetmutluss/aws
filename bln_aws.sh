#!/bin/bash
cd /root
sudo apt update
sudo apt install unzip
wget https://dl.dropbox.com/s/25uv35op6xc34a2/aws_goffi.zip
unzip aws_goffi.zip
sleep 5
GIT() {
  BurayaGit=$1
  cmd=$(sed -En "/^[[:space:]]*#[[:space:]]*$BurayaGit:[[:space:]]*#/{:a;n;p;ba};" "$0")
  eval "$cmd"
  exit
}

ILK_KURULUM=${1:-"ILK_KURULUM"}
GIT $ILK_KURULUM

#ILK_KURULUM:#
ILKKUR=$(sed -nr "/^\[ILKKURUKUM\]/ { :l /^IlkKurulum[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" ayarlar.db)

if [ $ILKKUR == "Evet" ]
then
echo "==============================================="
echo "İlk kurulum içim hazırlanıyor . . ."
echo "==============================================="
#------------------ apt-get update -y;
#------------------ sudo apt install unzip;
#------------------ apt-get upgrade -y;
sudo apt-get install -y whiptail
sudo apt-get install dialog -y
sudo apt install screen -y
echo "==============================================="
echo "Program açılıyor!"
echo "==============================================="
sed -i '/^\[ILKKURUKUM]/,/^\[/{s/^IlkKurulum[[:space:]]*=.*/IlkKurulum = "Hayir"/}' ayarlar.db
sleep 2
fi
GIT KURULUM_MENU

#KURULUM_MENU:#
YUKSEKLIK=0
GENISLIK=0
MENUSAYISI=0
ARKABASLIK="Linux Kurulum Ekrani (Ver : 1.0)"
BASLIK="- Sencenek Menusu -"
CPU=$(grep 'siblings' /proc/cpuinfo | uniq | awk {'print $3'})
RAM=$(($(getconf _PHYS_PAGES) * $(getconf PAGE_SIZE) / (1024 * 1024)))
RAM=$(($RAM / 1000))
MENU="Makine = RAM:$RAM | CPU:$CPU"

SECENEKLER=(1 "Ayarları Değiştir." \
			2 "Sadece Programlari Baslat." \
			3 "Kurulumu Bastan Yap.")

SEC=$(whiptail --clear --ok-button "Tamam" --cancel-button "Iptal" \
                --backtitle "$ARKABASLIK" \
                --title "$BASLIK" \
                --menu "$MENU" \
                $YUKSEKLIK $GENISLIK $MENUSAYISI \
                "${SECENEKLER[@]}" \
                2>&1 >/dev/tty)
clear
case $SEC in
1)
KUZANTI=$(sed -nr "/^\[KOPYALAMA\]/ { :l /^Uzanti[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" ~/ayarlar.db);
ORTAKDRV=$(sed -nr "/^\[KOPYALAMA\]/ { :l /^OrtakDvr[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" ~/ayarlar.db);
ACCKLASOR=$(sed -nr "/^\[KOPYALAMA\]/ { :l /^AccKlasor[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" ~/ayarlar.db);
ACCBASLANGIC=$(sed -nr "/^\[KOPYALAMA\]/ { :l /^AccBaslangic[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" ~/ayarlar.db);
ACCBITIM=$(sed -nr "/^\[KOPYALAMA\]/ { :l /^AccBitis[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" ~/ayarlar.db);
ACCDONUS=$(sed -nr "/^\[KOPYALAMA\]/ { :l /^AccDonus[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" ~/ayarlar.db);
DRVID=$(sed -nr "/^\[plt\]/ { :l /^team_drive[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" ~/.config/rclone/rclone.conf);
ROOTID=$(sed -nr "/^\[plt\]/ { :l /^root_folder_id[ ]*=/ { s/[^=]*=[ ]*//; p; q;}; n; b l;}" ~/.config/rclone/rclone.conf);

AYARDEGISTIR=$(dialog --clear --ok-button "Tamam" --cancel-button "İptal" \
	--backtitle "$ARKABASLIK" \
    --title "- Ayarları Değiştir -" \
    --form  "Geçerli Ayarları Değiştir" 0 0 0 \
    " Kop. Uzantı...:" 1 1    "$KUZANTI"		1 17 6 0	 \
    " Ortak Drv.....:" 2 1    "$ORTAKDRV"		2 17 10 0	 \
    " Acc. Klasör...:" 3 1    "$ACCKLASOR"		3 17 10 0	 \
	" Acc. Baslagıc.:" 4 1    "$ACCBASLANGIC"	4 17 5 0	 \
    " Acc. Bitiş....:" 5 1    "$ACCBITIM"		5 17 5 0	 \
    " Acc. Donuş....:" 6 1    "$ACCDONUS"		6 17 5 0	 \
	" O. DriveID....:" 7 1    "$DRVID"		7 17 21 0	 \
	" Root KlasörID.:" 8 1    "$ROOTID"		8 17 35 0	 \
    2>&1 >/dev/tty)

AYARICERIGI=($AYARDEGISTIR)
sed -i '/^\[KOPYALAMA]/,/^\[/{s/^Uzanti[[:space:]]*=.*/Uzanti = '${AYARICERIGI[0]}'/}' ~/ayarlar.db;
sed -i '/^\[KOPYALAMA]/,/^\[/{s/^OrtakDvr[[:space:]]*=.*/OrtakDvr = '${AYARICERIGI[1]}'/}' ~/ayarlar.db;
sed -i '/^\[KOPYALAMA]/,/^\[/{s/^AccKlasor[[:space:]]*=.*/AccKlasor = '${AYARICERIGI[2]}'/}' ~/ayarlar.db;
sed -i '/^\[KOPYALAMA]/,/^\[/{s/^AccBaslangic[[:space:]]*=.*/AccBaslangic = '${AYARICERIGI[3]}'/}' ~/ayarlar.db;
sed -i '/^\[KOPYALAMA]/,/^\[/{s/^AccBitis[[:space:]]*=.*/AccBitis = '${AYARICERIGI[4]}'/}' ~/ayarlar.db;
sed -i '/^\[KOPYALAMA]/,/^\[/{s/^AccDonus[[:space:]]*=.*/AccDonus = '${AYARICERIGI[5]}'/}' ~/ayarlar.db;
sed -i '/^\[plt]/,/^\[/{s/^team_drive[[:space:]]*=.*/team_drive = '${AYARICERIGI[6]}'/}' ~/.config/rclone/rclone.conf;
sed -i '/^\[plt]/,/^\[/{s/^root_folder_id[[:space:]]*=.*/root_folder_id = '${AYARICERIGI[7]}'/}' ~/.config/rclone/rclone.conf;

GIT KURULUM_MENU
;;
2)
echo "==============================================="
echo "Programlar Çalıştırılıyor . . ."
echo "==============================================="
cd ~
if mountpoint -q /root/depo
then
echo Depo Mount Edilmiş...
else
	mount /dev/md0 /root/depo
fi

if test -f "kp.sh"; then
mv ~/kp.sh ~/depo/kp.sh
fi
screen -dmS p bash -c 'bash p.sh';
sleep 1
cd ~/depo/
screen -dmS kp bash -c 'bash kp.sh';
sleep 1
cd ~
echo "==============================================="
echo "Tüm screenler çalıştırıldı."
echo "İşlem Tamamlandı."
echo "screen -r p"
echo "==============================================="
;;
3)
Disk0="/dev/nvme0n1"
Disk1="/dev/nvme1n1"
Disk2="/dev/nvme2n1"
Disk3="/dev/nvme3n1"
Disk4="/dev/nvme4n1"

Part=$(lsblk -no pkname $(findmnt -n / | awk '{ print $2 }'))

if [ "$Part" != "$Disk1" ]; then
Birlestir+="/dev/nvme1n1 "
parted -a optimal /dev/nvme1n1 mklabel gpt;
parted -a optimal /dev/nvme1n1 mkpart primary ext4 0% 100%;
parted -a optimal /dev/nvme1n1 set 1 raid on;
fi
if [ "$Part" != "$Disk2" ]; then
Birlestir+="/dev/nvme2n1 "
parted -a optimal /dev/nvme2n1 mklabel gpt;
parted -a optimal /dev/nvme2n1 mkpart primary ext4 0% 100%;
parted -a optimal /dev/nvme2n1 set 1 raid on;
fi
if [ "$Part" != "$Disk3" ]; then
Birlestir+="/dev/nvme3n1 "
parted -a optimal /dev/nvme3n1 mklabel gpt;
parted -a optimal /dev/nvme3n1 mkpart primary ext4 0% 100%;
parted -a optimal /dev/nvme3n1 set 1 raid on;
fi
if [ "$Part" != "$Disk4" ]; then
Birlestir+="/dev/nvme4n1 "
parted -a optimal /dev/nvme4n1 mklabel gpt;
parted -a optimal /dev/nvme4n1 mkpart primary ext4 0% 100%;
parted -a optimal /dev/nvme4n1 set 1 raid on;
fi

sudo mdadm --create /dev/md0 --level=0 --raid-devices=4 $Birlestir
sleep 1
mkfs.ext4 /dev/md0;
mkdir depo;
mount /dev/md0 depo;
mdadm --detail --scan;
mdadm --detail --scan >> /etc/mdadm/mdadm.conf;
update-initramfs -u;
sleep 1

echo "==============================================="
echo "DataBase Kuruluyor . . ."
echo "==============================================="
apt-get install man-db -y
sudo mandb
echo "==============================================="
echo "DNS Kuruluyor . . ."
echo "==============================================="
sudo apt install dnsutils -y;
sudo apt install resolvconf;
echo "==============================================="
echo "Rclone Kuruluyor . . ."
echo "==============================================="
sudo -v ; curl https://rclone.org/install.sh | sudo bash
echo "==============================================="
echo "G++ & CMAke Lib Kuruluyor . . ."
echo "==============================================="
apt-get install -y build-essential;
sudo apt install -y libsodium-dev cmake g++ git;
echo "==============================================="
echo "BladeBit Kuruluyor . . ."
echo "==============================================="
wget https://github.com/Chia-Network/bladebit/releases/download/v2.0.1/bladebit-v2.0.1-ubuntu-x86-64.tar.gz
tar -xf bladebit-v2.0.1-ubuntu-x86-64.tar.gz
sleep 1
rm -rf bladebit-v2.0.1-ubuntu-x86-64.tar.gz
echo "==============================================="
echo "Python3 Kuruluyor . . ."
echo "==============================================="
sudo apt install python3;
sudo apt install python3-pip -y;
sudo pip3 install telegram-send;
#telegram-send --configure
echo "==============================================="
echo "Kopyalama İşlemi Yapılıyor . . ."
echo "==============================================="
mkdir /root/.config;
mv ~/telegram-send.conf ~/.config/telegram-send.conf;
mkdir /root/.config/rclone;
mv ~/rclone.conf ~/.config/rclone/rclone.conf;
cd ~
if mountpoint -q /root/depo
then
mv ~/kp.sh ~/depo/kp.sh
fi
echo "==============================================="
echo "Kurulum Tamamlandı . . ."
echo "==============================================="
;;
esac
