#!/usr/bin/env bash
#=============================================================
# https://github.com/xd003/clone
# File Name: setup.sh
# Author: xd003
# Description: Installing prerequisites for clone script
# System Supported: Arch , Ubuntu/Debian , Fedora & Termux ( amd64 & arm64 )
#=============================================================

cecho() {
        local code="\033["
        case "$1" in
                black  | bk) color="${code}0;30m";;
                red    |  r) color="${code}1;31m";;
                green  |  g) color="${code}1;32m";;
                yellow |  y) color="${code}1;33m";;
                blue   |  b) color="${code}1;34m";;
                purple |  p) color="${code}1;35m";;
                cyan   |  c) color="${code}1;36m";;
                gray   | gr) color="${code}0;37m";;
                *) local text="$1"
        esac
        [ -z "$text" ] && local text="$color$2${code}0m"
        echo -e "$text"
}

#Variables 
crop_version=v0.6.0
arch="$(uname -m)"
ehome="$(echo $HOME)"
epac="$(which pacman)"
eapt="$(which apt)"
ednf="$(which dnf)"
conf="$HOME/easyclone/rc.conf"
eclone="$(which rclone)"

# Detecting the OS and installing required dependencies
echo
cecho r "Detecting the OS and installing required dependencies"
if [ "$ehome" == "/data/data/com.termux/files/home" ]; then
    cecho g "Termux detected" && \
    pkg install -y unzip git wget tsu
    if [ ! -d ~/storage ]; then
        cecho r "Setting up storage access for Termux"
        termux-setup-storage
        sleep 2
    fi
elif [ "$epac" == "/usr/bin/pacman" ]; then
    cecho g "Arch based OS detected" && \
    sudo pacman --noconfirm -S unzip git wget
elif [ "$eapt" == "/usr/bin/apt" ]; then 
    cecho g "Ubuntu based OS detected" && \
    sudo apt install -y unzip git wget
elif [ "$ednf" == "/usr/bin/dnf" ]; then
    cecho g "Fedora based OS detected"
    sudo dnf install -y unzip git wget
fi
cecho b "All dependencies were installed successfully"

# Detecting the linux kernel architecture
echo
cecho r "Detecting the kernel architecture"
if [ "$arch" == "arm64" ] || [ "$ehome" == "/data/data/com.termux/files/home" ] ; then
  arch=arm64
elif [ "$arch" == "x86_64" ] ; then
  arch=amd64
elif [ "$arch" == "*" ] ; then
  cecho r "Unsupported Kernel architecture" && \
  exit
fi

# Detecting Source path for binaries and script to be added
spath="$(which git)"
spath=$(echo $spath | sed 's/\/git$//')

# Downloading latest easyclone script from github
echo
cecho r "Downloading latest easyclone script from github"
if [ "$ehome" == "/data/data/com.termux/files/home" ]; then
    rm -rf $(which clone)
else
    sudo rm -rf $(which clone)
fi
mkdir $HOME/tmp
git clone https://github.com/xd003/easyclone $HOME/tmp
if [ "$ehome" == "/data/data/com.termux/files/home" ]; then
    mv $HOME/tmp/clone $spath
    chmod u+x $spath/clone
else  
    sudo mv $HOME/tmp/clone $spath
    sudo chmod u+x $spath/clone
fi

# Downloading rclone 
case $ehome in
/data/data/com.termux/files/home)
  pkg install rclone
  ;;
*)
  curl https://rclone.org/install.sh | sudo bash
  ;;
esac

# Downloading and adding crop to path
if [ "$ehome" == "/data/data/com.termux/files/home" ]; then
    rm -rf $(which crop)
else    
    sudo rm -rf $(which crop)
fi
URL=http://easyclone.xd003.workers.dev/0:/crop/crop-$crop_version-linux-$arch.zip
wget -c -t 0 --timeout=60 --waitretry=60 $URL -O $HOME/tmp/crop.zip
unzip -q $HOME/tmp/crop.zip -d $HOME/tmp
if [ "$ehome" == "/data/data/com.termux/files/home" ]; then
    mv $HOME/tmp/crop $spath
    chmod u+x $spath/crop
else     
    sudo mv $HOME/tmp/crop $spath
    sudo chmod u+x $spath/crop
fi
cecho b "crop successfully updated"

# Moving config files to easyclone folder
rm -rf $HOME/easyclone/rc.conf
rm -rf $HOME/easyclone/config.yaml
mkdir -p $HOME/easyclone/cache
mv $HOME/tmp/rc.conf $HOME/easyclone
mv $HOME/tmp/config.yaml $HOME/easyclone

rm -rf $HOME/tmp

# Pulling the accounts folder containing service accounts from github 
echo
if [ -d "$HOME/easyclone/accounts" ] && [ -f "$HOME/easyclone/accounts/1.json" ]; then
    cecho b "accounts folder containing service accounts already exists //Skipping"
else
    mkdir -p $HOME/easyclone/accounts
    cecho r "Downloading the service accounts from your private repo"
    read -e -p "Input your github username : " username
    read -e -p "Input your github password : " password
    while ! git clone https://"$username":"$password"@github.com/"$username"/accounts $HOME/easyclone/accounts; do
      cecho r 'Invalid username or password, please retry' >&2;
      read -e -p "Input your github username : " username
      read -e -p "Input your github password : " password
    done
    cecho b "Service accounts were added Successfully"
fi

# Adding Client_id & secret to rc.conf
echo
while true; do
  read -e -p "Do you want to use your own client_id & client_secret [y/n] : " opt
  case $opt in
  [Yy]* )
    read -e -p "Enter your client_id : " id
    read -e -p "Enter your client_secret : " secret
    sed -i "3s/$/ $id/" $conf
    sed -i "4s/$/ $secret/" $conf
    sed -i "10s/$/ $id/" $conf
    sed -i "11s/$/ $secret/" $conf
    cecho b "Successfully added client_id & secret to the config file";
    break
    ;;
  [Nn]* )
    echo "skipping client_id and client_secret input";
    break
    ;;
  * )
    cecho r "Invalid Input Entered , try again"
    ;;
  esac
done

# Adjusting Config 
sed -i "2i\  config: $ehome/easyclone/rc.conf" $HOME/easyclone/config.yaml
sed -i "3i\  path: $eclone" $HOME/easyclone/config.yaml

echo
cecho g "Entering clone will always start the script henceforth"
