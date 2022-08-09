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

banner () {
clear
cat << EOF
╭━━━╮╱╱╱╱╱╱╱╱╱╱╱╱╭╮
┃╭━━╯╱╱╱╱╱╱╱╱╱╱╱╱┃┃
┃╰━━┳━━┳━━┳╮╱╭┳━━┫┃╭━━┳━╮╭━━╮
┃╭━━┫╭╮┃━━┫┃╱┃┃╭━┫┃┃╭╮┃╭╮┫┃━┫
┃╰━━┫╭╮┣━━┃╰━╯┃╰━┫╰┫╰╯┃┃┃┃┃━┫
╰━━━┻╯╰┻━━┻━╮╭┻━━┻━┻━━┻╯╰┻━━╯
╱╱╱╱╱╱╱╱╱╱╭━╯┃
╱╱╱╱╱╱╱╱╱╱╰━━╯
EOF
}
banner

#Variables 
arch="$(uname -m)"
ehome="$(echo $HOME)"
epac="$(which pacman 2>/dev/null)" 
eapt="$(which apt 2>/dev/null)"
ednf="$(which dnf 2>/dev/null)"
conf="$HOME/easyclone/rc.conf"

# Detecting the OS and installing required dependencies
echo
if [ "$ehome" == "/data/data/com.termux/files/home" ]; then
    cecho g "¶ Termux detected | Installing required packages" && \
    pkg update && pkg install -y unzip git wget tsu python tmux &>/dev/null 
    if [ ! -d ~/storage ]; then
        cecho r "Setting up storage access for Termux"
        termux-setup-storage
        sleep 2
    fi
elif [ "$epac" == "/usr/bin/pacman" ]; then
    cecho g "¶ Arch based OS detected | Installing required packages" && \
    sudo pacman -Syy && sudo pacman --noconfirm -S unzip git wget python tmux 
elif [ "$eapt" == "/usr/bin/apt" ]; then 
    cecho g "¶ Ubuntu based OS detected | Installing required packages" && \
    sudo apt update && sudo apt install -y unzip git wget python3 tmux 
elif [ "$ednf" == "/usr/bin/dnf" ]; then
    cecho g "¶ Fedora based OS detected | Installing required packages"
    sudo dnf check-update && sudo dnf install -y unzip git wget python3 tmux 
fi

# Detecting Source path for binaries and script to be added
spath="$(which git)"
spath=$(echo $spath | sed 's/\/git$//')

# Downloading latest easyclone script from github
cecho g "¶ Downloading latest easyclone script from github"
if [ "$ehome" == "/data/data/com.termux/files/home" ]; then
    rm -rf $(which clone) &>/dev/null 
else
    sudo rm -rf $(which clone) &>/dev/null 
fi
rm -rf $HOME/tmp
mkdir $HOME/tmp
git clone https://github.com/xd003/easyclone $HOME/tmp  &>/dev/null
mkdir -p $HOME/easyclone
mv $HOME/tmp/gclone $HOME/easyclone

find $HOME/easyclone -type d -empty -delete
cecho g "¶ Pulling the accounts folder containing service accounts from github" 
if [ ! -d "$HOME/easyclone/accounts" ]; then
    mkdir -p $HOME/easyclone/accounts
    read -e -p "Input your github username : " username
    echo && echo "If you dont have a personal access token , you can generate one following this guide - https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token"
    echo && read -e -p "Input your github's personal access token : " password
    while ! git clone https://"$username":"$password"@github.com/"$username"/accounts $HOME/easyclone/accounts; do 
      cecho r 'Invalid username or password, please retry' >&2;
      read -e -p "Input your github username : " username
      read -e -p "Input your github's personal access token : " password
    done
fi

cecho g "¶ Renaming the json files in numerical order"
rm -rf $HOME/easyclone/accounts/.git
if [ ! -f "$HOME/easyclone/accounts/5.json" ] ; then 
  (cd $HOME/easyclone/accounts; ls -v | cat -n | while read n f; do mv -n "$f" "$n.json"; done)
elif [ ! -f "$HOME/easyclone/accounts/10.json" ] ; then
  (cd $HOME/easyclone/accounts; ls -v | cat -n | while read n f; do mv -n "$f" "$n.json"; done)
elif [ ! -f "$HOME/easyclone/accounts/15.json" ] ; then
  (cd $HOME/easyclone/accounts; ls -v | cat -n | while read n f; do mv -n "$f" "$n.json"; done)
fi
  

# Moving gclone Config file & bookmark.txt to easyclone folder
cecho g "¶ Moving the config file to easyclone folder"
rm -rf $HOME/easyclone/rc.conf
mv $HOME/tmp/rc.conf $HOME/easyclone
if [ ! -f "$HOME/easyclone/bookmark.txt" ] ; then 
  mv $HOME/tmp/bookmark.txt $HOME/easyclone
fi
sed -i "s|HOME|$ehome|g" $conf

gcloneinstall() {
if [ "$arch" == "x86_64" ] ; then
  arch=amd64
elif [ "$arch" == "arm64" ] ; then
  arch=arm64
elif [ "$arch" == "*" ] ; then
  cecho r "Unsupported Kernel architecture , try installing gclone manually" && \
  exit
fi

cecho g "¶ Downloading and adding gclone to path"
egclone="$(gclone version 2>/dev/null)"
check="$(echo "$egclone" | grep 'v1\.59\.0')"
if [ -z "${check}" ] ; then
  gclone_version="v1.59.0-abe"
  if [ "$arch" == "aarch64" ] ; then
    URL=
  else
    URL=https://github.com/l3v11/gclone/releases/download/$gclone_version/gclone-$gclone_version-linux-$arch.zip
  fi
  wget -c -t 0 --timeout=60 --waitretry=60 $URL -O $HOME/tmp/gclone.zip &>/dev/null
  unzip -q $HOME/tmp/gclone.zip -d $HOME/tmp &>/dev/null
  if [ "$ehome" == "/data/data/com.termux/files/home" ]; then
      mv $HOME/tmp/gclone-$gclone_version-linux-$arch/gclone $spath
      chmod u+x $spath/gclone
  else     
      sudo mv $HOME/tmp/gclone-$gclone_version-linux-$arch/gclone $spath
      sudo chmod u+x $spath/gclone
  fi
fi
}

gcloneinstall

####################################################################

echo
cecho g "¶ Creating Symlink for clone script in path"
if [ "$ehome" == "/data/data/com.termux/files/home" ]; then
  ln -sf "$HOME/easyclone/gclone" "$spath/clone"
  chmod u+x $spath/clone
else
  sudo ln -sf "$HOME/easyclone/gclone" "$spath/clone"
  sudo chmod u+x $spath/clone
fi

# Shorten Expanded Variable
if [ "$ehome" == "/data/data/com.termux/files/home" ]; then
  sed -i "s|--config=$HOME/easyclone/rc.conf|--config=$conf|g" $(which clone)
else
  sudo sed -i "s|--config=$HOME/easyclone/rc.conf|--config=$conf|g" $(which clone)
fi

rm -rf $HOME/tmp
cecho g "¶ Installation 100% successful"
echo
cecho g "✓ Entering clone will always start the script henceforth"
