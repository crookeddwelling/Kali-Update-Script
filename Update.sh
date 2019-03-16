#!/bin/bash
# Created by Nathan Clifford for Sir Sanford Fleming College CSI Students

# Description:
# This script is for updating, and performing basic configurations on Linux
# distros that use apt as the package manager (ie. Kali, Debian, Raspbian, Ubuntu).
# This means that if you're using a different package manager such as yum or zypper (ie. RedHat, Fedora, OpenSuse)
# then this script will probably not work on your OS.

# Script Usage Instructions:
# Copy this file to a location on your system (ie. ~/Desktop), ensuring that the file extension is .sh
# cd ~/Desktop
# chmod u+x Update.sh
# sudo ./Update.sh

### Correct errors from any previously failed installations (leave enabled):
sudo apt --fix-broken install -y
sudo dpkg --configure -a

# Correct "The following signatures were invalid" EXPKEYSIG error upon trying to run updates (This will occur if you haven't updated your Kali ISO for awhile):
wget -q -O - archive.kali.org/archive-key.asc | apt-key add

# Remove packages left in an "inconsistent state" (incompatible packages which fail to completely install):
#sudo dpkg --remove --force-remove-reinstreq --force-depends <package-name>
#sudo apt-get install -f --reinstall <package-name> #reinstall inconsistent state packages.

#Show distribution information:
sudo apt -qq install -y screenfetch linuxlogo #used to generate one of those nifty terminal theme information + ASCII distribution logos
echo ""
screenfetch #ascii art system info
#linuxlogo #more ascii art system info

# Current version info
echo ""
printf "${LGREEN}Current version info...${NC}\n"
lsb_release -irdc
printf "Kernal Version: ";uname -r
printf "Processor Type: ";uname -m

# Assign text colour for alert lines:  
RED='\033[0;31m' # Red
GREEN='\033[0;32m' # Green
LGREEN='\033[1;32m' # Light Green 
NC='\033[0m' # No Color
#change {TEXTCOLOR} to {RED}, {GREEN}, or {LGREEN} to change text colour.

### Needs improvement -pauses the rest of the updates
# Watch Disk Usage in a new Terminal window as updates are performed:
#printf "${LGREEN}Opening a new Terminal window to watch Disk Usage as updates are installed... Don't run out of space!${NC}\n"
#x-terminal-emulator --title="Disk Usage" -e watch df -T /root/

# Change system hostname:
#sudo nano /etc/hostname
#sudo nano /etc/hosts
#sudo reboot

# Add user account with sudo privileges:
#adduser gnarlyhaze sudo

### I think this has now been patched with Kali Updates.
### Allow Kali's NetworkManager to manage internet interfaces so that they show up in the menu bar (these lines only needs to run one time):
#echo ""
#printf "${LGREEN}Editing NetworkManager.conf to manage network interfaces from the menu icon...${NC}\n"
#head -n -1 /etc/NetworkManager/NetworkManager.conf > temp.txt ; mv temp.txt /etc/NetworkManager/NetworkManager.conf #removes last line in file
#sudo bash -c 'printf "managed=true\n" >> /etc/NetworkManager/NetworkManager.conf' #append a new last line into the file
#systemctl reload NetworkManager #reload the service with the new configuration

### Allow Kali's NetworkManager to manage internet interfaces so that they show up in the menu bar (alternate version):
#mv /etc/NetworkManager/NetworkManager.conf /etc/NetworkManager/NetworkManager.txt
#sed -i 's/false/true/g' /etc/NetworkManager/NetworkManager.txt
#mv /etc/NetworkManager/NetworkManager.txt /etc/NetworkManager/NetworkManager.conf

# Coax an easter-egg out of apt-get (just for lolz):
echo ""
apt-get moo # Have you moo'ed today?

### Install ntpdate internet time and sync time to server (leave enabled):
echo ""
printf "${LGREEN}Syncing System Clock to Internet Time...${NC}\n"
sudo apt -qq install -y ntpdate
sudo ntpdate -u ntp.ubuntu.com
#sudo ntpdate time.nist.gov #different time server
#dpkg-reconfigure tzdata #manually configure timezone

# Ensure ntp service runs at bootup
#update-rc.d ntp enable

### Needs improvement -pauses the rest of the updates
#Watch Start Wars in ASCII Art while the updates complete:
#echo ""
#printf "${LGREEN}These updates may take awhile... So here's Star Wars!${NC}\n"
#sudo apt -qq install -y telnet
#x-terminal-emulator --title="Star Wars" -e telnet towel.blinkenlights.nl

### Perform System Updates (leave enabled, these are the primary actions of this script):
echo ""
printf "${LGREEN}Performing System Updates - This may take some time...${NC}\n"
sudo apt clean
sudo apt update && sudo apt upgrade -y && sudo apt full-upgrade -y 

### Install Aptitude & Synaptic, and update Aptitude packages (leave enabled):
echo ""
printf "${LGREEN}Installing/Updating Aptitude & Synaptic Package Managers...${NC}\n"
sudo apt install -y synaptic # Synaptic package manager
sudo apt install -y  aptitude #Aptitude package manager
sudo aptitude update #update packages in Aptitude
sudo aptitude upgrade -y --full-resolver #upgrade packages in Aptitude

# Coax an easter-egg out of Aptitude (just for lolz): 
echo ""
aptitude moo 
aptitude -v moo
aptitude -vv moo
aptitude -vvvvv moo
aptitude -vvvvvv moo 

### Install & Run Unattended Upgrades - automatic installation of security upgrades (leave enabled):
echo ""
printf "${LGREEN}Installing Security Upgrades...${NC}\n"
sudo apt install -y unattended-upgrades
sudo unattended-upgrades

### Update SearchSploit
searchsploit -u

### Install NVIDIA Graphic Card Drivers:
echo ""
printf "${LGREEN}Installing NVIDIA Graphic Card Drivers...${NC}\n"
sudo apt install -y ocl-icd-libopencl1 nvidia-driver nvidia-cuda-toolkit

### Install Python and update PIP (it appears the system default is Python 2.7, change this to v3 at your own risk):
echo ""
printf "${LGREEN}Installing Python2 & Updating PIP...${NC}\n"

### Install Python 3:
#sudo apt install -y python3 python3-pip python3-dev python3-picamera

### Install Python 2:
sudo apt install -y python-pip python-dev 
sudo pip install virtualenv

#Upgrade PIP
pip install --upgrade pip

###Install SSH client & server
echo ""
printf "${LGREEN}Configuring SSH client & server...${NC}\n"
sudo apt install -y ssh #install and enable sshd
sudo apt install -y openssh-server
sudo apt install -y openssh-client
sudo apt install -y putty #gui ssh client

###SSH Setup
echo ""
printf "${LGREEN}Generating new SSH keys & starting SSH on boot...${NC}\n"
cd /etc/ssh/ && mkdir default_kali_keys && mv ssh_host_* default_kali_keys/ #Move default SSH keys
dpkg-reconfigure openssh-server && service ssh restart #Generate new SSH keys
service ssh start && update-rc.d -f ssh remove && update-rc.d ssh defaults #start SSH service after reboot by modifying run level settings

#Add SSH Warning Banner before SSH login
#nano /etc/issue.net #write your warning message in this file ie. "Authorized access only!"
#nano /etc/ssh/sshd_config #open sshd_config file
#uncomment "Banner /etc/issue.net"
#service ssh restart

### Set an SSH Welcome Banner after login - Message of the Day (MOTD)
#nano /etc/motd ##write your warning message in this file ie. "Welcome back to your system!"

### VNC client & server applications
echo ""
printf "${LGREEN}Installing VNC client & server applications...${NC}\n"
sudo apt install -y autocutsel #allows copy and paste text between applications
#sudo apt install -y x11vnc #Simple VNC Server
#x11vnc -storepasswd # Assign a VNC password for x11vnc
#sudo apt install -y tightvncserver #TightVNC -Kali's default VNC Server
#sudo apt install -y tightvncclient #TightVNC Client
#sudo apt install -y remmina # Similar to Windows Remote Desktop functions
#sudo apt install -y vmfs-tools #untested

### Install Terminal applications, notification applications
# update-alternatives --config x-terminal-emulator #set a default terminal emulator program
echo ""
printf "${LGREEN}Installing Terminal applications and Alternate Shells...${NC}\n"
sudo apt install -y terminator # My favorite Terminal emulator
mkdir /root/.config/terminator & cp terminator_config /root/.config/terminator/config #configure terminator
sudo apt install -y lxterminal # Another solid Terminal emulator
sudo apt install -y  guake #Drop down terminal emulator used with F12 - Also a favorite
#sudo apt install  yakuake #Light-weight drop down terminal emulator used with F12
sudo apt install -y undistract-me #notifications that watch for long running commands and create a popup when complete

### Install Alternate Terminal Shells
sudo apt install -y fish # the friendly interactive shell (fish)
sudo apt install -y zsh #An extended Bourne shell
#sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" #Install oh-my-zsh add-on for zsh (run-once)

#printf "${LGREEN}Changing Terminal shell - use "chsh -s bash" or "exec bash" to change back...${NC}\n"
#exec zsh #syntax to temporarily switch terminal shell (ie. to zsh, bash, sh, or fish)
#chsh -s $(which fish) #change default shell to fish
#chsh -s $(which zsh) #change default shell to zsh
sudo chsh -s /bin/bash #change default shell back to BASH

### Install Utility applications
echo ""
printf "${LGREEN}Installing Utility applications...${NC}\n"
sudo apt install -y gdebi #GUI for installing .deb files
sudo apt install -y sysvinit-utils
sudo apt install -y gnome-tweak-tool #OS option editor
sudo apt install -y alacarte #Applications menu customization options
sudo apt install -y orage #Calendar
sudo apt install -y git git-core #github commandline
sudo apt install -y ca-certificates # resolve issue where GitHub's SSL certificate isn't trusted
sudo apt install -y ack #Grep-like searching utility
sudo apt install -y unrar unace p7zip zip unzip p7zip-full p7zip-rar file-roller
#sudo apt install -y rar #no installation candidate

### Autokey text expander application
#sudo apt install -y  autokey-qt autokey-gtk autokey-common #untested

# Disk & File Utiltiies:
sudo apt install -y exfat-fuse #allows exfat fs to be used in Linux
sudo apt install -y htop #improved top terminal task manager
sudo apt install -y gparted #gparted disk utility
sudo apt install -y gdisk fdisk #command line disk utilities
sudo apt install -y partitionmanager #KDE Disk utility
sudo apt install -y di #advanced df like disk information utility
sudo apt install -y duc # high-performance disk usage analyzer
sudo apt install -y fatattr fatcat fatsort zerofree #utilities for working on FAT filesystems
#sudo apt install -y bleachbit #delete files securely
#sudo apt install -y k4dirstat #disk usage statistics viewer and cleanup tool

### Some Random Debian Utilities:
#sudo apt install -y  debian-goodies #Toolbox Utilities for Debian -installs dpigs, checkrestart, debget
#sudo apt install -y debian-installer-launcher #Bootable Debian Installer 
#sudo apt install -y bilibob bilibob-udev # Device management rules for OS running from external media #doesnt seem to work

### Install Hex Editors:
echo ""
#printf "${LGREEN}Installing Hex Editors...${NC}\n"
#sudo apt install -y bless #full featured hexadecimal editor
#sudo apt install -y hexedit #hexadecimal editor
#sudo apt install -y dhex
#sudo apt install -y jeex
#sudo apt install -y lfhex
#sudo apt install -y ncurses-hexedit
#sudo apt install -y tweak #text-mode hex editor
#sudo apt install -y wxhexeditor #hex editor for massive files
#sudo apt install -y hexcompare #shows commonalities and differences between two files

# System Benchmark applications:
echo ""
printf "${LGREEN}System Benchmark applications...${NC}\n"
sudo apt install -y smem powertop cpufrequtils laptop-mode-tools apmd consolekit sysbench hdparm
sudo apt install -y acpid acpi-support

### Docks & Dockapps (may require hiding the native window manager's dock):
echo ""
printf "${LGREEN}Installing Docks & Dockapps...${NC}\n"
#sudo apt install -y  cairo-dock cairo-dock-core cairo-clock cairo-dock-plug-ins #dynamic 3D dock, heavier. 
#aptitude -r install cairo-dock cairo-dock-plug-ins #install thru aptitude
#sudo apt install -y plank #simple dock
#sudo apt install -y mate-dock-applet mate-panel
#sudo apt install -y docky #powerful, clean dock

# Dockapps:
#sudo apt install -y alltray kdocker #Dock any program into the system tray
#sudo apt install -y wmcpuload # Dockapp that displays the current CPU usage
#sudo apt install -y wmtop #dockapp that displays 3 top memory or CPU using processes
#sudo apt install -y wmcore # Dockapp that shows the usage of each core in the system
#sudo apt install -y wmdiskmon #dockapp to display disk usage
#sudo apt install -y wmgtemp #Temperature monitor for the dock
#sudo apt install -y wmdrawer #Window Maker dockapp providing a drawer to launch applications
#sudo apt install -y wmbutton # dockapp displaying nine configurable buttons

### Install Antivirus & Firewall applications:
echo ""
printf "${LGREEN}Installing Antivirus & Firewall applications...${NC}\n"
#sudo apt install -y  clamav clamav-unofficial-sigs clamdscan clamtk clamtk-gnome clamtk-nautilus #Clam AntiVirus Utility
#sudo apt install -y  gufw ufw #Gufw Linux Firewall application

### Install Internet applications:
echo ""
printf "${LGREEN}Installing Internet applications...${NC}\n"
#sudo apt install -y  deluge-torrent # Torrent Client
#sudo apt install -y transmission # Torrent Client
sudo apt install -y uget #Download Manager
#sudo apt install -y xdman-downloader #Xtreme Download Manager
#sudo apt install -y filezilla filezilla-common #FTP client
#sudo apt install -y  links2 #A light in-terminal web browser
#sudo apt install -y nodejs npm # NodeJS & NPM JavaScript Web Development
#sudo apt install -y network-manager-gnome #gnome network manager
#sudo apt install -y wicd wicd-gtk #network manager
#sudo apt install -y nethogs #untested

sudo apt install -y flashplugin-nonfree #install flash
update-flashplugin-nonfree --install #update flash

# Speedtest Command Line, YoutubeDownloader:
echo ""
printf "${LGREEN}Installing Speedtest Command Line...${NC}\n"
sudo apt install -y speedtest-cli #speedtest from command line
#sudo apt install -y youtube-dl mps-youtube #download Youtube and other video sources from command line

### Install Text Editors:
echo ""
printf "${LGREEN}Installing Text Editors...${NC}\n"
sudo apt install -y geany # My favorite light text editor
sudo apt install -y leafpad # Basic text editor
#sudo apt install -y gedit # Basic text editor
#sudo apt install -y mousepad #xfce text editor
#sudo apt install -y kate # Text editor
#sudo apt install -y joe # Text editor
#sudo apt install -y install vim # text editor
#sudo apt install -y emacs # classic text editor /usr/share/emacs/*/lisp/play contains games
#sudo apt install -y kdevelop

### Install Office applications:
echo ""
printf "${LGREEN}Installing Office applications...${NC}\n"
sudo apt install -y libreoffice libreoffice-gnome # LibreOffice Suite
#sudo apt install -y openoffice # OpenOffice Suite
#sudo apt install -y abiword #GNOME word document processor
sudo apt install -y evince #PDF Viewer
sudo apt install -y kjots knotes #Notes program
#sudo apt install -y granule #Flashcard program for learning new words
#sudo apt install -y calcurse #Digital planner
#sudo apt install -y gnumeric #GNOME Spreadsheet Viewer
#sudo apt install -y glabels #This is for creating labels
#sudo apt install -y glom #This is for creating databases
#sudo apt install -y dia #This is for creating diagrams and flowcharts
#sudo apt install -y  libpam-google-authenticator #google authenticator support

### Media players applications, and graphics/video editing applications:
echo ""
printf "${LGREEN}Installing Media applications...${NC}\n"
#sudo apt install -y cmus #Command Line media player -might need to download tarball instead
sudo apt install -y clementine #Media player
#sudo apt install -y rhythmbox #Media player
sudo apt install -y vlc #VLC Player
#sudo apt install -y pinta #Microsoft Paint
#sudo apt install -y gimp #For editing images
#sudo apt install -y inkscape #For editing images
#sudo apt install -y digikam #Photography management program - its pretty big at 683MB
#sudo apt install -y shotwell #Photography management program
#sudo apt install -y feh #Lightweight image viewer with command line options to set images as screen background.
#sudo apt install -y nitrogen #Wallpaper browsing and managing utility

# Text-To-Speech modules:
echo ""
printf "${LGREEN}Installing Text-To-Speech Modules...${NC}\n"
sudo apt install -y espeak
sudo apt install -y flite
#sudo apt install -y festival

# Webcam applications:
#echo ""
#printf "${LGREEN}Installing Webcam applications...${NC}\n"
#sudo apt install -y at-spi2-core
#sudo apt install -y cheese #Webcam utility
#sudo apt install -y v4l-utils
#sudo modprobe bcm2835-v4l2 #Load webcam driver

# Chat & Email applications
#echo ""
#printf "${LGREEN}Installing Chat & Email Applications...${NC}\n"
#sudo apt install -y mutt # command line email client
#sudo apt install -y geary #mail client
#sudo apt install -y evolution #mail client
#sudo apt install -y pidgin #chat client

### Install Gnome applications
echo ""
printf "${LGREEN}Installing Gnome Applications...${NC}\n"
#sudo apt install -y gnome-core gnome #install full GNOME suite #1.8GB
sudo apt install -y gnome-tweak-tool #OS option editor

# Gnome Schedule - GUI for crontab:
#sudo apt install -y gnome-schedule #GUI for crontab ###Script not working
# cd ~/Downloads && git clone git://git.gnome.org/gnome-schedule

#Screenshot Tools
echo ""
printf "${LGREEN}Installing Screenshot Tools...${NC}\n"
sudo apt install -y gnome-screenshot
sudo apt install -y scrot
sudo apt install -y imagemagick
#sudo apt install -y shutter
#sudo apt install -y gtk-recordmydesktop recordmydesktop #Screen recorder software

###Linux Window Managers 
#update-alternatives --config x-window-manager #command to allow you to choose your window manager. The options so far are gdm3, xfce4, and awesome, MATE, and i3.
#dpkg-reconfigure gdm3 #command to allow you to choose your login screen. The options so far are gdm3, lightdm, and slim.
#Config files are found in /usr/share/xsessions, modify the .desktop files here
#sudo apt install -y glade #Design your own user interface
#sudo apt install -y choosewm #GUI window upon login to choose your Window Manager
#sudo apt remove -y choosewm #Remove choosewm as sometimes it causes issues.

echo ""
printf "${LGREEN}Installing Linux Window Managers...${NC}\n"

# Install XFCE Desktop Environment: ## This is my favourite
echo ""
printf "${LGREEN}Install XFCE Desktop Environment...${NC}\n"
sudo apt install -y kali-defaults kali-root-login desktop-base xfce4 xfce-keyboard-shortcuts xfce4-places-plugin xfce4-goodies
#echo ""
#printf "${LGREEN}Changing the XFCE Default Menu to WhiskerMenu...${NC}\n"
sudo apt-get install xfce4-whiskermenu-plugin
# Change to xiomd Theme - https://forums.kali.org/showthread.php?27107-Customising-Kali-2-x-XFCE-4-Window-Manager-axiomd-Theme
curl -s http://pastebin.com/raw.php?i=58wsGhBD | tr -d '\15\32' | bash
#Change default session to XFCE:
echo ""
printf "${LGREEN}Changing the default session to XFCE...${NC}\n"
echo xfce4-session > /root/.xsession
# Remove XFCE:
#sudo apt-get remove xfce4 xfce4-places-plugin xfce4-goodies

## KDE Desktop ##
# Install KDE Plasma Desktop Environment:
#sudo apt install -y kali-defaults kali-root-login desktop-base kde-plasma-desktop
# Install Standard Debian selected packages and frameworks:
#sudo apt install -y kali-defaults kali-root-login desktop-base kde-standard
# Install KDE Full Install:
#sudo apt install -y kali-defaults kali-root-login desktop-base kde-full
# Remove KDE:
#sudo apt-get remove kde-plasma-desktop kde-plasma-netbook kde-standard

## LXDE Desktop ##
# Install LXDE Desktop Environment:
#sudo apt install -y kali-defaults kali-root-login desktop-base lxde-core lxde 
# Remove LXDE:
#sudo apt-get remove lxde-core lxde

## GNOME Desktop ##
# How to install GNOME on Kali Linux:
#sudo apt install -y kali-defaults kali-root-login desktop-base gnome-core gnome-common
# Remove GNOME:
#sudo apt-get remove gnome-core

## Cinnamon Desktop ## This is also excellent
# Install Cinnamon Desktop Environment:
#sudo apt install -y kali-defaults kali-root-login desktop-base cinnamon cinnamon-control-center-data
# Remove Cinnamon Desktop Environment:
#apt-get remove cinnamon

## MATE Desktop (1) ##
#Install MATE Desktop Environment:
#sudo apt install -y kali-defaults kali-root-login desktop-base mate-core mate-desktop-environment mate-desktop-environment-extra
#sudo apt install -y mate-dock-applet mate-panel mozo #mozo is the MATE main menu editing tool
## MATE Desktop (2) ##
#echo "deb http://repo.mate-desktop.org/debian wheezy main" >> /etc/apt/sources.list && apt-get update
#apt-get --yes --quiet --allow-unauthenticated install mate-archive-keyring
# Remove MATE Desktop Environment:
#apt-get remove mate-core

##Budgie Desktop Environment##
#sudo apt install -y budgie-desktop

## Awesome Window Manager ##
#Install Awesome Window Manager:
#sudo apt install -y awesome awesome-extra

## FVWM Window Manager ##
#FVWM Window Manager:
#sudo apt install -y fvwm 

#Install i3 Window Manager (Use WindowsKey+Enter to open a new terminal window):
#sudo apt install -y  i3
#dpkg-reconfigure i3
#sudo apt install -y feh #Lightweight image viewer with command line options to set images as screen background.
#sudo apt install -y nitrogen #Wallpaper browsing and managing utility

#Mutter window manager:
#sudo apt install -y mutter #default window manager for gnome
#sudo apt install -y mutter #untested option

### Login Window Managers:
#LightDM Login Window Manager
#sudo apt install -y lightdm #lighter window manager default to Kali Light

#Install Slim Login Window Manager:
#sudo apt install -y  slim

#GnomeDisplayManager Login Window Manager (GDM3):
#sudo apt install -y  gdm #heavier window manager based on gnome
#sudo apt install -y gdm3 #heavier window manager based on gnome

#Kali Linux recommended installs (Enable these options if running Kali Linux to install pentesting utilities):
echo ""
printf "${LGREEN}Installing Kali Linux Recommended Installs...${NC}\n"
sudo apt install -y  kali-linux-top10 #Install the top ten Kali Linux Utilities
#sudo apt install -y kali-linux-full #full Kali Linux software suite #3GB

#Install Wireshark Application:
echo ""
printf "${LGREEN}Installing Wireshark...${NC}\n"
sudo apt install -y wireshark wireshark-gtk wireshark-qt # Wireshark
sudo apt install -y tcpdump #command line packet analyzer
#sudo dpkg-reconfigure wireshark-common #fix wireshark permission denied errors
#sudo adduser $USER wireshark

##Kali Linux Utilities:
echo ""
printf "${LGREEN}Installing Kali Linux Utilities...${NC}\n"
sudo apt install -y exploitdb exploitdb-papers exploitdb-bin-sploits #database of available exploits
sudo apt install -y seclists #multiple types of lists used during security assessments
sudo apt install -y autopsy sleuthkit # Autopsy digital forensics platform
sudo apt install -y forensics-colorize # show differences between files using color graphics

##Information Gathering/Scanner Utilities:
echo ""
printf "${LGREEN}Installing Scanning Utilities...${NC}\n"
sudo apt install -y nmap netcat # network exploration tool to perform security audits
sudo apt install -y 0trace # security reconnaissance/firewall bypassing tool
sudo apt install -y masscan #fast port scanner
sudo apt install -y firewalk #traceroute through firewall and find open ports
sudo apt install -y p0f #OS fingerprinting tool

##Kali Linux - Bruteforcing Utilities:
#echo ""
#printf "${LGREEN}Bruteforcing Utilities...${NC}\n"
#sudo apt install -y  john # JohnTheRipper -fast password cracker
#sudo apt install -y cewl #Custom Wordlist Generator allows you to create your own custom dictionary file.
#sudo apt install -y goldendict 
#sudo apt install -y rarcrack #untested

###Kali Linux - Anonymizing Utilities:
#sudo apt install -y squid3 #Squid Proxy
#sudo apt install -y macchanger #recommended to hide your MAC address while cracking a foreign wireless network.
#sudo apt install -y proxychains #tunnel kali commands thru proxy server. Hides source IP.

###VPN
#sudo apt install -y openvpn #vpn framework
#sudo apt install -y network-manager-openvpn
#sudo apt install -y network-manager-openvpn-gnome
#sudo apt install -y network-manager-pptp
#sudo apt install -y network-manager-pptp-gnome
#sudo apt install -y network-manager-strongswan
#sudo apt install -y network-manager-vpnc
#sudo apt install -y network-manager-vpnc-gnome

### Install Tor Steps:
#sudo apt install -y tor # Install the tor browser
#sudo apt install -y sudo
#adduser tor
#passwd tor
#service tor start

### Alternate Tor Installation Steps (untested)
#wget https://www.torproject.org/dist/torbrowser/4.5.3/tor-browser-linux32-4.5.3_en-US.tar.xz
#tar -xf tor-browser-linux32-4.5.3_en-US.tar.xz
#cd /root/Desktop/tor-browser_en-US/Browser/
#mv start-tor-browser start-tor-browser.txt
#sed -i 's/`id -u`" -eq 0/`id -u`" -eq 1/g' start-tor-browser.txt
#mv start-tor-browser.txt start-tor-browser
#cd ..
#ls -ld
#chown -R root:root .
#ls -ld

##Kali Linux - Vulnerability Analysis Utilities:
#sudo apt install -y nikto #web server testing tool

#Install & Setup Armitage and Metasploit Framework:
echo ""
printf "${LGREEN}Installing Armitage and Metasploit...${NC}\n"
sudo apt install -y metasploit-framework # Metasploit Framework
sudo apt install -y  armitage #Armitage GUI for Metasploit Framework
sudo gem install bundler #fix armitage dependencies
sudo gem update #fix armitage dependencies

# Update Metasploit Framework:
service postgresql start && msfdb init
msfdb start && msfdb stop
#msfupdate
apt update; apt install metasploit-framework #preferred update syntax

### Update Metasploit (alternate version)
#git clone https://github.com/rapid7/metasploit-framework.git /opt/exploitation/metasploit/

# Start the PostgreSQL Database for Armiteage:
#systemctl start postgresql
# Initialize the Metasploit Framework Database:
#msfdb init
# Start Armitage:
#armitage

# Configure postgresql to start on boot
#update-rc.d postgresql enable

##Kali Linux - MITM Attack Utilties:
#echo ""
#printf "${LGREEN}Installing MITM Attack Utilties...${NC}\n"
#sudo apt install -y stunnel4 #Stunnel creates secure communication between a TCP client and server by hiding another SSL envelope
#sudo apt install -y bridge-utils #bridge two ethernet ports together for MITM attacks.
#sudo apt install -y dsniff #ARP spoofing for MITM attacks.
#sudo apt install -y ettercap-graphical #Ettercap GUI MITM Attack Suite.
#sudo apt install -y ettercap-text-only #command-line version Ettercap which consumes less CPU resources.
#sudo apt install -y sslstrip #prevents SSL encrypted traffic for MITM Attacks

###Update some select Kali Utilities:
echo ""
printf "${LGREEN}Updating Select Kali Utilities...${NC}\n"
echo ""
printf "${LGREEN}Updating WPSCAN...${NC}\n"
wpscan --update
echo ""
printf "${LGREEN}Updating NIKTO...${NC}\n"
cd /usr/share/golismero/tools/nikto
perl nikto.pl -update
echo ""
printf "${LGREEN}Updating NESSUS...${NC}\n"
service nessusd stop
sleep 3
/opt/nessus/sbin/nessuscli update --all
sleep 3
service nessusd start

##Audio Utilities for Kali Linux (Kali's audio often doesn't work without these):
echo ""
printf "${LGREEN}Installing Audio Utilities...${NC}\n"
sudo apt install -y alsa-utils #fix sound mute on Kali Linux on boot
sudo apt install -y  alsa-tools alsa-tools-gui alsa-oss alsamixergui libalsaplayer0 #audio player files
sudo apt install -y kmix #audio files
#sudo apt install -y  mpg321 #command line mp3 player

# Amusing Programs & Linux Games:
echo ""
printf "${LGREEN}Installing Linux Games & Amusing Programs...${NC}\n"
#sudo apt install -y fortunes fortune-mod #Terminal fortune cookies -needs to be configured in Kali
#sudo apt install -y fortunes-debian-hints
#sudo apt install -y fortunes-mario 
#sudo apt install -y fortunes-off #offensive fortunes
sudo apt install -y fortunes-min #minimum fortunes
sudo apt install -y xcowsay cowsay #this is an important package -needs to be configured in Kali
#sudo gem install lolcat
#sudo apt install -y xfireworks xfishtank # Fireworks/Aquarium in your root window
#sudo apt install -y toilet #generates ASCII Art
#sudo apt install -y figlet #generates ASCII Art
#sudo apt install -y jp2a #changes any picture that you want into ASCII art
#sudo apt install -y pacman pacman4console #Pacman game
#sudo apt install -y fretsonfire fretsonfire-game #Frets on Fire (Guitar Hero Clone) Game
sudo apt install -y sl #terminal steam locamotive
### Open a window to show where Linux games are stored (they're run by prefacing the filename with ./ just like any other program):
#echo ""
#printf "${LGREEN}Linux Games can be found here...${NC}\n"
#cd /usr/games/ && xdg-open .

### Change Kali Login Wallpaper #Place wallpaper that you want to make as Kali Login Wallpaper on Desktop and rename it "login-background.png"
#cd /usr/share/images/desktop-base/
#mv login-backgroung.{png,png.bak}
#mv ~/Desktop/login-background.png /usr/share/images/desktop-base/

### Upgrade Rasberry Pi firmware (It will break Kali_ARM horribly) - DO NOT ENABLE THIS OPTION unless you know what you are doing!!!
#sudo curl -L --output /usr/bin/rpi-update https://raw.githubusercontent.com/Hexxeh/rpi-update/master/rpi-update && sudo chmod +x /usr/bin/rpi-update
#sudo apt install -y rpi-update
#sudo rpi-update
#sudo sync && sudo reboot

### Overclock Raspberry Pi SD card reader (requires at least a Class 10 U1 MicroSD Card) - DO NOT ENABLE THIS OPTION unless you know what you are doing!!!
#sudo bash -c 'printf "dtoverlay=sdhost,overclock_50=100\n" >> /boot/config.txt'
#sudo sync && sudo reboot

### Create a swap file on flash storage (This can make the Linux OS run much quicker) - DO NOT ENABLE THIS OPTION unless you know what you are doing!!! :
#sudo dd if=/dev/zero of=/swapfile.img bs=1M count=1024
#sudo mkswap /swapfile.img
#chmod 0600 /swapfile.img
#sudo swapon /swapfile.img
#sudo bash -c 'printf "/swapfile.img none swap sw 0 0\n" >> /etc/fstab' #append a new last line into the /etc/fstab file - untested

#Clean-up unused packages (leave enabled):
echo ""
printf "${LGREEN}Cleaning Up...${NC}\n"
sudo apt autoclean -y
sudo apt autoremove -y

### Prompt user to restart system after completing updates (leave enabled):
echo ""
cd /usr/games/ && ./sl 
cd /usr/games/ && ./xcowsay "Hello $USER! Thanks for waiting - Your updates have completed!" 
printf "${LGREEN}Updates Completed - Consider restarting the system!${NC}\n"
cd /usr/games/ && ./cowsay "Hello $USER! Thanks for waiting - Your updates have completed!" 

#printf "${LGREEN}System will reboot automatically in FIVE minutes - please save your work!${NC}\n"
#sudo sync && sudo shutdown -r +5
