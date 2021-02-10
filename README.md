# easyclone
This is just a bash script which aims to ease the process of cloning , moving and syncing and other rclone operations.
The script uses [crop](https://github.com/l3uddz/crop) to bypass the 750GB daily limit by google present in rclone by rotating the service accounts

# Features
* Easy one command installation from scratch does everything
* Linux 64 bit OS supported ( including termux root + unrooted )
* Dynamic generation of rclone config based on input so no need to create any config
* Easy one word execution to invoke script
* Uses stable & latest rclone to rotate service accounts so no need to use outdated or unstable mods

# How to install / update
* ```bash <(curl -L http://tiny.cc/easyclone)```

Installation is as easy as just running the above command .It will setup everything from scratch .Accordingly run it at a later stage to update script and binaries as and when needed.
Proceeding installation, just enter ```clone``` whenever you need to execute the script henceforth 

# Pre Requisites
* Firstly , you should have generated the service accounts and have them downloaded in a folder named accounts. Follow steps from [here](https://github.com/smartass08/Service-Accounts-to-Google-groups/blob/master/README.md) if you don't have service accounts yet. Also rename any of the json file as 1.json inside accounts folder
* Secondly , you need to make a new repository named accounts in your github account and upload all the service accounts json files directly in that repo.
* ( Optional )  You can generate your own client id & secret from [here](https://developers.google.com/drive/api/v3/quickstart/python). There will be a option to enter it during installation

# Credits
* [rclone](https://github.com/rclone/rclone)
* [l3uddz](https://github.com/l3uddz/crop)    
