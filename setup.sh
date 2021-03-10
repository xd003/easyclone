#!/usr/bin/env bash
#=============================================================
# https://github.com/xd003/clone
# File Name: setup.sh
# Author: xd003
# Description: Installing prerequisites for clone script
# System Supported: Arch , Ubuntu/Debian , Fedora & Termux
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
    pkg install -y unzip git wget tsu tmux
    if [ ! -d ~/storage ]; then
        cecho r "Setting up storage access for Termux"
        termux-setup-storage
        sleep 2
    fi
elif [ "$epac" == "/usr/bin/pacman" ]; then
    cecho g "Arch based OS detected" && \
    sudo pacman --noconfirm -S unzip git wget tmux
elif [ "$eapt" == "/usr/bin/apt" ]; then 
    cecho g "Ubuntu based OS detected" && \
    sudo apt install -y unzip git wget tmux
elif [ "$ednf" == "/usr/bin/dnf" ]; then
    cecho g "Fedora based OS detected"
    sudo dnf install -y unzip git wget tmux
fi
cecho b "All dependencies were installed successfully"

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
rm -rf $HOME/tmp
mkdir $HOME/tmp
git clone https://github.com/xd003/easyclone $HOME/tmp
if [ "$ehome" == "/data/data/com.termux/files/home" ]; then
    mv $HOME/tmp/clone $spath
    chmod u+x $spath/clone
else  
    sudo mv $HOME/tmp/clone $spath
    sudo chmod u+x $spath/clone
fi

# Moving rclone Config file to easyclone folder
rm -rf $HOME/easyclone/rc.conf
mv $HOME/tmp/rc.conf $HOME/easyclone
sed -i "s|HOME|$ehome|g" $conf

# Pulling the accounts folder containing service accounts from github 
echo
if [ -d "$HOME/easyclone/accounts" ] && [ -f "$HOME/easyclone/accounts/1.json" ]; then
    cecho b "Accounts folder containing service accounts already exists // Skipping"
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

####################################################################
echo
cat << EOF
1. Sasync + Rclone
2. Lclone
EOF
read -e -p "What would you like to use : " opt
case $opt in
1)
  # Downloading rclone 
  case $ehome in
  /data/data/com.termux/files/home)
    pkg install rclone
    ;;
  *)
    curl https://rclone.org/install.sh | sudo bash
    ;;
  esac

  # Moving sasync files to easyclone folder & adjusting sasync config
  rm -rf $HOME/easyclone/sasync
  mv $HOME/tmp/sasync $HOME/easyclone
  echo 1 > $HOME/easyclone/sasync/json.count
  jc="$(ls -l $HOME/easyclone/accounts | egrep -c '^-')"
  sed -i "7s/999/$jc/" $HOME/easyclone/sasync/sasync.conf
  if [ "$ehome" == "/data/data/com.termux/files/home" ]; then
    sed -i '29d' $(which clone)
    sed -i '116d' $(which clone)
    sed -i '123d' $(which clone)
    sed -i '130d' $(which clone)
  else
    sudo sed -i '29d' $(which clone)
    sudo sed -i '116d' $(which clone)
    sudo sed -i '123d' $(which clone)
    sudo sed -i '130d' $(which clone)
  fi
  ;;
2)
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

  # Downloading and adding lclone to path
  elclone="$(lclone version)"
  check="$(echo "$elclone" | grep 'v1\.55\.0-DEV')"
  if [ -z "${check}" ] ; then
    lclone_version="v1.55.0-DEV"
    URL=http://easyclone.xd003.workers.dev/0:/lclone/lclone-$lclone_version-linux-$arch.zip
    wget -c -t 0 --timeout=60 --waitretry=60 $URL -O $HOME/tmp/lclone.zip
    unzip -q $HOME/tmp/lclone.zip -d $HOME/tmp
    if [ "$ehome" == "/data/data/com.termux/files/home" ]; then
        mv $HOME/tmp/lclone $spath
        chmod u+x $spath/lclone
    else     
        sudo mv $HOME/tmp/lclone $spath
        sudo chmod u+x $spath/lclone
    fi
  cecho b "lclone successfully installed / updated"
  else
    cecho b "lclone binary already exists in path // Skipping"
  fi
  if [ "$ehome" == "/data/data/com.termux/files/home" ]; then
    sed -i '115d' $(which clone)
    sed -i '122d' $(which clone)
    sed -i '129d' $(which clone)
    sed -i "s|rclone|lclone|g" $conf
  else
    sudo sed -i '115d' $(which clone)
    sudo sed -i '122d' $(which clone)
    sudo sed -i '129d' $(which clone)
    sudo sed -i "s|rclone|lclone|g" $conf
  fi
  ;;
esac

rm -rf $HOME/tmp
echo
cecho g "Entering clone will always start the script henceforth"
